variable "excluded_groups" {
  type    = list(string)
  default = [""]
}

# variable "is_azure_gov" {
#   description = "Determines whether the tenant is in Azure Commercial or Azure GovCloud"
#   type        = bool
#   default     = false
# }

variable "default_group_owners_ids" {
  type        = list(string)
  description = "Object IDs of the owners of the Entra ID group of emergency breakglass users."
}