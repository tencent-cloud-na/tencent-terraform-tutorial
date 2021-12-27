

terraform {
  backend "cos" {
    region = "na-siliconvalley"
    bucket = "cos-tf-state-1253831162"
    prefix = "terraform/state"
  }
}
