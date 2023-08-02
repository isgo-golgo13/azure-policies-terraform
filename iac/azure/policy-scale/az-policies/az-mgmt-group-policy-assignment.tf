resource "azurerm_management_group_policy_assignment" "this" {
  for_each = {
    for assignment in var.assignment.assignments :
    assignment.name => assignment.id
    if var.assignment.scope == "mg"
  }

  name                 = random_uuid.assignment[each.key].result
  management_group_id  = each.value
  policy_definition_id = azurerm_policy_set_definition.this.id
}