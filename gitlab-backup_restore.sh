#!/bin/bash

#installing rsync

display_usage() {
        echo "\nUsage:\n sudo bash <script_name> [parameters: backup, restore] \n"
        }

#backup create function
function backup {
	echo "backup block"
	sudo -u git -H gitlab-rake gitlab:backup:create RAILS_ENV=production BACKUP=dump1_$(date +%d%m%y)
	cp /etc/gitlab/gitlab.rb /etc/gitlab/gitlab-secrets.json /var/opt/gitlab/backups
	tar -rf /var/opt/gitlab/backups/dump1_$(date +%d%m%y)_gitlab_backup.tar /var/opt/gitlab/backups/gitlab.rb /var/opt/gitlab/backups/gitlab-secrets.json
}

#restore function
function restore {
	echo "restore block"
	echo "Restoring SHIFTS the current GitLab to the point the backup was taken. Do you really want to Restore?? yes/no"
	read decision
	if [[ $decision == "yes" ]]; then
		echo "Restoring based on decision"	
		#service gitlab stop
		#sudo -u git -H gitlab-rake gitlab:backup:restore RAILS_ENV=production BACKUP=${backup_file_name}
		#service gitlab restart
	else
		echo "Aborting Restore"
		exit 0
	fi
}

if [[ ( $# == "--help") ||  $# == "-h" ]] 
	then 
		display_usage
		exit 0
	fi 

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root, use sudo "$0" instead" 1>&2
   exit 1
fi

if [  $# -lt 1 ]
	then
		display_usage
		exit 1
	fi

echo "You have decided to go with \"$1\""
case $1 in
	"backup")
		echo "backup initiated"
		backup
		;;
	"restore")
		echo "pass backup TAR file name to restore from /var/opt/gitlab/backups:"
		read line
		backup_file_name=$line
		echo "using ${backup_file_name} to restore"
		restore
		;;
	"?")
		echo "Unknown Option $OPTARG"
		;;
esac

#check for the dependency tools availability and install accordingly
#rsync --version || apt-get install rsync
#tar --version || apt-get install tar
