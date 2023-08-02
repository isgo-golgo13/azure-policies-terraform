locals {
  initiative_definition = yamldecode(file(var.initiative_definition))
  policies              = local.initiative_definition.policies
}

locals {
  all_policies = merge(azurerm_policy_definition.this, data.azurerm_policy_definition.this)

  parameters = {
    for k, v in local.all_policies :
    k => try(
      local.policies[k][var.environment].parameters,
      local.policies[k].default.parameters
    )
  }
}


locals {
  assignments = {
    sub = try(azurerm_subscription_policy_assignment.this, "")
    mg  = try(azurerm_management_group_policy_assignment.this, "")
    rg  = try(azurerm_resource_group_policy_assignment.this, "")
  }
}