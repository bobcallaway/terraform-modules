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

variable "project_id" {
  type = string
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Must specify project_id variable."
  }
}

variable "project_number" {
  type    = string
  default = ""
}

variable "region" {
  description = "The region in which to create the VPC network"
  type        = string
}

variable "bastion_zone" {
  description = "Bastion zone"
  type        = string
  default     = ""
}

variable "tuf_region" {
  description = "The region in which to create the TUF bucket"
  type        = string
  default     = ""
}

variable "attestation_region" {
  description = "The region in which to create the attestation bucket"
  type        = string
  default     = ""
}

variable "attestation_bucket" {
  type        = string
  description = "Name of GCS bucket for attestation."
}

variable "attestation_storage_class" {
  type        = string
  description = "Storage class for attestation bucket."
  default     = "REGIONAL"
}

variable "tuf_bucket" {
  type        = string
  description = "Name of GCS bucket for TUF root."
}

variable "tuf_bucket_member" {
  type        = string
  description = "User(s) to grant access to the TUF GCS buckets."
  default     = "allUsers"
}

variable "tuf_storage_class" {
  type        = string
  description = "Storage class for TUF bucket."
  default     = "REGIONAL"
}

variable "tuf_service_account_name" {
  type        = string
  description = "Name of service account for TUF signing on GitHub Actions"
  default     = "tuf-gha"
}

variable "tuf_keyring_name" {
  type        = string
  description = "Name of KMS keyring for TUF metadata signing"
  default     = "tuf-keyring"
}

variable "tuf_key_name" {
  type        = string
  description = "Name of KMS key for TUF metadata signing"
  default     = "tuf-key"
}

variable "tuf_kms_location" {
  type        = string
  description = "Location of KMS keyring"
  default     = "global"
}

variable "tuf_main_page_suffix" {
  type        = string
  description = "path to tuf bucket's directory index when missing object is treated as potential directories"
  default     = "index.html"
}

variable "ca_pool_name" {
  description = "Certificate authority pool name"
  type        = string
  default     = "sigstore"
}

variable "ca_name" {
  description = "Certificate authority name"
  type        = string
  default     = "sigstore-authority"
}

variable "monitoring" {
  description = "Monitoring and alerting"
  type = object({
    enabled                  = bool
    fulcio_url               = string
    rekor_url                = string
    timestamp_url            = string
    dex_url                  = string
    ctlog_url                = string
    notification_channel_ids = list(string)
    timestamp_enabled        = bool
  })
  default = {
    enabled                  = false
    fulcio_url               = "fulcio.example.com"
    rekor_url                = "rekor.example.com"
    timestamp_url            = "timestamp.example.com"
    dex_url                  = "oauth2.example.com"
    ctlog_url                = "ctlog.example.com"
    notification_channel_ids = []
    timestamp_enabled        = false
  }
}

variable "create_slos" {
  description = "Creates SLOs when true. (Monitoring must be enabled.)"
  type        = bool
  default     = false
}

// Optional values that can be overridden or appended to if desired.
variable "cluster_name" {
  description = "The name to give the new Kubernetes cluster."
  type        = string
  default     = "sigstore-staging"
}

variable "cluster_network_tag" {
  type    = string
  default = ""
}

variable "tunnel_accessor_sa" {
  type        = list(string)
  description = "Email of group to give access to the bastion tunnel to"
}

variable "github_repo" {
  description = "Github repo for running Github Actions from."
  type        = string
}

variable "mysql_instance_name" {
  type        = string
  description = "Name for MySQL instance. If unspecified, will default to '[var.cluster-name]-mysql-[random.suffix]'"
  default     = ""
}

variable "mysql_db_name" {
  type        = string
  description = "Name for MySQL database name."
  default     = "trillian"
}

variable "ctlog_mysql_db_name" {
  type        = string
  description = "Name for MySQL database name for ctlog shards."
  default     = "trillian"
}

variable "mysql_db_version" {
  type        = string
  description = "MySQL database version."
  default     = "MYSQL_5_7"
}

variable "mysql_tier" {
  type        = string
  description = "Machine tier for MySQL instance."
  default     = "db-n1-standard-1"
}

variable "mysql_availability_type" {
  type        = string
  description = "Availability tier for MySQL"
  default     = "REGIONAL"
}

variable "mysql_replica_zones" {
  description = "List of zones for read replicas."
  type        = list(any)
  default     = []
}

variable "mysql_replica_tier" {
  type        = string
  description = "Machine tier for MySQL replica."
  default     = "db-n1-standard-1"
}

variable "mysql_ipv4_enabled" {
  type        = bool
  description = "Whether to enable ipv4 for MySQL instance."
  default     = false
}

variable "mysql_require_ssl" {
  type        = bool
  description = "Whether to require ssl for MySQL instance."
  default     = true
}

variable "mysql_backup_enabled" {
  type        = bool
  description = "Whether to enable backup configuration for MySQL instance."
  default     = true
}

variable "mysql_binary_log_backup_enabled" {
  type        = bool
  description = "Whether to enable binary log for backup for MySQL instance."
  default     = true
}

variable "mysql_collation" {
  type        = string
  description = "collation setting for database"
  default     = "utf8_general_ci"
}

variable "fulcio_keyring_name" {
  type        = string
  description = "Name of Fulcio keyring."
  default     = "fulcio-keyring"
}

variable "fulcio_intermediate_key_name" {
  type        = string
  description = "Name of Fulcio intermediate key."
  default     = "fulcio-intermediate-key"
}

variable "rekor_keyring_name" {
  type        = string
  description = "Name of Rekor keyring."
  default     = "rekor-keyring"
}

variable "rekor_key_name" {
  type        = string
  description = "Name of Rekor key."
  default     = "rekor-key"
}

variable "rekor_new_entry_pubsub_consumers" {
  type        = list(string)
  description = "List of IAM principals that can subscribe to events about new entries in the log"
  default     = []
}

variable "timestamp" {
  type = object({
    enabled = bool
  })
  default = {
    enabled = true
  }
  description = "global enable/disable for timestamp resources"
}

variable "timestamp_keyring_name" {
  type        = string
  description = "Name of Timestamp Authority keyring."
  default     = "timestamp-keyring"
}

variable "timestamp_encryption_key_name" {
  type        = string
  description = "Name of KMS key for encrypting Tink private key for Timestamp Authority."
  default     = "timestamp-key-encryption-key"
}

variable "timestamp_ca_key_name" {
  type        = string
  description = "Name of KMS key for self-signed CA for Timestamp Authority"
  default     = "timestamp-ca-key"
}

variable "iam_members_to_roles" {
  description = "Map of IAM member (e.g. group:foo@sigstore.dev) to a set of IAM roles (e.g. roles/viewer)"
  type        = map(set(string))
  default     = {}
}

variable "oslogin" {
  type = object({
    enabled          = bool
    enabled_with_2fa = bool
  })
  default = {
    enabled          = false
    enabled_with_2fa = false
  }
  description = "oslogin settings for access to VMs"
}

variable "dns_zone_name" {
  description = "Name of DNS Zone object in Google Cloud DNS"
  type        = string
  default     = ""
}

variable "dns_domain_name" {
  description = "Name of DNS domain name in Google Cloud DNS"
  type        = string
  default     = ""
}

variable "ctlog_shards" {
  type = map(object({
    mysql_db_version     = string
    mysql_tier           = string
    instance_name        = optional(string)
    mysql_database_flags = map(string)
  }))

  description = "Map of CTLog shards to create. If keys are '2022' and '2023', it would create 2 independent CTLog Cloud MySql instances named sigstore-staging-ctlog-2022 and sigstore-staging-ctlog-2023."
  default     = {}
}

variable "standalone_mysqls" {
  type        = list(string)
  description = "Array of Standalone mysql instances to create. Entry should be something like [postfix-1, postfix-2], which would then have 2 independent mysql instances created like <projectid>-<environment>-postfix-1 and  <projectid>-<environment>-postfix-2 Cloud SQL instances. For example running in staging with [rekor-ctlog-2022] would create sigstore-staging-standalone-rekor-ctlog-2022"
  default     = []
}

variable "standalone_mysql_tier" {
  type        = string
  description = "Machine tier for Standalone MySQL instance."
  default     = "db-n1-standard-4"
}

variable "standalone_mysql_ssl" {
  type        = bool
  description = "force connections to the database to use SSL"
  default     = true
}

//  Cluster node pool
variable "initial_node_count" {
  type    = number
  default = 3
}

variable "autoscaling_min_node" {
  type    = number
  default = 1
}

variable "autoscaling_max_node" {
  type    = number
  default = 10
}

variable "gke_autoscaling_resource_limits_resource_cpu_max" {
  type    = number
  default = 4
}

variable "gke_autoscaling_resource_limits_resource_mem_max" {
  type    = number
  default = 16
}

variable "gcs_logging_enabled" {
  type        = bool
  description = "enable/disable logging of GCS bucket traffic"
  default     = false
}

variable "gcs_logging_bucket" {
  description = "name of GCS bucket where storage logs will be written"
  type        = string
  default     = ""
}

variable "cluster_monitoring_components" {
  description = "The GKE components exposing metrics. Supported values include: SYSTEM_COMPONENTS, APISERVER, CONTROLLER_MANAGER, and SCHEDULER."
  type        = list(string)
  default     = ["SYSTEM_COMPONENTS"]
}

variable "gke_cluster_security_group" {
  description = "name of Google Group used for GKE Group RBAC; must be gke-security-groups@<yourdomain>"
  type        = string
}

variable "gke_oauth_scopes" {
  description = "OAuth scopes to assign to the cluster node config"
  type        = list(string)
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "gke_use_dns_endpoint" {
  description = "Use DNS-based control plane endpoint for GKE cluster"
  type        = bool
  default     = false
}

variable "gke_use_ip_endpoint" {
  description = "Use IP-based control plane endpoint for GKE cluster"
  type        = bool
  default     = true
}

variable "breakglass_sql_iam_group" {
  description = "Cloud IAM Group that should have database access in case of emergency"
  type        = string
  default     = ""
}

variable "mysql_database_flags" {
  type        = map(string)
  description = "configuration flags to set on the MySQL instance"
  default     = {}
}

variable "mysql_rekor_tier" {
  type        = string
  description = "Machine tier for Rekor MySQL instance."
  default     = "db-perf-optimized-N-4"
}

variable "mysql_edition_rekor" {
  type        = string
  description = "The edition of the instance, currently either ENTERPRISE or ENTERPRISE_PLUS"
  default     = "ENTERPRISE"
}

variable "mysql_edition_ctlog" {
  type        = string
  description = "The edition of the instance, currently either ENTERPRISE or ENTERPRISE_PLUS"
  default     = "ENTERPRISE"
}

variable "mysql_data_cache_enabled_rekor" {
  type        = bool
  description = "Whether the data cache is enabled for the instance"
  default     = false
}

variable "mysql_data_cache_enabled_ctlog" {
  type        = bool
  description = "Whether the data cache is enabled for the instance"
  default     = false
}

variable "audit_log_types" {
  type        = list(string)
  description = "list of audit log types to apply against allServices"
  default     = ["ADMIN_READ", "DATA_READ", "DATA_WRITE"]
}
