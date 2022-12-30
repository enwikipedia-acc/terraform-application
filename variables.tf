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

# blue/green deployments
variable "live_instance" {
  type        = string
  description = "The currently-active instance of the application"
}

variable "staging_instance" {
  type        = string
  description = "The instance of the application running as a staging environment"
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