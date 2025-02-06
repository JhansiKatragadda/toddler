@description('Name of the resource to delete')

param resourceName string

@description('Subscription ID where the resource exists')

param subscriptionId string

@description('Resource Group where the resource is located')

param resourceGroup string

var userAssignedIdentityName = 'configDeployer57'
var roleAssignmentName = guid(userAssignedIdentity.id, 'contributor')
var contributorRoleDefinitionId = resourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
var deploymentScriptName = 'ResourceDeleted57'

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userAssignedIdentityName
  location: 'westus'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentName
  properties: {
    roleDefinitionId: contributorRoleDefinitionId
    principalId: userAssignedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource deleteScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
    name: deploymentScriptName
    location: 'swedencentral'
    kind: 'AzureCLI'
    identity: {
      type: 'UserAssigned'
        userAssignedIdentities: { 
          '${userAssignedIdentity.id}': {}}
        }
    properties: {
        azCliVersion: '2.30.0'
        arguments: '${resourceName} ${subscriptionId} ${resourceGroup}'
        scriptContent: '''
          #!/bin/bash
          set -e 
          # Set subscription context
          az account set --subscription "$2"

          # Get the resource ID using the az resource list command
          RESOURCE_ID=$(az resource list --subscription "$2" --resource-group "$3" --name "$1" --query "[0].id" --output tsv)
          if [ -n "$RESOURCE_ID" ]; then
            # If the resource exists, delete it
            az resource delete --ids $RESOURCE_ID
              echo "Resource $1 deleted successfully."
          else
             echo "Resource $1 not found in resource group $RESOURCE_GROUP."
           fi
        '''
    retentionInterval: 'P1D'
    timeout: 'PT30M'
  }
  dependsOn: [
    roleAssignment
  ]
}
