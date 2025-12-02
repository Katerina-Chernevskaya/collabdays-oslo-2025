// Parameters
@minLength(2)
@maxLength(6)
@description('Name for the AI resource and used to derive name of dependent resources.')
param name string

@description('Azure region used for the deployment of all resources.')
param location string = resourceGroup().location

// Principal ID
@description('The principal ID of the identity running the deployment')
param deploymentPrincipalId string

@allowed([
  'Standard_LRS'
  'Standard_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Premium_LRS'
  'Premium_ZRS'
])
@description('Storage SKU')
param storageSkuName string = 'Standard_LRS'

@allowed(['Storage', 'StorageV2', 'BlobStorage', 'FileStorage', 'BlockBlobStorage'])
param storageKind string = 'StorageV2'

// Create a short, unique suffix, that will be unique to each resource group
var uniqueSuffix = substring(uniqueString(resourceGroup().id), 0, 4)

// Dependent resources for the Azure AI Studio
var applicationInsightsName = 'appi-${name}-${uniqueSuffix}'
var logAnalyticsWorkspaceName = 'law-${name}-${uniqueSuffix}'
var storageName = 'st-${name}-${uniqueSuffix}'
var containerName = 'container-${name}-${uniqueSuffix}'
var keyvaultName = 'kv-${name}-${uniqueSuffix}'
var aiFoundryAccountName = 'aifa-${name}-${uniqueSuffix}'
var aiFoundryProjectName = 'aifp-${name}-${uniqueSuffix}'
var searchName = 'search-${name}-${uniqueSuffix}'

// Cleaned names for some resources
var storageNameCleaned = replace(storageName, '-', '')

// Modules

// Dependent resources

// module: Monitor
module monitor './modules/monitor.bicep' = {
  name: logAnalyticsWorkspaceName
  params: {
    namelaw: logAnalyticsWorkspaceName
    nameappins: applicationInsightsName
    location: location
  }
}

// module: Key Vault
module keyVault './modules/key-vault.bicep' = {
  name: keyvaultName
  params: {
    name: keyvaultName
    location: location
    objectId: deploymentPrincipalId
  }
}

// module: Storage Account
module storageAccount './modules/storage-account.bicep' = {
  name: storageNameCleaned
  params: {
    name: storageNameCleaned
    containerName: containerName
    location: location
    kind: storageKind
    skuName: storageSkuName
  }
}

// module: Azure AI Search
module aiSearch './modules/ai-search.bicep' = {
  name: searchName
  params: {
    name: searchName
    location: location
    storageName: storageNameCleaned
  }
  dependsOn: [
    storageAccount
  ]
}

// module: AI Foundry
module aiFoundry './modules/foundry-project.bicep' = {
  name: aiFoundryAccountName
  params: {
    aiFoundryAccountName: aiFoundryAccountName
    aiFoundryProjectName: aiFoundryProjectName
    location: location
  }
}

//module: AI Foundry connections
module aifConnections './modules/foundry-project-connections.bicep' = {
  name: '${aiFoundryAccountName}-connections'
  params: {
    aiFoundryAccountName: aiFoundryAccountName
    connectedAISearch: searchName
    connectedAppInsights: applicationInsightsName
  }
  dependsOn: [
    aiFoundry
    aiSearch
    monitor
    storageAccount
  ]
}



output containerName string = storageAccount.outputs.containerName
output storageId string = storageAccount.outputs.id
output storageName string = storageAccount.outputs.name

output applicationInsightsName string = monitor.outputs.appInsightsName
output logAnalyticsWorkspaceName string = monitor.outputs.logAnalyticsWorkspace
output keyvaultName string = keyVault.outputs.name
output searchName string = aiSearch.outputs.name
output aiFoundryAccountName string = aiFoundry.outputs.aiFoundryAccountName
output aiFoundryProjectName string = aiFoundry.outputs.aiFoundryProjectName
output model41 string = aiFoundry.outputs.model41
output modelAda string = aiFoundry.outputs.modelAda
