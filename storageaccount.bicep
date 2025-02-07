param location string = resourceGroup().location

resource exampleStorage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
   name: storageAccountName
   location : location
   sku: {
     name: 'Standard_LRS'
   }
   kind : 'StorageV2'
}
