var boolVal = true

var vmProperties = {
  diagnosticsProfile: {
    bootDiagnostics: {
      enabled: 123
      storageUri: true
      unknownProp: 'asdf'
    }
  }
  evictionPolicy: boolVal
}

resource vm 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: 'vm'
  location: 'West US'
  properties: vmProperties
//@[14:26) [BCP036 (Warning)] The property "enabled" expected a value of type "bool" but the provided value in source declaration "vmProperties" is of type "int". |vmProperties|
//@[14:26) [BCP036 (Warning)] The property "evictionPolicy" expected a value of type "'Deallocate' | 'Delete'" but the provided value in source declaration "vmProperties" is of type "bool". |vmProperties|
//@[14:26) [BCP036 (Warning)] The property "storageUri" expected a value of type "string" but the provided value in source declaration "vmProperties" is of type "bool". |vmProperties|
//@[14:26) [BCP037 (Warning)] The property "unknownProp" from source declaration "vmProperties" is not allowed on objects of type "BootDiagnostics". No other properties are allowed. |vmProperties|
}

var ipConfigurations = [for i in range(0, 2): {
  id: true
  name: 'asdf${i}'
  properties: {
    madeUpProperty: boolVal
    subnet: 'hello'
  }
}]

resource nic 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: 'abc'
  properties: {
    ipConfigurations: ipConfigurations
//@[22:38) [BCP036 (Warning)] The property "id" expected a value of type "string" but the provided value in source declaration "ipConfigurations" is of type "bool". |ipConfigurations|
//@[22:38) [BCP037 (Warning)] The property "madeUpProperty" from source declaration "ipConfigurations" is not allowed on objects of type "NetworkInterfaceIPConfigurationPropertiesFormat". Permissible properties include "applicationGatewayBackendAddressPools", "applicationSecurityGroups", "loadBalancerBackendAddressPools", "loadBalancerInboundNatRules", "primary", "privateIPAddress", "privateIPAddressVersion", "privateIPAllocationMethod", "publicIPAddress", "virtualNetworkTaps". |ipConfigurations|
//@[22:38) [BCP036 (Warning)] The property "subnet" expected a value of type "Subnet" but the provided value in source declaration "ipConfigurations" is of type "'hello'". |ipConfigurations|
  }
}

resource nicLoop 'Microsoft.Network/networkInterfaces@2020-11-01' = [for i in range(0, 2): {
  name: 'abc${i}'
  properties: {
    ipConfigurations: [
      // TODO: fix this
      ipConfigurations[i]
    ]
  }
}]

resource nicLoop2 'Microsoft.Network/networkInterfaces@2020-11-01' = [for ipConfig in ipConfigurations: {
  name: 'abc${ipConfig.name}'
  properties: {
    ipConfigurations: [
      // TODO: fix this
      ipConfig
    ]
  }
}]

