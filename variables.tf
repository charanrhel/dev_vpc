variable "pub_cidr" {
  default = ["192.0.1.0/24", "192.0.2.0/24", "192.0.3.0/24"]
  type    = list(any)
}

variable "priv_cidr" {
  default = ["192.0.4.0/24", "192.0.5.0/24", "192.0.6.0/24"]
  type    = list(any)
}

variable "data_cidr" {
  default = ["192.0.7.0/24", "192.0.8.0/24", "192.0.9.0/24"]
  type    = list(any)
}

/* resource "aws_key_pair" "deployer" {
  key_name   = "newkey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCy6R1MRMj6+MEUe+B4RLNNumsrObADnmey5a4zkFV+26lylGmq0I/KThFByDlVcRNHsbEz4bBJ7WwGdvMDFZJBsduQ+4EN6zBMkcJGdat3ahLLnSr1l42iqZsULaWAFC5lrDSIoBd6s/HesIePwaHIpuLEdSFq4nec/vTVJ7+X2wmQdFQcA0XjmBQIYE35+WW46MX30ZIqr9DQsiotSheBGoSHOuw87wuhK7SsTCeEhLvdxS4glu54v+x6QbbDmw8rIipM8BFNTJL1BAykSIQLMWVT6zIWAJvRxJR6FpuaYPBNkFBUCNf97E6owdS8w47DRRgBcH/ntoiljhayYvsT charankumardama@charans-mbp.lan"
} */