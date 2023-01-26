terraform {
  backend "s3" {
    bucket = "tf-bucket-iti"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
