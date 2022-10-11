
variable region {
  description = "The region where we want to deploy our workspace and associated resources"
  type = string
  default = "Australia East"
}

variable prefix {
  description = "The prefix to use when we create Azure and Databricks resources"
  type = string
}

variable owner-username {
  description = "The users principal"
  type = string
}
