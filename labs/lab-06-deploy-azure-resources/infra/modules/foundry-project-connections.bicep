// params

param aiFoundryAccountName string
param connectedAISearch string
param connectedAppInsights string

// Refers your existing Azure AI Foundry resource
resource aiFoundry 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' existing = {
  name: aiFoundryAccountName
  scope: resourceGroup()
}

// Refers your existing Azure AI Search resource
resource existingSearchService 'Microsoft.Search/searchServices@2025-02-01-preview' existing = {
  name: connectedAISearch
}

// Creates the Azure Foundry connection to your Azure AI Search resource
resource ais_connection 'Microsoft.CognitiveServices/accounts/connections@2025-04-01-preview' = {
  name: '${aiFoundryAccountName}-aisearch'
  parent: aiFoundry
  properties: {
    category: 'CognitiveSearch'
    target: existingSearchService.properties.endpoint
    authType: 'ApiKey' // Supported auth types: ApiKey, AAD
    isSharedToAll: true
    credentials: { 
      key: existingSearchService.listAdminKeys().primaryKey
    }
    metadata: {
      ApiType: 'Azure'
      ResourceId: existingSearchService.id
      location: existingSearchService.location
    }
  }
}

// Refers your existing Azure Application Insights resource
resource existingAppInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: connectedAppInsights
}

// Creates the Azure Foundry connection to your Azure App Insights resource
resource appinsights_connection 'Microsoft.CognitiveServices/accounts/connections@2025-04-01-preview' = {
  name: '${aiFoundryAccountName}-appinsights'
  parent: aiFoundry
  properties: {
    category: 'AppInsights'
    target: existingAppInsights.id
    authType: 'ApiKey'
    isSharedToAll: true
    credentials: {
      key: existingAppInsights.properties.ConnectionString
    }
    metadata: {
      ApiType: 'Azure'
      ResourceId: existingAppInsights.id
    }
  }
}



