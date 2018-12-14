resource "azurerm_policy_definition" "policy_DIAG_0001_Microsoft_Sql" {
  name         = "${var.custom_policies_prefix}_DIAG_0001_Microsoft_Sql"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "${var.custom_policies_prefix}_DIAG_0001_Microsoft_Sql"

  policy_rule = <<POLICY_RULE
{
    "if": {
        "field": "type",
        "equals": "Microsoft.Sql/servers/databases"
    },
    "then": {
        "effect": "deployIfNotExists",
        "details": {
            "type": "Microsoft.Insights/diagnosticSettings",
            "name": "diagnosticSettings",
            "roleDefinitionIds": [
                "/providers/Microsoft.Authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa"
            ],
            "deployment": {
                "properties": {
                    "mode": "incremental",
                    "template": {
                        "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                        "contentVersion": "1.0.0.0",
                        "parameters": {
                            "diagSettingsName": {
                                "type": "string"
                            },
                            "fullDbName": {
                                "type": "string"
                            },
                            "logAnalytics": {
                                "type": "string"
                            },
                            "location": {
                                "type": "string"
                            }
                        },
                        "variables": {},
                        "resources": [{
                            "type": "Microsoft.Sql/servers/databases/providers/diagnosticSettings",
                            "apiVersion": "2017-05-01-preview",
                            "name": "[concat(parameters('fullDbName'), '/', 'Microsoft.Insights/', parameters('diagSettingsName')]",
                            "location": "[parameters('location')]",
                            "dependsOn": [],
                            "properties": {
                                "workspaceId": "[parameters('logAnalytics')]",
                                
                                "metrics": [
                                                {
                                                    "category": "PT1M",
                                                    "enabled": true,
                                                    "retentionPolicy": {
                                                        "enabled": false,
                                                        "days": 0
                                                    }
                                                }
                                            ],
                                
                                "logs": [
                                  
                                  {
                                    "category": "Audit",
                                    "enabled": "true"
                                  } ,
                                  
                                  {
                                    "category": "SQLSecurityAuditEvents",
                                    "enabled": "true"
                                  } 
                                  
                                ]
                                
                            }
                        }],
                        "outputs": {}
                    },
                    "parameters": {
                        "diagSettingsName": {
                            "value": "[parameters('diagSettingsName')]"
                        },
                        "logAnalytics": {
                            "value": "[parameters('logAnalytics')]"
                        },
                        "location": {
                            "value": "[field('location')]"
                        },
                        "fullDbName": {
                            "value": "[field('fullName')]"
                        }
                    }
                }
            }
        }
    }
}
POLICY_RULE

  parameters = <<PARAMETERS
{
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
}
PARAMETERS
}
