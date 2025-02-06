param location string = resourceGroup().location

var storagename = 'str${uniqueString(resourceGroup().id)}'

resource exampleStorage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
   name: storagename
   location : location
   sku: {
     name: 'Standard_LRS'
   }
   kind : 'StorageV2'
}
