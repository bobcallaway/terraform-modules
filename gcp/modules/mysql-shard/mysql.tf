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

# MySQL that only creates a mysql instance. Different from the ../mysql
# which creates serviceaccounts and services, etc. New shards for fulcio/rekor
# should use this module.
# Forked from https://github.com/GoogleCloudPlatform/gke-private-cluster-demo/blob/master/terraform/postgres.tf

resource "google_sql_database_instance" "trillian" {
  project          = var.project_id
  name             = var.instance_name
  database_version = var.database_version
  region           = var.region

  # Set to false to delete this database using terraform
  deletion_protection = var.deletion_protection

  settings {
    tier              = var.tier
    edition           = var.edition
    activation_policy = "ALWAYS"
    availability_type = var.availability_type

    dynamic "data_cache_config" {
      for_each = var.data_cache_enabled ? ["yes"] : []

      content {
        data_cache_enabled = true
      }
    }

    # this sets the flag on the GCP platform to prevent deletion across all API surfaces
    deletion_protection_enabled = var.deletion_protection

    ip_configuration {
      ipv4_enabled    = var.ipv4_enabled
      private_network = var.network
      ssl_mode        = var.require_ssl ? "TRUSTED_CLIENT_CERTIFICATE_REQUIRED" : "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    }

    database_flags {
      name  = "cloudsql_iam_authentication"
      value = "on"
    }

    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = database_flags.key
        value = database_flags.value
      }
    }

    backup_configuration {
      enabled            = var.backup_enabled
      binary_log_enabled = var.binary_log_backup_enabled
    }
  }

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}

resource "google_sql_database_instance" "read_replica" {
  for_each = toset(var.replica_zones)

  name                 = "${google_sql_database_instance.trillian.name}-replica-${each.key}"
  master_instance_name = google_sql_database_instance.trillian.name
  region               = var.region
  database_version     = var.database_version

  replica_configuration {
    failover_target = false
  }

  settings {
    tier              = var.replica_tier
    edition           = var.edition
    availability_type = "ZONAL"

    dynamic "data_cache_config" {
      for_each = var.data_cache_enabled ? ["yes"] : []

      content {
        data_cache_enabled = true
      }
    }

    ip_configuration {
      ipv4_enabled    = var.ipv4_enabled
      private_network = var.network
      ssl_mode        = var.require_ssl ? "TRUSTED_CLIENT_CERTIFICATE_REQUIRED" : "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    }

    database_flags {
      name  = "cloudsql_iam_authentication"
      value = "on"
    }
  }
}

resource "google_sql_database" "trillian" {
  name       = var.db_name
  project    = var.project_id
  instance   = google_sql_database_instance.trillian.name
  collation  = var.collation
  depends_on = [google_sql_database_instance.trillian]
}

resource "google_sql_user" "trillian" {
  name       = "trillian"
  project    = var.project_id
  instance   = google_sql_database_instance.trillian.name
  password   = var.password
  host       = "%"
  depends_on = [google_sql_database_instance.trillian]
}

// be sure to manually GRANT SELECT, INSERT, CREATE privileges for this user
resource "google_sql_user" "iam_user" {
  name     = var.cloud_sql_iam_service_account
  instance = google_sql_database_instance.trillian.name
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
}

resource "google_project_iam_member" "db_iam_auth" {
  project = var.project_id
  role    = "roles/cloudsql.instanceUser"
  member  = "serviceAccount:${var.cloud_sql_iam_service_account}"
}

resource "google_sql_user" "breakglass_iam_group" {
  count    = var.breakglass_iam_group != "" ? 1 : 0
  name     = var.breakglass_iam_group
  instance = google_sql_database_instance.trillian.name
  type     = "CLOUD_IAM_GROUP"
}

resource "google_project_iam_member" "breakglass_iam_group_permissions" {
  for_each = toset([
    "roles/cloudsql.client",
    "roles/cloudsql.instanceUser"
  ])
  project = var.project_id
  role    = each.key
  member  = var.breakglass_iam_group != "" ? "group:${var.breakglass_iam_group}" : null
}
