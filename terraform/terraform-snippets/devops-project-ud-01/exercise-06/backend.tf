terraform {
  backend "s3" {
    bucket = "terra-state-mono"
    key    = "terraform/backend-exercise-06"
    region = "us-east-1"
  }
}