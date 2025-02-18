# locals {
#   # Authentication Strength Policy IDs
#   require_phishing_resistant_mfa_auth_strength_policy_id = "00000000-0000-0000-0000-000000000004"
# }

locals {
  require_phishing_resistant_mfa_auth_strength_policy_id = "00000000-0000-0000-0000-000000000004"
  included_privileged_roles = [
    "62e90394-69f5-4237-9190-012177145e10", # Global Administrator
    "e8611ab8-c189-46e8-94e1-60213ab1f814", # Privileged Role Administrator
    "fe930be7-5e62-47db-91af-98c3a49a38b1", # Privileged Authentication Administrator
    "f28a1f50-f6e7-4571-818b-6a12f2af6b6c", # Authentication Administrator
    "29232cdf-9323-42fd-ade2-1d097af3e4de", # Cloud Application Administrator
    "8ac3fc64-6eca-42ea-9e69-59f4c7b60eb2", # Application Administrator
    "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3", # Application Developer
    "158c047a-c907-4556-b7ef-446551a6b5f7"  # Directory Writers
  ]
}