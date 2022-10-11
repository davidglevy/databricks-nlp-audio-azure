variable "workspace_url" {
  description = "The workspace URL, which was either created earlier and can be injected or has been added as a explicit variable"
  type = string
}

variable "main_username" {
  description = "The user who will own the cluster resources"
  type = string
}
