## env specifics

account_id  = "_your_aws_account_id_"
profile     = "_profile_from_awscli_config_"
project     = "mudhorn"
environment = "dev"
region      = "us-east-2"
owner       = "FredR"
donotdelete = "true"
expiry      = "2021_0221"

vpc_cidr = "172.30.160.0/22"

internal_subnet = {
  "us-east-2b" = {
    cidr  = "172.30.160.0/23"
    cidr6 = "8"
    zone  = "us-east-2b"
  }
}

external_subnet = {
  "us-east-2c" = {
    cidr  = "172.30.162.0/23"
    cidr6 = "16"
    zone  = "us-east-2c"
  }
}

pub_key = "ssh-rsa one-line-pubkey your-key-comment"

