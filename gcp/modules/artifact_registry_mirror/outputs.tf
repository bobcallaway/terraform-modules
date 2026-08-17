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

output "repository_urls" {
  description = "Registry path prefix per repository ID. Append the upstream path to reference a mirrored artifact."
  value = {
    for repository_id, repository in google_artifact_registry_repository.remote :
    repository_id => "${repository.location}-docker.pkg.dev/${repository.project}/${repository.repository_id}"
  }
}

output "repository_ids" {
  description = "Fully qualified Artifact Registry repository resource IDs, keyed by repository ID"
  value = {
    for repository_id, repository in google_artifact_registry_repository.remote :
    repository_id => repository.id
  }
}
