# MS.AAD.3.8v1  Managed devices SHOULD be required to register MFA.  Yes
# MS.AAD.3.8v1  Managed devices SHOULD be required to register MFA.  Yes

variable "managed_device_mfa_registration" {
  description = "Enable the Require Managed Device for MFA Registration Conditional Access Policy"
  type        = string
  validation {
    condition     = can(regex("^(enabledForReportingButNotEnforced|enabled|disabled)$", var.managed_device_mfa_registration))
    error_message = "Invalid value for managed_device_mfa_registration. Allowed values are 'enabledForReportingButNotEnforced', 'enabled', or 'disabled'."
  }
}

resource "azuread_conditional_access_policy" "managed_device_mfa_registration" {
  display_name = "Require Managed Device for MFA Registration"
  state        = var.managed_device_mfa_registration

  conditions {
    client_app_types              = ["all"]
    service_principal_risk_levels = []
    sign_in_risk_levels          = []
    user_risk_levels             = []

    applications {
      included_user_actions = ["urn:user:registersecurityinfo"]
      excluded_applications = []
      #included_applications = []
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
      excluded_groups = concat(var.excluded_groups, [azuread_group.group_device_registration_bypass.object_id])
      excluded_users  = []
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["compliantDevice", "domainJoinedDevice"]
  }
}

resource "azuread_group" "group_device_registration_bypass" {
  owners           = var.default_group_owners_ids
  display_name     = "CAP Exclude - Require Managed Device for MFA Registration"
  mail_enabled     = false
  security_enabled = true
}