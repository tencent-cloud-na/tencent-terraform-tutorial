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

  tags = {
    "bu" = "nasa"
    "created_by" = "jliao"
  }
}
