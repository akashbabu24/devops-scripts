The instance count setup is available in Jenkins as two jobs. One for populating the heading for every new file/month (instance_count_title) 
and the other(instance_count) is the core functionality. 
The core job is scheduled to run every 12 hours and the necessary login steps (direct logon and assume role) are handled as part of the 'masked' environment variables and in scripting.

The server script (count_server_test.sh) was the initial script that was tested before migrating to Jenkins, and is placed only for reference.
