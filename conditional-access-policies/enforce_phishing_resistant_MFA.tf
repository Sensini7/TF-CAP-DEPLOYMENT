# MS.AAD.3.1v1  Phishing-resistant MFA SHALL be enforced for all users.  Yes

locals {
  require_phishing_resistant_mfa_auth_strength_policy_id = "00000000-0000-0000-0000-000000000004"
}

variable "mfa_ia-2" {
  description = "Enable the Phishing-Resistant MFA Enforcement Conditional Access Policy"
  type        = string
  validation {
    condition     = can(regex("^(enabledForReportingButNotEnforced|enabled|disabled)$", var.mfa_ia-2))
    error_message = "Invalid value for mfa_ia-2. Allowed values are 'enabledForReportingButNotEnforced', 'enabled', or 'disabled'."
  }
}

# MS.AAD.3.1v1 - All Users MFA Policy
resource "azuread_conditional_access_policy" "mfa_enforcement" {
  display_name = "Enforce Phishing Resistant MFA"
  state        = var.mfa_ia-2

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
      included_users  = ["All"]
      excluded_groups = concat(var.excluded_groups, [azuread_group.group_mfa_enforcement_bypass.object_id])
      excluded_users  = []
    }
  }

  grant_controls {
    operator                          = "OR"
    authentication_strength_policy_id = local.require_phishing_resistant_mfa_auth_strength_policy_id
  }
}

resource "azuread_group" "group_mfa_enforcement_bypass" {
  owners           = var.default_group_owners_ids
  display_name     = "CAP Exclude - Enforce Phishing Resistant MFA for Privileged Roles"
  mail_enabled     = false
  security_enabled = true
}