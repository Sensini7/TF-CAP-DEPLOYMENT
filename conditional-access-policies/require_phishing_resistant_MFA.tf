# MS.AAD.3.6v1  Phishing-resistant MFA SHALL be required for highly privileged roles.  Yes

variable "mfa_privileged_ia-2" {
  description = "Enable the Phishing-Resistant MFA Enforcement for Privileged Roles Conditional Access Policy"
  type        = string
  validation {
    condition     = can(regex("^(enabledForReportingButNotEnforced|enabled|disabled)$", var.mfa_privileged_ia-2))
    error_message = "Invalid value for mfa_privileged_ia-2. Allowed values are 'enabledForReportingButNotEnforced', 'enabled', or 'disabled'."
  }
}

# locals {
#   require_phishing_resistant_mfa_auth_strength_policy_id = "00000000-0000-0000-0000-000000000004"
#   included_privileged_roles = [
#     "62e90394-69f5-4237-9190-012177145e10", # Global Administrator
#     "e8611ab8-c189-46e8-94e1-60213ab1f814", # Privileged Role Administrator
#     "fe930be7-5e62-47db-91af-98c3a49a38b1", # Privileged Authentication Administrator
#     "f28a1f50-f6e7-4571-818b-6a12f2af6b6c", # Authentication Administrator
#     "29232cdf-9323-42fd-ade2-1d097af3e4de", # Cloud Application Administrator
#     "8ac3fc64-6eca-42ea-9e69-59f4c7b60eb2", # Application Administrator
#     "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3", # Application Developer
#     "158c047a-c907-4556-b7ef-446551a6b5f7"  # Directory Writers
#   ]
# }

# MS.AAD.3.6v1 - Privileged Roles MFA Policy
resource "azuread_conditional_access_policy" "mfa_enforcement_privileged_Roles" {
  display_name = "Enforce Phishing Resistant MFA for Privileged Roles"
  state        = var.mfa_privileged_ia-2

  conditions {
    client_app_types              = ["all"]
    service_principal_risk_levels = []
    sign_in_risk_levels          = []
    user_risk_levels             = []

    applications {
      excluded_applications = []
      included_applications = ["All"]
    }

    locations {
      included_locations = ["All"]
    }

    platforms {
      included_platforms = ["all"]
    }

    users {
      included_groups = []
      included_users  = []
      included_roles  = local.included_privileged_roles
      excluded_groups = concat(var.excluded_groups, [azuread_group.group_mfa_priv_enforcement_bypass.object_id])
      excluded_users  = []
    }
  }

  grant_controls {
    operator                          = "OR"
    authentication_strength_policy_id = local.require_phishing_resistant_mfa_auth_strength_policy_id
  }
}

resource "azuread_group" "group_mfa_priv_enforcement_bypass" {
  owners           = var.default_group_owners_ids
  display_name     = "CAP Exclude - Enforce Phishing Resistant MFA for Privileged Roles"
  mail_enabled     = false
  security_enabled = true
}