resource "azurerm_policy_set_definition" "this" {
  name         = local.initiative_definition.name
  policy_type  = "Custom"
  display_name = local.initiative_definition.display_name
  description  = local.initiative_definition.description

  dynamic "policy_definition_reference" {
    for_each = local.all_policies

    content {
      policy_definition_id = policy_definition_reference.value.id
      parameter_values     = jsonencode(local.parameters[policy_definition_reference.key])
    }
  }
}