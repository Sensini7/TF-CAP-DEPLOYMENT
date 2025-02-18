# MS.AAD.2.1v1  Users detected as high risk SHALL be blocked.  Yes

variable "block_risky_users" {
  description = "Enable the Block High-Risk Users Conditional Access Policy"
  type        = string
  validation {
    condition     = can(regex("^(enabledForReportingButNotEnforced|enabled|disabled)$", var.block_risky_users))
    error_message = "Invalid value for block_risky_users. Allowed values are 'enabledForReportingButNotEnforced', 'enabled', or 'disabled'."
  }
}

resource "azuread_conditional_access_policy" "block_risky_users" {
  display_name = "Block High-Risk Users"
  state        = var.block_risky_users

  conditions {
    client_app_types              = ["all"]
    service_principal_risk_levels = []
    sign_in_risk_levels           = []
    user_risk_levels              = ["high"]

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
      excluded_groups = concat(var.excluded_groups, [azuread_group.group_allow_risky_users.object_id])
      excluded_users  = []
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }

  ## Until the Graph API supports high risk users, we must ignore all changes 
  ## Testing shows that upon creation, this CAP will be correctly configured 
  ## However, when Terraform performs any update, for example the display name changing 
  ## the Terraform provider will attempt to update the CAP using the values it  
  ## can retrieve. The provider completely ignores the configuration of high_risk_users 
  ## and clears it out as a result. 
  ## This is a problem in the Graph API and not Terraform, however  
  ## the only GitHub issue I located was on the Terraform azuread/hashicorp provider 
  ## https://github.com/hashicorp/terraform-provider-azuread/issues/1199
  lifecycle {
    ignore_changes = all ## READ THE COMMENT ABOVE. DO NOT CHANGE UNLESS YOU'RE SURE!
  }
}

resource "azuread_group" "group_allow_risky_users" {
  owners           = var.default_group_owners_ids
  display_name     = "CAP Exclude - Block High-Risk Users"
  mail_enabled     = false
  security_enabled = true
}

