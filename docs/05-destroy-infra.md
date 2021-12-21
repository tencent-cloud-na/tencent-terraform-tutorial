# Destroy infrastructure

We have created and modified infrastructure using Terraform. We will now learn how to destroy our Terraform-managed infrastructure.

Once we no longer need infrastructure, we might want to destroy it to reduce our security exposure and costs. For example, we may remove a production environment from service, or manage short-lived environments like build or testing systems. In addition to building and modifying infrastructure, Terraform can destroy or recreate the resources it manages.

The terraform destroy command terminates resources managed by our Terraform project. This command is the inverse of terraform apply in that it terminates all the resources specified in our Terraform state. It does not destroy resources running elsewhere that are not managed by the current Terraform project.

When we run `terraform destroy` in our Terraform project, the `-` prefix indicates that Terraform will destroy the instance and the network. As with apply, Terraform shows its execution plan and waits for approval before making any changes.

Answer `yes` to execute this plan and destroy the infrastructure.

As with terraform apply, Terraform determines the order in which resources must be destroyed. Tencent Cloud will not destroy a VPC network if there are other resources still in it, so Terraform waits until the instance is destroyed first. When performing operations, Terraform creates a dependency graph to determine the correct order of operations. In more complicated cases with multiple resources, Terraform will perform operations in parallel when it's safe to do so.


[Main](../README.md) / [Prev](./04-change-infra.md) / [Next](./06-define-inputs.md)
