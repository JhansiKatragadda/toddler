param location string = resourceGroup().location

var storagename = 'store${uniqueString(resourceGroup().id)}'

resource exampleStorage 'Microsoft.Strorage/storageAccounts@2023-05-01' = {
   name: storagename
   location : location
   sku: {
     name: 'Standard_LRS'
   }
   kind : 'StorageV2'
}
