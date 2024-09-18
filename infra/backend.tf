terraform {
  backend "s3" {
    bucket         = "lifi-devops-challenge"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "lifi-devops-challenge-lock-table"
    encrypt        = true
  }
}
