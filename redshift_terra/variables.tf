variable "cluster_identifier" {
  description = "Custom name of the cluster"
	default = "my-cluster"
}

variable "cluster_version" {
  description = "Version of Redshift engine cluster"
  default     = "1.0"

  # Constraints: Only version 1.0 is currently available.
  # http://docs.aws.amazon.com/cli/latest/reference/redshift/create-cluster.html
}

variable "cluster_node_type" {
  description = "Node Type of Redshift cluster"
default = "dc1.large"

  # Valid Values: dc1.large | dc1.8xlarge | dc2.large | dc2.8xlarge | ds2.xlarge | ds2.8xlarge.
  # http://docs.aws.amazon.com/cli/latest/reference/redshift/create-cluster.html
}

variable "cluster_number_of_nodes" {
  description = "Number of nodes in the cluster (values greater than 1 will trigger 'cluster_type' of 'multi-node')"
  default     = 3
}

variable "cluster_database_name" {
  description = "The name of the database to create"
default = "mydb"
}

# Self-explainatory variables
variable "cluster_master_username" {
	default = "akashbabu24"
}

variable "cluster_master_password" {
	default = "a123456A"
}

variable "cluster_port" {
  default = 5439
}

# This is for a custom parameter to be passed to the DB
# We're "cloning" default ones, but we need to specify which should be copied
variable "cluster_parameter_group" {
  description = "Parameter group, depends on DB engine used"
  default     = "redshift-1.0"
}

variable "cluster_iam_roles" {
  description = "A list of IAM Role ARNs to associate with the cluster. A Maximum of 10 can be associated to the cluster at any time."
  type        = "list"
  default     = []
}

variable "publicly_accessible" {
  description = "Determines if Cluster can be publicly available (NOT recommended)"
  default     = false
}
