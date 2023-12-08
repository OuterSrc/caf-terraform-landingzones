module "solution" {
  source  = "aztfmod/caf/azurerm"
  version = "~>5.6.8"

  providers = {
    azurerm.vhub = azurerm
  }

  current_landingzone_key  = var.landingzone.key
  custom_role_definitions  = var.custom_role_definitions
  global_settings          = local.global_settings
  keyvault_access_policies = var.keyvault_access_policies
  keyvaults                = var.keyvaults
  logged_aad_app_objectId  = var.logged_aad_app_objectId
  logged_user_objectId     = var.logged_user_objectId
  managed_identities       = var.managed_identities
  resource_groups          = var.resource_groups
  role_mapping             = var.role_mapping
  tags                     = local.tags
  tfstates                 = local.tfstates

  compute = {
    container_groups = var.container_groups
  }

  networking = {
    network_profiles = var.network_profiles
  }

  # Pass the remote objects you need to connect to.
  remote_objects = {
    keyvaults          = local.remote.keyvaults
    managed_identities = local.remote.managed_identities
    resource_groups    = local.remote.resource_groups
    virtual_subnets    = local.remote.virtual_subnets
    vnets              = local.remote.vnets
  }
}