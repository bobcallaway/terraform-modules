/**
 * Copyright 2026 The Sigstore Authors
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

locals {
  // one entry per (repository, reader) pair so IAM can be granted per repository
  // rather than at project level
  repository_readers = merge([
    for repository_id, upstream in var.upstreams : {
      for member in upstream.readers :
      "${repository_id} ${member}" => {
        repository_id = repository_id
        member        = member
      }
    }
  ]...)
}

// Remote repositories are lazy pull-through caches: an artifact is stored only
// once it has been requested through the mirror. Cleanup policies cannot be
// applied to them, so retention is manual by design.
resource "google_artifact_registry_repository" "remote" {
  for_each = var.upstreams

  project       = var.project_id
  location      = var.location
  repository_id = each.key
  description   = each.value.description
  format        = "DOCKER"
  mode          = "REMOTE_REPOSITORY"

  remote_repository_config {
    description = each.value.description

    docker_repository {
      custom_repository {
        uri = each.value.uri
      }
    }
  }
}

resource "google_artifact_registry_repository_iam_member" "reader" {
  for_each = local.repository_readers

  project    = var.project_id
  location   = var.location
  repository = google_artifact_registry_repository.remote[each.value.repository_id].repository_id
  role       = "roles/artifactregistry.reader"
  member     = each.value.member
}
