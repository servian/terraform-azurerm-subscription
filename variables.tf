variable "name" {
  type        = string
  description = "Subscription name"
}

variable "type" {
  type        = string
  description = "Prod or DevTest"
  default     = "Prod"
  validation {
    condition     = contains(["Prod", "DevTest"], var.type)
    error_message = "Allowed values for subscription type are \"Prod\" or \"DevTest\"."
  }
}

variable "principal_ids" {
  type        = list(string)
  description = "List of principal_ids to give the owner role on this subscription."
}
