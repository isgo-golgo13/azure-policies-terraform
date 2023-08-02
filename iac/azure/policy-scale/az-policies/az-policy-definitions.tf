resource "random_uuid" "policy" {
  for_each = {
    for k, v in local.policies :
    k => v
    if v.type == "Custom"
  }
}
resource "random_uuid" "exemptions" {}
resource "random_uuid" "assignment" {
  for_each = {
    for assignment in var.assignment.assignments :
    assignment.name => assignment.id
  }
}

resource "azurerm_policy_definition" "this" {
  for_each = {
    for k, v in local.policies :
    k => jsondecode(
      templatefile(
        "${path.root}/policies/${v.file}",
        { effect = try(v[var.environment].effect, v.default.effect) }
      )
    )
    if v.type == "Custom"
  }

  name         = random_uuid.policy[each.key].result
  policy_type  = each.value.properties.policyType
  mode         = each.value.properties.mode
  display_name = each.value.properties.displayName
  description  = each.value.properties.description
  metadata     = jsonencode(each.value.properties.metadata)
  policy_rule  = jsonencode(each.value.properties.policyRule)
  parameters   = jsonencode(each.value.properties.parameters)
}