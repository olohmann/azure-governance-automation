provider "azurerm" {
    version = ">=1.20.0"
}

module "az_monitor_custom_policies_generated" {
  source = "./az-monitor-custom-policies-generated"
  custom_policies_prefix = "${var.custom_policies_prefix}"
  initiative_name = "${var.custom_policies_prefix}_DIAG_0000_Initiative"
  deployment_version = "${var.deployment_version}"
}
