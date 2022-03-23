variable "name" {
  description = "The name of the auto scaling group"
  type        = string
}

variable "max_size" {
  description = "The maximum size of the Auto Scaling Group"
  type        = number
}

variable "min_size" {
  description = "The minimum size of the Auto Scaling Group"
  type        = number
}

variable "tags" {
  description = "The tags of the Auto Scaling Group"
  type        = map(any)
}
