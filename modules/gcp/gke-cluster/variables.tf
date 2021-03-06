variable "project_id" {
  type        = string
  description = "The project ID (required)"
}

variable "name" {
  type        = string
  description = "The name of the cluster (required)"
}

variable "description" {
  type        = string
  description = "The description of the cluster"
  default     = ""
}

variable "zonal" {
  type        = bool
  description = "Whether cluster is zonal or populates a whole region (default is set to true)"
  default     = true
}

variable "zones" {
  type        = list(string)
  description = "The zones to host the cluster in"
  default     = []
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
  default     = null
}

variable "release_channel" {
  type        = string
  description = "The release channel of this cluster (default is set to null)"
  default     = null
}

variable "kubernetes_version" {
  type        = string
  description = "The Kubernetes version of the cluster (default is set to latest)"
  default     = "latest"
}

variable "basic_auth_username" {
  type        = string
  description = "The username to be used with Basic Authentication (default is none; which disables BA)"
  default     = ""
}

variable "basic_auth_password" {
  type        = string
  description = "The password to be used with Basic Authentication (default is none; which disables BA)"
  default     = ""
}

variable "issue_client_certificate" {
  type        = bool
  description = ""
  default     = false
}

variable "database_encryption" {
  description = "Application-layer Secrets Encryption settings. The object format is {state = string, key_name = string}. Valid values of state are: \"ENCRYPTED\"; \"DECRYPTED\". key_name is the name of a CloudKMS key."
  type        = list(object({ state = string, key_name = string }))
  default     = [{ state = "DECRYPTED", key_name = "" }]
}

variable "enable_shielded_nodes" {
  type        = bool
  description = "Enable Shielded Nodes features on all nodes in this cluster"
  default     = true
}

variable "subnetwork_ip_cidr_range" {
  type        = string
  description = ""
}

variable "subnetwork_ip_cidr_range_pods" {
  type        = string
  description = ""
}

variable "subnetwork_ip_cidr_range_services" {
  type        = string
  description = ""
}

variable "enable_network_policy" {
  type        = bool
  description = "Whether to enable Kubernetes NetworkPolicy on the cluster (default is set to true)"
  default     = true
}

variable "enable_horizontal_pod_autoscaling" {
  type        = bool
  description = ""
  default     = false
}

variable "enable_vertical_pod_autoscaling" {
  type        = bool
  description = ""
  default     = false
}

variable "enable_http_load_balancing" {
  type        = bool
  description = ""
  default     = false
}

variable "node_pools" {
  type        = list(map(string))
  description = "List of maps containing node-pools"
  default     = [{ name = "default-node-pool" }]
}

variable "node_pools_labels" {
  type        = map(map(string))
  description = "Maps of maps containing node labels by node-pool name"
  default     = { all = {}, default-node-pool = {} }
}

variable "node_pools_tags" {
  type        = map(list(string))
  description = "Map of lists containing node network tags by node-pool name"
  default     = { all = [], default-node-pool = [] }
}

variable "node_pools_taints" {
  type        = map(list(object({ key = string, value = string, effect = string })))
  description = "Map of lists containing node taints by node-pool name"
  default     = { all = [], default-node-pool = [] }
}

variable "node_pools_metadata" {
  type        = map(map(string))
  description = "Map of maps containing node metadata by node-pool name"
  default     = { all = {}, default-node-pool = {} }
}

variable "resource_labels" {
  type        = map(any)
  description = "GCP resource labels for this cluster (default is empty map)"
  default     = {}
}

variable "disable_legacy_metadata_endpoints" {
  type        = bool
  description = "Disable the legacy metadata server endpoints on the node. (default true)"
  default     = true
}

variable "node_metadata" {
  description = "Specifies how node metadata is exposed to the workload running on the node"
  default     = "GKE_METADATA_SERVER"
  type        = string
}

variable "identity_namespace" {
  description = "Workload Identity namespace. (Default value of `enabled` automatically sets project based namespace `[project_id].svc.id.goog`)"
  type        = string
  default     = "enabled"
}

variable "initial_node_count" {
  description = ""
  type        = number
  default     = 0
}

variable "remove_default_node_pool" {
  description = ""
  type        = bool
  default     = false
}
variable "firewall_priority" {
  type        = number
  description = "Priority rule for firewall rules"
  default     = 1000
}
variable "firewall_inbound_ports" {
  type        = list(string)
  description = "List of TCP ports for admission/webhook controllers"
  default     = ["443", "8443", "9443", "10250", "15017"]
}

variable "service_account" {
  description = ""
  type        = string
  default     = ""
}

variable "create_service_account" {
  description = ""
  type        = bool
  default     = true
}

variable "maintenance_start_time" {
  description = ""
  type        = string
  default     = "10:00"
}
