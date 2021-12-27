# Define Input Variables

We now have enough Terraform knowledge to create useful configurations, but the examples so far have used hard-coded values except three variables used in `provider.tf`. Terraform configurations can include variables to make your configuration more dynamic and flexible.

## Define input variables

Let's take a look at how variables work in Terraform configuration. If you open up `variables.tf`, you can see that we defined three variables.

```
variable "secret_id" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  type = string
}
```

Terraform supports [several variable types](https://www.terraform.io/language/expressions/types). We specify the variable type in the definition. Also, we can specify variable description and default value. For example, we can add an `availability_zone` variable into the `variables.tf` file.

```
variable "availability_zone" {
  type        = string
  default     = "na-siliconvalley-1"
  description = "The availability zone to provision our subnet and CVM."
}
```
In Terraform, none of "type", "default" or "description" attribute is required for variable definition. You can leave all attributes out by defining a variable with empty block, such as `variable "some_variable" {}`.

## Use variables in configuration

To use variable in our configuration, you can just refer to the variable using `var.` prefix. For example, we can change our "availability_zone" attribute in our subnet and CVM configuration from
```
  availability_zone          = "na-siliconvalley-1"
```
to
```
  availability_zone          = var.availability_zone
```

## Assign values to variables

Next, we can populate variables using values from a file. Terraform automatically loads files called `terraform.tfvars` or matching `*.auto.tfvars` in the working directory when running operations.

In our example, we already have a `terraform.tfvars`. We can just add a value into this file. If we don't provide a value, Terraform will use the default value if a default value is provided in variable definition.

```
region = "na-siliconvalley"
availability_zone = "na-siliconvalley-2"
secret_id  = "IKIDSjmbCYxxxxxxxxxxxxxxx"
secret_key = "4tUr0uYw4zyyyyyyyyyyyyyyy"
```
Save this file.

## Apply configuration

Now run `terraform apply`. You can see that our subnet and CVM resources are created in "na-siliconvalley-2". If we don't specify value for "availability_zone" in `terraform.tfvars`, we can verify that resources are created in "na-siliconvalley-1" which is the default value for "availability_zone" variable.

Terraform supports many ways to use and set variables. To learn more, follow our in-depth tutorial, [Customize Terraform Configuration with Variables](https://learn.hashicorp.com/tutorials/terraform/variables?in=terraform/configuration-language).

The source code for this session and next session is [here](../src/variable).

[Main](../README.md) / [Prev](./05-destroy-infra.md) / [Next](./07-query-outputs.md)
