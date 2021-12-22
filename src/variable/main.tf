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

# CVM Creation
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
  instance_name     = "tf_test_cvm"
  availability_zone = var.availability_zone
  image_id          = data.tencentcloud_images.cvm_image.images.0.image_id
  instance_type     = data.tencentcloud_instance_types.cvm_instance_types.instance_types.0.instance_type
  system_disk_type  = "CLOUD_PREMIUM"
  system_disk_size  = 50
  hostname          = "tfcvm1"
  project_id        = 0
  vpc_id            = tencentcloud_vpc.jliao-vpc.id
  subnet_id         = tencentcloud_subnet.subnet1.id
  #internet_max_bandwidth_out = 20
  count         = 1
  cam_role_name = "CVM_QcsRole"

  data_disks {
    data_disk_type = "CLOUD_PREMIUM"
    data_disk_size = 50
    encrypt        = false
  }

  tags = {
    "bu"         = "nasa"
    "created_by" = "jliao"
  }
}
