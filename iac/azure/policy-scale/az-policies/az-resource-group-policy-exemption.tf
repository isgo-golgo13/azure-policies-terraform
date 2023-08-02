resource "azurerm_resource_group_policy_exemption" "this" {
  for_each = {
    for i in flatten([
      for assignment in var.assignment.assignments : [
        for exemption in var.exemptions : {
          id = format("%s_%s", assignment.name, element(
            split("/", exemption.id),
            length(split("/", exemption.id)) - 1
          ))
          data = {
            id       = exemption.id
            risk_id  = exemption.risk_id
            category = exemption.category
            assignment_id = one([
              for scope, assignment in local.assignments :
              assignment[exemption.assignment_reference].id
              if scope == var.assignment.scope
            ])
          }
        }
        if(
          exemption.assignment_reference == assignment.name
          && exemption.scope == "rg"
        )
      ]
    ]) : i.id => i.data
  }

  name = format(
    "%s_%s",
    random_uuid.exemptions.result,
    element(
      split("/", each.key),
      length(split("/", each.key)) - 1
    )
  )
  policy_assignment_id = each.value.assignment_id
  resource_group_id    = each.value.id
  exemption_category   = each.value.category
  description = jsonencode({
    "risk_id" : "${each.value.risk_id}"
  })
}