provider "aws" {
  version = ">= 3.8.0"
  region  = var.region
  profile = var.profile

  allowed_account_ids = [var.account_id]
}

