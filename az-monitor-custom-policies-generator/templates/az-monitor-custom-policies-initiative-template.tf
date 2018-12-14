data "azurerm_subscription" "current" {}

data "template_file" "cmd_create_template" {
    template = <<COMMAND
az policy set-definition create --name "${var.initiative_name}" --subscription $(echo "${data.azurerm_subscription.current.id}" | cut -d"/" -f3) --definitions '[
    {% for policyDefinitionName in policyDefinitionNames %}
    {
        "parameters": {
          "diagSettingsName": {
            "value": "[parameters('"'"'diagSettingsName'"'"')]"
          },
          "logAnalytics": {
            "value": "[parameters('"'"'logAnalytics'"'"')]"
          }
        },
        "policyDefinitionId": "${data.azurerm_subscription.current.id}/providers/Microsoft.Authorization/policyDefinitions/{{policyDefinitionName}}"
    }{{ "," if not loop.last }}
    {% endfor %}
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