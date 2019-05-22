output "this_redshift_cluster_endpoint" {
  description = "The connection endpoint"
  value       = "${aws_redshift_cluster.this.endpoint}"
}

output "s3_bucket_rrn" {
  value       = "${aws_s3_bucket.s3_redshift_bucket.arn}"
}
