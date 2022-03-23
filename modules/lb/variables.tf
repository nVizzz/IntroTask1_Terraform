variable "name" {
  description = "The name of load balancer resources"
  type        = string
}

variable "lb_internal" {
  description = "Shows whether LB is internal or not"
  type        = bool
}

variable "lb_type" {
  description = "Type of the LB"
  type        = string
}

variable "enable_deletion_protection" {
  description = "Set whether to enable deletion protection"
  type        = bool
}

variable "lb_listener_port" {
  description = "Port of the LB listener"
  type        = number
}

variable "lb_listener_protocol" {
  description = "Protocol of the LB listener"
  type        = string
}

variable "target_group_port" {
  description = "Port of the target group"
  type        = number
}

variable "target_group_protocol" {
  description = "Protocol of the target group"
  type        = string
}
