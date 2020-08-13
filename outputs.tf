data "azurerm_subscription" "main" {
  subscription_id = shell_script.subscription.output.id
}

output "subscription_id" {
  value       = data.azurerm_subscription.main.subscription_id
  description = "Subscription ID GUID"
}

output "id" {
  value       = data.azurerm_subscription.main.id
  description = "Azure resource model subscription path"
}

output "name" {
  value       = data.azurerm_subscription.main.display_name
  description = "Name of the subscription"
}
