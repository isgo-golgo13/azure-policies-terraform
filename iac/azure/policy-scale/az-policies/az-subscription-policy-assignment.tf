resource "azurerm_subscription_policy_assignment" "this" {
  for_each = {
    for assignment in var.assignment.assignments :
    assignment.name => assignment.id
    if var.assignment.scope == "sub"
  }

  name                 = random_uuid.assignment[each.key].result
  subscription_id      = each.value
  policy_definition_id = azurerm_policy_set_definition.this.id
}