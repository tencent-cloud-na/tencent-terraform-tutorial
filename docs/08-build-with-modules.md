# Build Reusable Terraform Modules

In a real project, we always need to create the same resources, such as CVM, multiple times but with slight changes. It is very time-consuming and tedious to repeat the same code. So, we usually create reusable modules. Terraform module is similar to the concept of Class in Java or C++/C#.

In this session, we will try to create a CVM module, and then show how to create different CVM instances easily.

## Use environment variables for credential

Before we build our first module, let's take a look at how to use system parameters to set Terraform credentials first. So, we don't need to pass `secret_id` and `secret_key` to the modules.

In our previous examples, we specify `secret_id` and `secret_key` in the _variables.tf_, _provider.tf_ and _terraform.tfvars_. This is one way to pass credentials into Terraform. Another way to do so is set up _TENCENTCLOUD_SECRET_ID_ and _TENCENTCLOUD_SECRET_KEY_ system variables in the environment where we run our Terraform command.

- Let's create an _env-intl.sh_, and add the follow content into this file. Please modify the values to your own environment.

```
# Environment variables for Terraform script
export TENCENTCLOUD_SECRET_ID="IKIDSjmbCYxxxxxxxxxxxxxxx"
export TENCENTCLOUD_SECRET_KEY="4tUr0uYw4zyyyyyyyyyyyyyyy"
```
- Comment out or remove `secret_id` and `secret_key` from _variables.tf_, _provider.tf_ and _terraform.tfvars_ files.

- Make env-intl.sh executable and then source it.

```
chmod @+x env-intl.sh
source ./env-intl.sh
```

## Build a module for CVM instance

The source code for this exmample is under [src/reusable](../src/reusable).

- Create a subfolder for this module

```
mkdir modules/instance
```

- Under this folder, copy the _version.tf_ file. We need this file to instruct Terraform to use "tencentcloudstack/tencentcloud" provider because we don't have a provider in Hashicorp default registry yet.

- Create a _main.tf_, which will take variables for all attributes. (**Note**, we can also hardcode some value if we require any specific values for our project).

```
resource "tencentcloud_instance" "instance" {
  instance_name     = var.instance_name
  availability_zone = var.availability_zone
  image_id          = var.image_id
  instance_type     = var.instance_type
  system_disk_type  = var.system_disk_type
  system_disk_size  = var.system_disk_size
  project_id        = var.project_id
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id
  key_name          = var.key_name
  security_groups   = var.security_groups

  data_disks {
    data_disk_type = var.data_disk_type
    data_disk_size = var.data_disk_size
    encrypt        = var.data_disk_encryption
  }

  tags = var.instance_tags
}
```

- Create a _variables.tf_ to accept and pass in variable values. This is a great place for us to specify any default values for our project.

```

 variable "region" {
   default = ""
 }

 variable "project_id" {
   default = 0
 }

 variable "instance_name" {
   default = ""
 }

 variable "availability_zone" {
   default = ""
 }

 variable "image_id" {
   default = ""
 }

 variable "instance_type" {
   default = ""
 }

 variable "system_disk_type" {
   default = "CLOUD_PREMIUM"
 }

 variable "system_disk_size" {
   default = 50
 }

 variable "allocate_public_ip" {
   default = true
 }
 variable "vpc_id" {
   default = ""
 }

 variable "subnet_id" {
   default = ""
 }

 variable "internet_max_bandwidth_out" {
   default = 10
 }

variable "key_name" {
  default = ""
}
variable "security_groups" {
  type    = list(string)
  default = [""]
}

variable "data_disk_type" {
  default = "CLOUD_PREMIUM"
}

variable "data_disk_size" {
  default = 10
}

variable "data_disk_encryption" {
  default = false
}

variable "instance_tags" {
  type    = map(string)
  default = {}
}
```

- Create a _outputs.tf_ file to export values of this module to be used by other modules. In this example, we only export the id field.

```
output "instance_id" {
  value = tencentcloud_instance.instance.id
}
```

Please notice that we don't have the credentials in this module because we are using system environment variables. If you are not able to set your system variables, for example in some CI/CD environment, you need to copy over the _provider.tf_ file from previous examples as well.

## Use our CVM module

In the _main.tf_ of our last session, we will change the CVM section to use our new module to create two different CVM instances.

```
data "tencentcloud_images" "centos_cvm_image" {
  image_type = ["PUBLIC_IMAGE"]
  os_name    = "centos"
}

data "tencentcloud_images" "ubuntu_cvm_image" {
  image_type = ["PUBLIC_IMAGE"]
  os_name    = "ubuntu"
}

// Create Centos CVM instances to host awesome_app
module "tf_centos_cvm" {
  source            = "./modules/instance"
  count             = 2
  instance_name     = format("tf_centos_cvm_%s", count.index+1)
  availability_zone = var.availability_zone
  image_id          = data.tencentcloud_images.centos_cvm_image.images.0.image_id
  instance_type     = data.tencentcloud_instance_types.cvm_instance_types.instance_types.0.instance_type
  security_groups   = ["sg-6hjmg43g"]

  vpc_id            = tencentcloud_vpc.jliao-vpc.id
  subnet_id         = tencentcloud_subnet.subnet1.id

  instance_tags = {
    "bu"         = "nasa"
    "created_by" = "jliao"
  }
}

// Create Ubuntu CVM instance to host awesome_app
module "tf_ubuntu_cvm" {
  source            = "./modules/instance"
  count             = 1
  instance_name     = format("tf_ubuntu_cvm_%s", count.index+1)
  availability_zone = var.availability_zone
  image_id          = data.tencentcloud_images.ubuntu_cvm_image.images.0.image_id
  instance_type     = data.tencentcloud_instance_types.cvm_instance_types.instance_types.0.instance_type
  security_groups   = ["sg-6hjmg43g"]

  vpc_id            = tencentcloud_vpc.jliao-vpc.id
  subnet_id         = tencentcloud_subnet.subnet1.id

  instance_tags = {
    "bu"         = "nasa"
    "created_by" = "jliao"
  }
}
```

Note that we use `source` to refer to our module. Then, we can pass in different values for these two different CVM instances, but use the common default values.

It is one of the best practices to use module whenever possible. 


[Main](../README.md) / [Prev](./07-query-outputs.md) / [Next](./09-share-state.md)
