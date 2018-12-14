data "azurerm_subscription" "current" {}

data "template_file" "cmd_create_template" {
    template = <<COMMAND
az policy set-definition create --name "${var.initiative_name}" --subscription $(echo "${data.azurerm_subscription.current.id}" | cut -d"/" -f3) --definitions '[
    
    {
        "parameters": {
          "diagSettingsName": {
            "value": "[parameters('"'"'diagSettingsName'"'"')]"
          },
          "logAnalytics": {
            "value": "[parameters('"'"'logAnalytics'"'"')]"
          }
        },
        "policyDefinitionId": "${data.azurerm_subscription.current.id}/providers/Microsoft.Authorization/policyDefinitions/${azurerm_policy_definition.policy_DIAG_0001_Microsoft_Sql.name}"
    },
    
    {
        "parameters": {
          "diagSettingsName": {
            "value": "[parameters('"'"'diagSettingsName'"'"')]"
          },
          "logAnalytics": {
            "value": "[parameters('"'"'logAnalytics'"'"')]"
          }
        },
        "policyDefinitionId": "${data.azurerm_subscription.current.id}/providers/Microsoft.Authorization/policyDefinitions/${azurerm_policy_definition.policy_DIAG_0002_Microsoft_DataLakeStore.name}"
    },
    
    {
        "parameters": {
          "diagSettingsName": {
            "value": "[parameters('"'"'diagSettingsName'"'"')]"
          },
          "logAnalytics": {
            "value": "[parameters('"'"'logAnalytics'"'"')]"
          }
        },
        "policyDefinitionId": "${data.azurerm_subscription.current.id}/providers/Microsoft.Authorization/policyDefinitions/${azurerm_policy_definition.policy_DIAG_0003_Microsoft_ContainerRegistry.name}"
    },
    
    {
        "parameters": {
          "diagSettingsName": {
            "value": "[parameters('"'"'diagSettingsName'"'"')]"
          },
          "logAnalytics": {
            "value": "[parameters('"'"'logAnalytics'"'"')]"
          }
        },
        "policyDefinitionId": "${data.azurerm_subscription.current.id}/providers/Microsoft.Authorization/policyDefinitions/${azurerm_policy_definition.policy_DIAG_0004_Microsoft_ContainerInstance.name}"
    },
    
    {
        "parameters": {
          "diagSettingsName": {
            "value": "[parameters('"'"'diagSettingsName'"'"')]"
          },
          "logAnalytics": {
            "value": "[parameters('"'"'logAnalytics'"'"')]"
          }
        },
        "policyDefinitionId": "${data.azurerm_subscription.current.id}/providers/Microsoft.Authorization/policyDefinitions/${azurerm_policy_definition.policy_DIAG_0005_Microsoft_DataFactory.name}"
    },
    
    {
        "parameters": {
          "diagSettingsName": {
            "value": "[parameters('"'"'diagSettingsName'"'"')]"
          },
          "logAnalytics": {
            "value": "[parameters('"'"'logAnalytics'"'"')]"
          }
        },
        "policyDefinitionId": "${data.azurerm_subscription.current.id}/providers/Microsoft.Authorization/policyDefinitions/${azurerm_policy_definition.policy_DIAG_0006_Microsoft_DataLakeAnalytics.name}"
    },
    
    {
        "parameters": {
          "diagSettingsName": {
            "value": "[parameters('"'"'diagSettingsName'"'"')]"
          },
          "logAnalytics": {
            "value": "[parameters('"'"'logAnalytics'"'"')]"
          }
        },
        "policyDefinitionId": "${data.azurerm_subscription.current.id}/providers/Microsoft.Authorization/policyDefinitions/${azurerm_policy_definition.policy_DIAG_0007_Microsoft_ContainerService.name}"
    },
    
    {
        "parameters": {
          "diagSettingsName": {
            "value": "[parameters('"'"'diagSettingsName'"'"')]"
          },
          "logAnalytics": {
            "value": "[parameters('"'"'logAnalytics'"'"')]"
          }
        },
        "policyDefinitionId": "${data.azurerm_subscription.current.id}/providers/Microsoft.Authorization/policyDefinitions/${azurerm_policy_definition.policy_DIAG_0008_Microsoft_AnalysisServices.name}"
    },
    
    {
        "parameters": {
          "diagSettingsName": {
            "value": "[parameters('"'"'diagSettingsName'"'"')]"
          },
          "logAnalytics": {
            "value": "[parameters('"'"'logAnalytics'"'"')]"
          }
        },
        "policyDefinitionId": "${data.azurerm_subscription.current.id}/providers/Microsoft.Authorization/policyDefinitions/${azurerm_policy_definition.policy_DIAG_0009_Microsoft_Network.name}"
    },
    
    {
        "parameters": {
          "diagSettingsName": {
            "value": "[parameters('"'"'diagSettingsName'"'"')]"
          },
          "logAnalytics": {
            "value": "[parameters('"'"'logAnalytics'"'"')]"
          }
        },
        "policyDefinitionId": "${data.azurerm_subscription.current.id}/providers/Microsoft.Authorization/policyDefinitions/${azurerm_policy_definition.policy_DIAG_0010_Microsoft_StreamAnalytics.name}"
    },
    
    {
        "parameters": {
          "diagSettingsName": {
            "value": "[parameters('"'"'diagSettingsName'"'"')]"
          },
          "logAnalytics": {
            "value": "[parameters('"'"'logAnalytics'"'"')]"
          }
        },
        "policyDefinitionId": "${data.azurerm_subscription.current.id}/providers/Microsoft.Authorization/policyDefinitions/${azurerm_policy_definition.policy_DIAG_0011_Microsoft_Automation.name}"
    },
    
    {
        "parameters": {
          "diagSettingsName": {
            "value": "[parameters('"'"'diagSettingsName'"'"')]"
          },
          "logAnalytics": {
            "value": "[parameters('"'"'logAnalytics'"'"')]"
          }
        },
        "policyDefinitionId": "${data.azurerm_subscription.current.id}/providers/Microsoft.Authorization/policyDefinitions/${azurerm_policy_definition.policy_DIAG_0012_Microsoft_RecoveryServices.name}"
    }
    
]' --params '{
    "diagSettingsName": {
        "type": "string",
        "metadata": {
            "displayName": "Diagnostic Settings Name",
            "description": "Diagnostic Settings Name. Must be unique per resource."
        }
    },
    "logAnalytics": {
        "type": "string",
        "metadata": {
            "displayName": "Log Analytics Workspace",
            "description": "Select the Log Analytics workspace from dropdown list",
            "strongType": "omsWorkspace"
        }
    }
}'
COMMAND
}

data "template_file" "cmd_destroy_template" {
    template = <<COMMAND
    az policy set-definition delete --name "${var.initiative_name}" --subscription $(echo "${data.azurerm_subscription.current.id}" | cut -d"/" -f3)
COMMAND
}

resource "null_resource" "logging_policy_initiative" {
  triggers = {
    input = "${sha256(data.template_file.cmd_create_template.rendered)}"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command ="${data.template_file.cmd_destroy_template.rendered}" 

    environment {
    }
  }
  provisioner "local-exec" {
    command ="${data.template_file.cmd_create_template.rendered}" 
  }
}
