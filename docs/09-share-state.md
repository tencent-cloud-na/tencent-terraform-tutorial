# Work as a Team

Terraform uses state files to keep the state of resources. If we take a look at the directory where we ran our Terraform commands, we should be able to find those state files. However, keeping state files on local server will cause issues if we have more than one person who will provision the resources. It will cause issue even if one single admin who needs to work from different machines.

Terraform backends define where Terraform's state snapshots are stored. A given Terraform configuration can either specify a backend, integrate with [Terraform Cloud](https://www.terraform.io/language/settings/terraform-cloud), or do neither and default to storing state locally.

## Use Tencent Cloud Terraform backend

Tencent Cloud provides [a backend for Terraform](https://www.terraform.io/language/settings/backends/cos) code to store state files into Tencent Cloud Object Storage. This backend supports [state locking](https://www.terraform.io/language/state/locking).

Let's create a COS bucket in Tencent Cloud and make sure that the access credential we use for Terraform has READ and WRITE permissions to this bucket. In this example, we create a bucket "cos-tf-state-1253831162" in "na-siliconvalley" region.

Then we create a new file, _backend.tf_, in the same directory as the other root level Terraform files. In this file, add the following content (Please update the region and bucket values for your environment).

```
terraform {
  backend "cos" {
    region = "na-siliconvalley"
    bucket = "cos-tf-state-1253831162"
    prefix = "terraform/state"
  }
}
```

With this configuration, we instruct Terraform to store state files under the "terraform/state" folder in "cos-tf-state-1253831162" COS bucket in Tencent Cloud Silicon Valley region. Terraform state will be written into the file `terraform/state/terraform.tfstate`.

To make use of the COS remote state in another configuration, use the `terraform_remote_state` [data source](https://www.terraform.io/language/state/remote-state-data).

For example, the following sample code for another Terraform project to use the state file in our example project.

```
data "terraform_remote_state" "foo" {
  backend = "cos"

  config = {
    region = "na-siliconvalley"
    bucket = "cos-tf-state-1253831162"
    prefix = "terraform/state"
  }
}
```

For additional configuration parameters, please refer to [Tencent Cloud Backend document](https://www.terraform.io/language/settings/backends/cos).

## Terraform CLOUD

Hashicorp provides Terraform CLOUD, a Cloud-based IaC workflow environment, for users to corporate and provision resources. Terraform CLOUD not only manages the state file in its cloud, but also provides a approve/reject workflow.

Using Terraform Cloud through the command line is called the CLI-driven run workflow. When you use the CLI workflow, operations like terraform plan or terraform apply are remotely executed in Terraform Cloud's run environment by default, with log output streaming to the local terminal.

However, we cannot use the CLI integration and a state backend in the same configuration; they are mutually exclusive.


[Main](../README.md) / [Prev](./08-build-with-modules.md) / [Next](./10-keep-learning.md)
