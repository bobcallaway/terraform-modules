/**
 * Copyright 2022 The Sigstore Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Resources for Certificate Authority
module "ca" {
  source = "../ca"

  # Disable CA creation if enable_ca is false
  count = var.enable_ca ? 1 : 0

  region       = var.region
  project_id   = var.project_id
  ca_pool_name = var.ca_pool_name
  ca_name      = var.ca_name
}

resource "google_dns_record_set" "A_fulcio" {
  name = "fulcio.${var.dns_domain_name}"
  type = "A"
  ttl  = 60

  project      = var.project_id
  managed_zone = var.dns_zone_name

  rrdatas = [var.load_balancer_ipv4]
}
