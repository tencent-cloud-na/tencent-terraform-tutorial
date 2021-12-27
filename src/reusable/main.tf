/**
 * Copyright 2020 Tencent Cloud, LLC
 *
 * Licensed under the Mozilla Public License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.mozilla.org/en-US/MPL/2.0/
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# VPC creation

resource "tencentcloud_vpc" "jliao-vpc" {
  name         = "vpc-jliao-tf"
  cidr_block   = "10.2.0.0/16"
  dns_servers  = ["183.60.83.19", "183.60.82.98", "8.8.8.8"]
  is_multicast = false

  tags = {
    "bu"         = "nasa"
    "created_by" = "jliao"
  }
}

# Subnet creation

resource "tencentcloud_subnet" "subnet1" {
  availability_zone = var.availability_zone
  name              = "public-subnet"
  vpc_id            = tencentcloud_vpc.jliao-vpc.id
  cidr_block        = "10.2.0.0/24"
  is_multicast      = false

  tags = {
    "bu"         = "nasa"
    "created_by" = "jliao"
  }
}

# Use module to create different CVMs
data "tencentcloud_images" "centos_cvm_image" {
  image_type = ["PUBLIC_IMAGE"]
  os_name    = "centos"
}

data "tencentcloud_images" "ubuntu_cvm_image" {
  image_type = ["PUBLIC_IMAGE"]
  os_name    = "ubuntu"
}

data "tencentcloud_instance_types" "cvm_instance_types" {
  filter {
    name   = "instance-family"
    values = ["S3"]
  }

  cpu_core_count = 1
  memory_size    = 1
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
