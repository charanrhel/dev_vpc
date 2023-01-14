variable "pub_cidr" {
  default = ["192.0.1.0/24", "192.0.2.0/24", "192.0.3.0/24", "192.0.4.0/24"]
  type    = list(any)
}

variable "priv_cidr" {
  default = ["192.0.5.0/24", "192.0.6.0/24", "192.0.7.0/24", "192.0.8.0/24"]
  type    = list(any)
}

variable "data_cidr" {
  default = ["192.0.9.0/24", "192.0.10.0/24", "192.0.11.0/24", "192.0.12.0/24"]
  type    = list(any)
}
