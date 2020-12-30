variable "region" {
  description = "The targeted AWS region."
  type        = string
}

variable "owner" {
  description = "The owner name."
  type        = string
}

variable "account_id" {
  description = "The aws account id to run terraform against."
  type        = string
}

variable "profile" {
  description = "The aws profile id to run terraform against."
  type        = string
}

variable "project" {
  description = "The name of the project."
  type        = string
}

variable "environment" {
  description = "The name of the environment."
  type        = string
}

variable "donotdelete" {
  description = "DoNotDelete tag for cloud cleanup scripts."
  type        = string
}

variable "expiry" {
  description = "TTL flag for life of the resource or env."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR range for the VPC. Example: 10.0.0.0/16"
  type        = string
}

variable "pub_key" {
  description = "User ssh public key"
  type        = string
}

variable "internal_subnet" {
  description = "The map of objects that describes each of the internal subnets to create."
  type = map(object({
    cidr  = string
    cidr6 = string
    zone  = string
  }))
}

variable "external_subnet" {
  description = "The map of objects that describes each of the external subnets to create."
  type = map(object({
    cidr  = string
    cidr6 = string
    zone  = string
  }))
}

