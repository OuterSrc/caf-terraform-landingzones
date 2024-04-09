locals {
  landingzone = {
    current = {
      container_name       = var.tfstate_container_name
      resource_group_name  = var.tfstate_resource_group_name
      storage_account_name = var.tfstate_storage_account_name
    }
    lower = {
      container_name       = var.lower_container_name
      resource_group_name  = var.lower_resource_group_name
      storage_account_name = var.lower_storage_account_name
    }
  }
}

data "terraform_remote_state" "remote" {
  for_each = try(var.landingzone.tfstates, {})
  backend  = var.landingzone.backend_type

  config = {
    container_name       = local.landingzone[try(each.value.level, "current")].container_name
    key                  = each.value.tfstate
    resource_group_name  = local.landingzone[try(each.value.level, "current")].resource_group_name
    storage_account_name = local.landingzone[try(each.value.level, "current")].storage_account_name
    subscription_id      = var.tfstate_subscription_id
  }
}

locals {
  landingzone_tag = {
    "landingzone" = var.landingzone.key
  }

  tags = merge(var.tags, local.landingzone_tag, local.global_settings.tags, { "level" = var.landingzone.level }, { "environment" = local.global_settings.environment })
  global_settings = data.terraform_remote_state.remote[var.landingzone.global_settings_key].outputs.global_settings

  combined = {
    keyvaults          = merge(local.remote.keyvaults, tomap({ (var.landingzone.key) = module.solution.keyvaults }))
    managed_identities = merge(local.remote.managed_identities, tomap({ (var.landingzone.key) = module.solution.managed_identities }))
    resource_groups    = merge(local.remote.resource_groups, tomap({ (var.landingzone.key) = module.solution.resource_groups }))
    virtual_subnets    = merge(local.remote.virtual_subnets, tomap({ (var.landingzone.key) = module.solution.virtual_subnets }))
  }

  remote = {
    managed_identities = merge(
      tomap({ "launchpad" = try(data.terraform_remote_state.remote[var.landingzone.global_settings_key].outputs.launchpad_identities["launchpad"].managed_identities, {}) }),
      {
        for key, value in try(var.landingzone.tfstates, {}) : key => merge(
          try(data.terraform_remote_state.remote[key].outputs.objects[key].managed_identities, {})
        )
      }
    )
    vnets = {
      for key, value in try(var.landingzone.tfstates, {}) : key => merge(try(data.terraform_remote_state.remote[key].outputs.objects[key].vnets, {}))
    }
    keyvaults = {
      for key, value in try(var.landingzone.tfstates, {}) : key => merge(try(data.terraform_remote_state.remote[key].outputs.objects[key].keyvaults, {}))
    }
    resource_groups = {
      for key, value in try(var.landingzone.tfstates, {}) : key => merge(try(data.terraform_remote_state.remote[key].outputs.objects[key].resource_groups, {}))
    }
    virtual_subnets = {
      for key, value in try(var.landingzone.tfstates, {}) : key => merge(try(data.terraform_remote_state.remote[key].outputs.objects[key].virtual_subnets, {}))
    }
  }
}

locals {
  # Update the tfstates map
  tfstates = merge(
    tomap(
      {
        (var.landingzone.key) = local.backend[var.landingzone.backend_type]
      }
    )
    ,
    data.terraform_remote_state.remote[var.landingzone.global_settings_key].outputs.tfstates
  )
  backend = {
    azurerm = {
      container_name       = var.tfstate_container_name
      key                  = var.tfstate_key
      level                = var.landingzone.level
      resource_group_name  = var.tfstate_resource_group_name
      storage_account_name = var.tfstate_storage_account_name
      subscription_id      = data.azurerm_client_config.current.subscription_id
      tenant_id            = var.tenant_id
    }
  }
}
