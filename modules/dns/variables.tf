variable "access_ip_v4" {
  type     = string
  nullable = false
}

variable "access_ip_v6" {
  type    = string
  default = null
}

variable "name" {
  type     = string
  nullable = false
}

variable "dns_zone" {
  type     = string
  default  = "svc.account-creation-assistance.eqiad1.wikimedia.cloud."
  nullable = false
}