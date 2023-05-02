terraform {
  backend "s3" {
    bucket = "three-tier-infra-tfstate"
    key    = "tfstate//terraform.tfstate"
    region = "ap-south-1"
  }
}