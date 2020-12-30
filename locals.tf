locals {

  prefix = "${var.environment}-${var.project}"

  default_tags = {
    Name        = local.prefix
    Environment = var.environment
    Owner       = var.owner
    Expiry      = var.expiry
    DoNotDelete = var.donotdelete
  }
}
