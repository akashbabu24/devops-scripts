The setup has two scripts - one is for looping mechanism for multiple servers (main_script.sh) and the other for core metrics fetch (metrics_calculation.sh)
The setup needs to be present in a bastion server to communciate to other servers and get the metrics.

main_Script:
AWS fetches current list of instance with IPs. To run this step, AWS profile is needed or AWS STS logon is required for authentication.
It needs a 'timer' file which is part of the repo. In case, this setup is replicated, this needs to be reset with current EPAC seconds value -- echo $(date +%s) is the command
It calculates the time duration between 'timer' time and curren time and judges if the files is older than one week. If so, it moves the output file to backup/ folder and resets the timer. New file is created to fetch metrics for the instance.
The second while loop takes care of executing the core script on the list of servers and putting the output in a csv file for usage.
Note: Currently, it ignores instances with tag 'public' as for BIS, the security rules for public ecs server is not allowed on 22 for SSH. This condition can be taken off for normal circumstances.

metrics_calculation:
Pretty straight forward command executions for cpu, memory and disk space.
