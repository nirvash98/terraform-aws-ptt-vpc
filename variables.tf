variable "vpc_cidr_block" {
    type = string
}

variable "public_subnet_cidr_block" {
    type = list
}

variable "private_subnet_cidr_block" {
    type = list
}

variable "region" {}

variable "cz_tags" {}

variable "project_name" {}

variable "avail_zones" {}