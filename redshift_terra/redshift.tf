provider "aws" {
  region = "eu-west-1"
}

resource "aws_redshift_cluster" "this" {
  cluster_identifier = "${var.cluster_identifier}"
  node_type = "${var.cluster_node_type}"
  number_of_nodes = "${var.cluster_number_of_nodes}"
  cluster_type = "${var.cluster_number_of_nodes > 1 ? "multi-node" : "single-node" }"
  database_name = "${var.cluster_database_name}"
  master_username = "${var.cluster_master_username}"
  master_password = "${var.cluster_master_password}"

#  cluster_parameter_group_name = "${local.parameter_group_name}"

  publicly_accessible = "${var.publicly_accessible}"

  iam_roles = [
    "${aws_iam_role.redshift_s3_role.arn}"]

  #tags = "${var.tags}"
}

resource "aws_s3_bucket" "s3_redshift_bucket" {
  bucket = "bucket_name"
  acl    = "private"
  tags {
    Name = "bucket_name"
    Component = "s3"
    Owner = "terraform"
  }
}

resource "aws_iam_role" "redshift_s3_role" {
  name = "redshift_s3_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "redshift.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "redshift_s3_policy" {

  name = "redshift_s3_policy"
  description = "policy for redshift s3 role"

  policy =<<EOF
{
  "Version"
  : "2012-10-17",
"Statement": [
{
"Sid": "redshift iam role",
"Effect": "Allow",
"Action": [
"s3:PutAnalyticsConfiguration",
"s3:GetObjectVersionTagging",
"s3:CreateBucket",
"s3:ReplicateObject",
"s3:GetObjectAcl",
"s3:DeleteBucketWebsite",
"s3:PutLifecycleConfiguration",
"s3:GetObjectVersionAcl",
"s3:PutObjectTagging",
"s3:HeadBucket",
"s3:DeleteObject",
"s3:DeleteObjectTagging",
"s3:GetBucketPolicyStatus",
"s3:GetBucketWebsite",
"s3:PutReplicationConfiguration",
"s3:DeleteObjectVersionTagging",
"s3:GetBucketNotification",
"s3:PutBucketCORS",
"s3:GetReplicationConfiguration",
"s3:ListMultipartUploadParts",
"s3:PutObject",
"s3:GetObject",
"s3:PutBucketNotification",
"s3:PutBucketLogging",
"s3:GetAnalyticsConfiguration",
"s3:GetObjectVersionForReplication",
"s3:GetLifecycleConfiguration",
"s3:ListBucketByTags",
"s3:GetInventoryConfiguration",
"s3:GetBucketTagging",
"s3:PutAccelerateConfiguration",
"s3:DeleteObjectVersion",
"s3:GetBucketLogging",
"s3:ListBucketVersions",
"s3:ReplicateTags",
"s3:RestoreObject",
"s3:ListBucket",
"s3:GetAccelerateConfiguration",
"s3:GetBucketPolicy",
"s3:PutEncryptionConfiguration",
"s3:GetEncryptionConfiguration",
"s3:GetObjectVersionTorrent",
"s3:AbortMultipartUpload",
"s3:PutBucketTagging",
"s3:GetBucketRequestPayment",
"s3:GetObjectTagging",
"s3:GetMetricsConfiguration",
"s3:DeleteBucket",
"s3:PutBucketVersioning",
"s3:GetBucketPublicAccessBlock",
"s3:ListBucketMultipartUploads",
"s3:PutMetricsConfiguration",
"s3:PutObjectVersionTagging",
"s3:GetBucketVersioning",
"s3:GetBucketAcl",
"s3:PutInventoryConfiguration",
"s3:GetObjectTorrent",
"s3:GetAccountPublicAccessBlock",
"s3:PutBucketWebsite",
"s3:ListAllMyBuckets",
"s3:PutBucketRequestPayment",
"s3:GetBucketCORS",
"s3:GetBucketLocation",
"s3:ReplicateDelete",
"s3:GetObjectVersion"
],
"Resource": "*"
}
]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = "${aws_iam_role.redshift_s3_role.name}"
  policy_arn = "${aws_iam_policy.redshift_s3_policy.name}"
}
