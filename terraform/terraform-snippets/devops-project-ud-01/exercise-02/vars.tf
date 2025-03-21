variable "REGION" {
  default = "us-east-1"
}

variable "ZONE1" {
  default = "us-east-1a"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-east-1 = "ami-0889a44b331db0194"
    us-east-2 = "ami-08333bccc35d71140"
  }
}