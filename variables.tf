# Authentication
variable "application_credential_id" {
  type = string
}

variable "application_credential_secret" {
  type      = string
  sensitive = true
}

# Project configuration
variable "project" {
  type    = string
  default = "account-creation-assistance"
}

variable "resource_prefix" {
  type    = string
  default = "accounts"
}

# Proxies
variable "proxy_domain" {
  type    = string
  default = "wmcloud.org"
}

variable "proxy_suffix" {
  default = ""
  type    = string
}

# DNS zone
variable "dns_zone" {
  type    = string
  default = "svc.account-creation-assistance.eqiad1.wikimedia.cloud."
}
