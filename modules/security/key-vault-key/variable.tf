variable "name" {
  type        = string
  description = "Key name."
}

variable "key_vault_id" {
  type        = string
  description = "Key Vault resource ID."
}

variable "key_type" {
  type        = string
  description = "Key type (RSA, RSA-HSM, EC, EC-HSM)."
  default     = "RSA"
}

variable "key_size" {
  type        = number
  description = "Key size in bits."
  default     = 2048
}

variable "key_opts" {
  type        = list(string)
  description = "Key operations (decrypt, encrypt, sign, verify, wrapKey, unwrapKey)."
  default     = ["decrypt", "encrypt", "sign", "verify", "wrapKey", "unwrapKey"]
}

variable "expiration_date" {
  type        = string
  description = "Key expiration date (ISO8601)."
  default     = null
}

variable "not_before_date" {
  type        = string
  description = "Key not-before date (ISO8601)."
  default     = null
}

variable "rotation_policy" {
  type = object({
    expire_after         = optional(string, "P90D")
    notify_before_expiry = optional(string, "P29D")
    automatic = optional(object({
      time_before_expiry = string
    }))
  })
  description = "Key rotation policy for automatic rotation before expiry."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
