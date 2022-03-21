variable "azs" {
  description = "The number of AZs"
  type        = number
}

variable "subnets_public" {
  description = "Set of availability zones in current region"
  type        = list(string)
}

variable "subnets_private" {
  description = "Set of availability zones in current region"
  type        = list(string)
}
