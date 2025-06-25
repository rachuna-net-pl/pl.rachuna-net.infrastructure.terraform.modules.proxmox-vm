variable "hostname" {
  description = "The vm hostname name"
  type        = string
}

variable "description" {
  description = "The vm description"
  type        = string
}

variable "node_name" {
  description = "The node name"
  type        = string
}

variable "tags" {
  description = "The vm tags"
  type        = list(string)
}

variable "pool_id" {
  description = "The pool id"
  type        = string
}

variable "vm_id" {
  description = "The vm id"
  type        = number
}

variable "protection" {
  description = "The vm protection"
  type        = bool
  default     = false
}

variable "template" {
  description = "The vm template"
  type = object({
    node_name = string
    vm_id     = number
    full      = optional(bool)
  })
}

variable "memory" {
  description = "The vm memory"
  type = object({
    dedicated = optional(number)
    floating  = optional(number)
  })
}

variable "cpu" {
  description = "The vm cpu"
  type = object({
    cores   = optional(number)
    sockets = optional(number)
    type    = optional(string)
  })

}

variable "technical_user" {
  description = "The technical user"
  type = object({
    username    = string
    password    = optional(string)
    ssh_pub_key = string
  })
}

variable "is_dmz" {
  description = "Is production environment"
  type        = bool
  default     = false
}

variable "mac_address" {
  description = "Opcjonalny adres MAC dla VM"
  type        = string
  default     = null
}