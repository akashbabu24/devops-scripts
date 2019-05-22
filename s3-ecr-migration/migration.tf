provider "aws" {
  profile="${var.aws_profile}"
  region="${var.aws_region}"
}
terraform {
  backend "s3" {
    bucket="$TF_STATE_BUCKET"
    key = "$TF_STATE_KEY"
    dynamodb_table = "$TF_LOCK_TABLE"
    profile = "$AWS_PROFILE"
    region = "$AWS_REGION"
    encrypt = true
  }
}

#Migration bucket
resource "aws_s3_bucket" "s3_migration_dest_accnt_bucket" {
  bucket = "bucket1"
  tags {
    Name = "AWS S3 Full Migration Bucket"
    Component = "s3"
    Owner = "terraform"
  }
}

#Migration Buclet policy
resource "aws_s3_bucket_policy" "s3-migration-bucket-policy"{
  bucket = "${aws_s3_bucket.s3_migration_dest_accnt_bucket.id}"
  policy = <<POLICY
{
   "Version": "2012-10-17",
  "Statement": {
     "Sid": "AccessPolicyMigration",
    "Effect": "Allow",
   "Principal": {
      "AWS": "arn:aws:iam::<account>:user/<user>"
   },
 "Action": "s3:*",
 "Resource": [
   "arn:aws:s3:::<bucket_arn_name>",
   "arn:aws:s3:::<bucket_arn_name>/*"
  ]
 }
}
POLICY
}

#ECR repo for migration
resource "aws_ecr_repository" "ecr_migration_dest_accnt_repo" {
  name = "ecr_repo1"
}

#resource "null_resource" "s3_migration_script" {
 #  provisioner "local-exec" {
  #   command = "python s3-migration.py"
  # }
  #depends_on = ["aws_s3_bucket.dest_accnt_bucket"]
#}
