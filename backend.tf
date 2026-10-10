terraform {
  backend "s3" {
    bucket       = "gitactions-demo-15"
    key          = "terraform-cicd/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}