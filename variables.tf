variable "name" {
  type        = string
  description = "Subscription name, can be changed later without recreating the subscription."
}

variable "type" {
  type        = string
  description = "Subscription offer types 'Prod' or 'DevTest', 'DevTest' must first be enabled at the enrollment account, otherwise will fail."
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
