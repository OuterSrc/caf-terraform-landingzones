variable "aci" {default = {}}
variable "azure_devops" {default = {}}
variable "container_groups" {default = {}}
variable "custom_role_definitions" {default = {}}
variable "global_settings" {default = {}}
variable "keyvault_access_policies" {default = {}}
variable "keyvaults" {default = {}}
variable "landingzone" {}
variable "logged_aad_app_objectId" {default = null}
variable "logged_user_objectId" {default = null}
variable "lower_container_name" {}
variable "lower_resource_group_name" {}
variable "lower_storage_account_name" {}
variable "managed_identities" {default = {}}
variable "network_profiles" {default = {}}
variable "resource_groups" {default = {}}
variable "role_mapping" {default = {}}
variable "rover_version" {default = null}
variable "tags" {default = null}
variable "tenant_id" {}
variable "tfstate_container_name" {}
variable "tfstate_key" {}
variable "tfstate_resource_group_name" {}
variable "tfstate_storage_account_name" {}
variable "tfstate_subscription_id" {description = "This value is populated by rover. This is the subscription id hosting the remote tfstates"}
