variable "pipeline_name" {
  type = string
}

variable "repo_name" {
  type = string
}

variable "branch_name" {
  type = string
}

variable "repo_uri" {
  type = string
}

variable "date" {
  type = string
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "environment" {
  type = string
}

variable "subscription" {
  type = string
}

variable "cms_uri" {
  type = string
}

variable "schedule" {
  type = string
}