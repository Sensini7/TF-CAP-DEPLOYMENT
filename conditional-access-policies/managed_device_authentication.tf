# MS.AAD.3.7v1  Managed devices SHOULD be required for authentication.  Yes
# MS.AAD.3.7v1  Managed devices SHOULD be required for authentication.  Yes

variable "require_managed_devices" {
  description = "Enable the Require Managed Devices Conditional Access Policy"
  type        = string
  validation {
    condition     = can(regex("^(enabledForReportingButNotEnforced|enabled|disabled)$", var.require_managed_devices))
    error_message = "Invalid value for require_managed_devices. Allowed values are 'enabledForReportingButNotEnforced', 'enabled', or 'disabled'."
  }
}

resource "azuread_conditional_access_policy" "require_managed_devices" {
  display_name = "Require Managed Devices"
  state        = var.require_managed_devices

  conditions {
    client_app_types              = ["browser", "mobileAppsAndDesktopClients"]
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
      included_platforms = ["android", "iOS", "windows", "macOS", "linux"]
    }

    users {
      included_groups = []
      included_users  = ["All"]
      excluded_groups = concat(var.excluded_groups, [azuread_group.group_managed_device_bypass.object_id])
      excluded_users  = []
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["compliantDevice", "domainJoinedDevice"]
  }
}

resource "azuread_group" "group_managed_device_bypass" {
  owners           = var.default_group_owners_ids
  display_name     = "CAP Exclude - Require Managed Devices"
  mail_enabled     = false
  security_enabled = true
}