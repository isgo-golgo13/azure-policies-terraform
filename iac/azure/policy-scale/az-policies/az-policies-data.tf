data "azurerm_policy_definition" "this" {
  for_each = {
    for k, v in local.policies :
    k => v
    if v.type == "BuiltIn"
  }

  name = each.value.id
}