module "caf" {
  source  = "aztfmod/caf/azurerm"
  version = "~>5.3.0"

  azuread_apps                          = var.azuread_apps
  azuread_groups                        = var.azuread_groups
  current_landingzone_key               = var.landingzone.key
  custom_role_definitions               = var.custom_role_definitions
  diagnostic_storage_accounts           = var.diagnostic_storage_accounts
  diagnostics                           = local.diagnostics
  global_settings                       = local.global_settings
  keyvault_access_policies              = var.keyvault_access_policies
  keyvault_access_policies_azuread_apps = var.keyvault_access_policies_azuread_apps
  keyvaults                             = var.keyvaults
  logged_aad_app_objectId               = var.logged_aad_app_objectId
  logged_user_objectId                  = var.logged_user_objectId
  resource_groups                       = var.resource_groups
  role_mapping                          = var.role_mapping
  storage_accounts                      = var.storage_accounts
  tags                                  = local.tags
  tenant_id                             = var.tenant_id
  tfstates                              = local.tfstates

  compute = {
    virtual_machines = var.virtual_machines
  }

  remote_objects = {
    keyvaults          = local.remote.keyvaults
    vnets              = local.remote.vnets
    managed_identities = local.remote.managed_identities
    azuread_groups     = local.remote.azuread_groups
  }

  storage = {
    storage_account_blobs = var.storage_account_blobs
  }
}
