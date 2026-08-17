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

variable "project_id" {
  description = "Project in which the mirror repositories are created"
  type        = string
}

variable "location" {
  description = "Artifact Registry location. Instantiate the module once per region so clusters pull in-region."
  type        = string
}

variable "upstreams" {
  description = <<-EOT
    Remote repositories to create, keyed by Artifact Registry repository ID.

    uri         - upstream registry, e.g. "https://ghcr.io"
    description - shown on the repository
    readers     - IAM members granted roles/artifactregistry.reader on this
                  repository only, e.g. ["serviceAccount:nodes@example.iam.gserviceaccount.com"]
  EOT

  type = map(object({
    uri         = string
    description = optional(string, "")
    readers     = optional(list(string), [])
  }))

  validation {
    condition     = alltrue([for u in var.upstreams : startswith(u.uri, "https://")])
    error_message = "Each upstream uri must be an https:// URL."
  }
}
