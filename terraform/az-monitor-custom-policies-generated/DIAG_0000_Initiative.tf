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
        "policyDefinitionId": "${azurerm_policy_definition.policy_DIAG_0001_Microsoft_Sql.id}"
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
        "policyDefinitionId": "${azurerm_policy_definition.policy_DIAG_0002_Microsoft_DataLakeStore.id}"
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
        "policyDefinitionId": "${azurerm_policy_definition.policy_DIAG_0003_Microsoft_ContainerRegistry.id}"
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
        "policyDefinitionId": "${azurerm_policy_definition.policy_DIAG_0004_Microsoft_ContainerInstance.id}"
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
        "policyDefinitionId": "${azurerm_policy_definition.policy_DIAG_0005_Microsoft_DataFactory.id}"
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
        "policyDefinitionId": "${azurerm_policy_definition.policy_DIAG_0006_Microsoft_DataLakeAnalytics.id}"
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
        "policyDefinitionId": "${azurerm_policy_definition.policy_DIAG_0007_Microsoft_ContainerService.id}"
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
        "policyDefinitionId": "${azurerm_policy_definition.policy_DIAG_0008_Microsoft_AnalysisServices.id}"
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
        "policyDefinitionId": "${azurerm_policy_definition.policy_DIAG_0009_Microsoft_Network.id}"
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
        "policyDefinitionId": "${azurerm_policy_definition.policy_DIAG_0010_Microsoft_StreamAnalytics.id}"
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
        "policyDefinitionId": "${azurerm_policy_definition.policy_DIAG_0011_Microsoft_Automation.id}"
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
        "policyDefinitionId": "${azurerm_policy_definition.policy_DIAG_0012_Microsoft_RecoveryServices.id}"
    }
    
]' --params '{
    "diagSettingsName": {
        "metadata": {
            "displayName": "Diagnostic Settings Name",
            "description": "Diagnostic Settings Name. Must be unique per resource."
        },
        "type": "String"
    },
    "logAnalytics": {
        "metadata": {
            "displayName": "Log Analytics Workspace",
            "description": "Select the Log Analytics workspace from dropdown list",
            "strongType": "omsWorkspace"
        },
        "type": "String"
    }
}' --description '${var.custom_policies_prefix}_ ${var.deployment_version}'
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
