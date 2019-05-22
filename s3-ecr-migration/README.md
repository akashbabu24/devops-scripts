The migration.tf and variables.tf files are for creating destination S3 bucket and ECR repo (Not mandatory)

S3:
AWS profile is required to logon to AWS and get S3 bucket list for iterative migration.
We need to place bucket policy with appropriate access for source account's user in the destination account's bucket (need to authenticate to source AWS account with same user). Please refer 'aws-migration' bucket policy in Abbott-add account
S3 migration is straightforward. s3 recursive copy of all files in a repository under loop execution.

ECR:
ECR logon to both AWS accounts under consideration
Create tagged copies of un-tagged images in the source account repositories
ECR migration from source to destination account
