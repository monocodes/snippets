terraform {
  backend "s3" {
    bucket = "terra-state-mono"
    key    = "terraform/backend"
    region = "us-east-1"
  }
}