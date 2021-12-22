# Define Input variables

We now have enough Terraform knowledge to create useful configurations, but the examples so far have used hard-coded values except three variables used in `provider.tf`. Terraform configurations can include variables to make your configuration more dynamic and flexible.

## Define input Variables

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
