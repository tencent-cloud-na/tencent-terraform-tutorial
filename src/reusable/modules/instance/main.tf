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
