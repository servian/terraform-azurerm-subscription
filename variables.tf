variable "name" {
  type        = string
  description = "Subscription name, can be changed later without recreating the subscription."
}

variable "type" {
  type        = string
  description = "Subscription offer types `Prod` or `DevTest`. If using `DevTest` the enrollment account must have DevTest enabled, otherwise provisioning will fail."
  default     = "Prod"
  validation {
    condition     = contains(["Prod", "DevTest"], var.type)
    error_message = "Allowed values for subscription type are \"Prod\" or \"DevTest\"."
  }
}

variable "principal_ids" {
  type        = list(string)
  description = "List of principal_ids to give the owner role on this subscription."
  default     = []
}

variable "tenant_id" {
  type        = string
  description = "Guid of the Azure tenant to create the subscription in."
}

variable "client_id" {
  type        = string
  description = "Service principal to provision the subscription using."
}

variable "client_secret" {
  type        = string
  description = "Service principal secret to provision the subscription using."
}