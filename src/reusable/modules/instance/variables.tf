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
