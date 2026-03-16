terraform {
  backend "s3" {
    bucket         = "zoom-clone-tf-state-production-12345"
    key            = "core/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
