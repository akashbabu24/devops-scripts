import subprocess
from subprocess import call

s3_source_buckets, stderr = subprocess.Popen(['aws', 's3', 'ls', '--profile', '<profile>', '|', 'awk', '{print $3}'], shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()

s3_source_buckets_split = s3_source_buckets.decode("utf-8").strip().split("\n")

#destination_bucket=<destination_bucket name>

for source_bucket in s3_source_buckets_split:
    call('aws s3 cp s3://'+ source_bucket+' s3://'+destination_bucket +'/'+source_bucket + ' --profile <profile> --recursive', shell=True)
