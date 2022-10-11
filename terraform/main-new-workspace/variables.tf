variable prefix {
  description = "The prefix for any Azure resources we create. By default this is $${username$$}-nlp-audio however username will be limited to 8 characters"
  type = string
  default = ""
}

variable region {
  description = "The region where we want to deploy our workspace and associated resources"
  type = string
  default = "Australia East"
}