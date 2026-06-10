variable "resource_id" {
  description = "The ID of the resource to lock."
  type        = string
}


variable "lock_level" {
  description = "The level of the lock. Possible values are 'CanNotDelete' and 'ReadOnly'."
  type        = string
  default     = "CanNotDelete"
}

variable "resource_name" {
  description = "The name of the resource to lock."
  type        = string
}

variable "lock_notes" {
  description = "Any notes about the resource lock."
  type        = string
  default     = ""
}