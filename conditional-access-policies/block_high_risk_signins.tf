# MS.AAD.2.3v1  Sign-ins detected as high risk SHALL be blocked.  Yes

variable "block_risky_signins" {
  description = "Enable the Block High-Risk Sign-ins Conditional Access Policy"
  type        = string
  validation {
    condition     = can(regex("^(enabledForReportingButNotEnforced|enabled|disabled)$", var.block_risky_signins))
    error_message = "Invalid value for block_risky_signins. Allowed values are 'enabledForReportingButNotEnforced', 'enabled', or 'disabled'."
  }
}

resource "azuread_conditional_access_policy" "block_risky_signins" {
  display_name = "Block High-Risk Sign-ins"
  state        = var.block_risky_signins

  conditions {
    client_app_types              = ["all"]
    service_principal_risk_levels = []
    sign_in_risk_levels           = ["high"]
    user_risk_levels              = []

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
      excluded_groups = concat(var.excluded_groups, [azuread_group.group_allow_risky_signins.object_id])
      excluded_users  = []
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

resource "azuread_group" "group_allow_risky_signins" {
  owners           = var.default_group_owners_ids
  display_name     = "CAP Exclude - Block High-Risk Sign-ins"
  mail_enabled     = false
  security_enabled = true
}
