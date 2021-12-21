# Change Infrastructure

In the previous tutorial, we created our first infrastructure with Terraform: a VPC network. In this tutorial, we will modify our configuration, and learn how to apply changes to our Terraform projects.

Infrastructure is continuously evolving, and Terraform was built to help manage resources over their lifecycle. When you update Terraform configurations, Terraform builds an execution plan that only modifies what is necessary to reach your desired state.

When using Terraform in production, we recommend that you use a version control system to manage your configuration files, and store your state in a remote backend such as Terraform Cloud or Terraform Enterprise.

In this session, we will builds on configuration from [previous tutorial](./03-build-infra.md). We will first add more attributes to the existing VPC, then add a subnet and CVM to the network.

## Update and add attribute to existing resources

If we take a look at [the Terraform API specification for Tencent VPC](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpc#argument-reference), you can see that we didn't provide `is_multicast` in our previous tutorial. This attribute is optional, so the previous example works fine. Terraform just uses the default value 'true' if we don't have it in our configuration. Now, we can change it to 'false' by adding one line into _main.tf_.

```
resource "tencentcloud_vpc" "jliao-vpc" {
  name         = "vpc-jliao-tf"
  cidr_block   = "10.2.0.0/16"
  dns_servers  = ["183.60.83.19", "183.60.82.98", "8.8.8.8"]
  is_multicast = false

  tags = {
    "bu" = "nasa"
    "created_by" = "jliao"
  }
}
```

Now, if we ran `terraform plan` and then `terraform apply`, we can see our VPC is updated with this attribute value.  

## Create a new resource

Let's add two new resources, one subnet and one CVM into the _main.tf_ file.

```
# Subnet creation

resource "tencentcloud_subnet" "subnet1" {
  availability_zone = var.availability_zone
  name              = "public-subnet"
  vpc_id            = tencentcloud_vpc.jliao-vpc.id
  cidr_block        = "10.2.0.0/24"
  is_multicast      = false

  tags = {
    "bu" = "nasa"
    "created_by" = "jliao"
  }
}

# CVM creation
data "tencentcloud_images" "cvm_image" {
  image_type = ["PUBLIC_IMAGE"]
  os_name    = "centos"
}

data "tencentcloud_instance_types" "cvm_instance_types" {
  filter {
    name   = "instance-family"
    values = ["S3"]
  }

  cpu_core_count = 1
  memory_size    = 1
}

// Create 1 CVM instances to host awesome_app
resource "tencentcloud_instance" "tf_test_cvm" {
  instance_name              = "tf_test_cvm"
  availability_zone          = var.availability_zone
  image_id                   = data.tencentcloud_images.cvm_image.images.0.image_id
  instance_type              = data.tencentcloud_instance_types.cvm_instance_types.instance_types.0.instance_type
  system_disk_type           = "CLOUD_PREMIUM"
  system_disk_size           = 50
  hostname                   = "tfcvm1"
  project_id                 = 0
  vpc_id                     = tencentcloud_vpc.jliao-vpc.id
  subnet_id                  = tencentcloud_subnet.subnet1.id
  #internet_max_bandwidth_out = 20
  count                      = 1
  cam_role_name              = "CVM_QcsRole"

  data_disks {
    data_disk_type = "CLOUD_PREMIUM"
    data_disk_size = 50
    encrypt        = false
  }

  tags = {
    "bu" = "nasa"
    "created_by" = "jliao"
  }
}
```

The snippet above includes two resources. It is straight-forward if you check their attributes against Tencent Cloud Terraform APIs for [Subnet](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/subnet#argument-reference) and [CVM](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/instance#argument-reference).

You may notice the _data_ blocks when creating the CVM instance. In Terraform, the _data_ block is used to refer to the existing resources which are not provisioned by current Terraform set. For example, in this sample, instance type and CVM image are provided by Tencent Cloud. They have already been created and shared on Tencent Cloud platform.

Now, if you run `terraform plan` and `terraform apply`, Terraform will show you what resources or attributes will be changed.

You can find the whole set of source code discussed above under [src/update](../src/update) directory.

## Destructive changes  

A destructive change is a change that requires the provider to replace the existing resource rather than updating it. This usually happens because the cloud provider does not support updating the resource in the way described by your configuration.

Changing the availability zone of CVM instance is one example of a destructive change. Edit the availability_zone value in `terraform.tfvars` to change the availability_zone parameter used by Subnet and CVM in our configuration file.

When we run `terraform plan` or `terraform apply`, we can see the prefix _-/+_ for the resources which will be destroyed and recreated.

As indicated by the execution plan, Terraform first destroyed the existing instance and then created a new one in its place. We can use `terraform show` again to see the new values associated with this instance.

In Tencent Cloud provider's API document, the "**ForceNew**" label means change of this parameter will cause resource to be destroyed and recreated.  

```
The following arguments are supported:

availability_zone - (Required, ForceNew) The available zone for the CVM instance.
image_id - (Required) The image to use for the instance. Changing image_id will cause the instance reset.
...
```

[Main](../README.md) / [Prev](./03-build-infra.md) / [Next](./05-destroy-infra.md)
