output "subscription_id" {
  value = shell_script.subscription.output.id
  description = "Subscription ID GUID"
}

output "id" {
  value = "/subscriptions/${shell_script.subscription.output.id}"
  description = "Azure resource model subscription path"
}
