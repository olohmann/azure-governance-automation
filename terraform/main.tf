module "az_monitor_custom_policies_generated" {
  source = "./az-monitor-custom-policies-generated"
  custom_policies_prefix = "${var.custom_policies_prefix}"
  initiative_name = "${var.custom_policies_prefix}_0000_DIAG_Initiative"
}
