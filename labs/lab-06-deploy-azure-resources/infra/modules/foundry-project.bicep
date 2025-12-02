// params

@description('Resource Location')
param location string

@description('AI Foundry account name (resource name)')
param aiFoundryAccountName string

@description('Project name shown in Azure AI Foundry')
param aiFoundryProjectName string

resource aiFoundry 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' = {
  name: aiFoundryAccountName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'S0' // per Foundry account requirements
  }
  kind: 'AIServices' // per Foundry account requirements
  properties: {
    allowProjectManagement: true // required to work in AI Foundry
    customSubDomainName: aiFoundryAccountName // Defines developer API endpoint subdomain
    disableLocalAuth: false
  }
}

resource aiProject 'Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview' = {
  parent: aiFoundry
  name: aiFoundryProjectName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}

// Deploy models to use in playground, agents and other tools
resource modelDeployment_chat 'Microsoft.CognitiveServices/accounts/deployments@2024-10-01'= {
  parent: aiFoundry
  name: '${aiFoundryAccountName}-4.1'
  sku : {
    capacity: 5
    name: 'GlobalStandard'
  }
  properties: {
    model:{
      name: 'gpt-4.1'
      format: 'OpenAI'
    }
    raiPolicyName: 'Microsoft.Default'
    versionUpgradeOption: 'OnceCurrentVersionExpired'
  }
}

resource modelDeployment_embedding 'Microsoft.CognitiveServices/accounts/deployments@2024-10-01'= {
  parent: aiFoundry
  name: '${aiFoundryAccountName}-ada'
  sku : {
    capacity: 5
    name: 'GlobalStandard'
  }
  properties: {
    model:{
      name: 'text-embedding-ada-002'
      format: 'OpenAI'
    }
    raiPolicyName: 'Microsoft.Default'
    versionUpgradeOption: 'OnceCurrentVersionExpired'
  }
  dependsOn: [
    modelDeployment_chat
  ]
}

// outputs
output aiFoundryAccountName string = aiFoundry.name
output aiFoundryProjectName string = aiProject.name
output model41 string = modelDeployment_chat.name
output modelAda string = modelDeployment_embedding.name
