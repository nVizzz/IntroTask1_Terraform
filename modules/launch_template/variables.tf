variable "name" {
  description = "The name of launch template"
  type        = string
}

variable "image_id" {
  description = "Image ID"
  type        = string
}

variable "instance_initiated_shutdown_behavior" {
  description = "Instance initiated shutdown behavior"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Whether associate public IP address or not"
  type        = bool
}

variable "common_tags" {
  description = "Resource tags"
  type        = map(any)
}

variable "user_data_base64" {
  description = "Base64 encoded user data script"
  type        = string
}
