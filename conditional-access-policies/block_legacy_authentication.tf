# MS.AAD.1.v1  Legacy authentication SHALL be blocked.  Yes
# Satisfies the following SCuBA policies:
# MS.AAD.1.1v1

variable "block_legacy_authentication" {
  description = "Enable the Block Legacy Authentication Conditional Access Policy"
  type        = string
  validation {
    condition     = can(regex("^(enabledForReportingButNotEnforced|enabled|disabled)$", var.block_legacy_authentication))
    error_message = "Invalid value for block_legacy_authentication. Allowed values are 'enabledForReportingButNotEnforced', 'enabled', or 'disabled'."
  }
}

resource "azuread_conditional_access_policy" "block_legacy_authentication" {
  display_name = "Block Legacy Authentication"
  state        = var.block_legacy_authentication

  conditions {
    client_app_types = [
      "exchangeActiveSync",
      "other"
    ]
    service_principal_risk_levels = []
    sign_in_risk_levels           = []
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
      excluded_groups = concat(var.excluded_groups, [azuread_group.group_legacy_auth_access.object_id])
      excluded_users  = []
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

resource "azuread_group" "group_legacy_auth_access" {
  owners           = var.default_group_owners_ids
  display_name     = "CAP Exclude - Block Legacy Authentication"
  mail_enabled     = false
  security_enabled = true
}
