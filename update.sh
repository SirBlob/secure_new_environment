#!/bin/bash

# Will require sudo access
# Based on https://alphacybersecurity.tech/how-to-secure-your-kali-linux-machine/

printf -- '-%.0s' {1..100}; echo ""
PS3='Enter your choice: ' #Automatically used by select
option=("Change your password" "apt-get Update / Upgrade" "Change Default SSH Key" "Add New User")
aptget=("apt-get update" "apt-get upgrade" "Both" "apt-get dist-upgrade")

select o in "${option[@]}"
do
	case $o in
		"Change your password") #Change current user password
			printf -- '-%.0s' {1..100}; echo ""
			echo "Changing current user password"
			printf -- '-%.0s' {1..100}; echo ""
			passwd	;;
		"apt-get Update / Upgrade") #Upgrade / Update 
			printf -- '-%.0s' {1..100}; echo ""
			echo "Please enter a choice"
			printf -- '-%.0s' {1..100}; echo ""
			select a in "${aptget[@]}"
			do
				case $a in 
					"apt-get update")
						apt-get update	;;
					"apt-get upgrade")
						apt-get upgrade ;;
					"Both")
						apt-get update 
						apt-get upgrade ;;
					"apt-get dist-upgrade")
						apt-get dist-upgrade ;;
					"Exit")
						break ;;
					*) 
						printf -- '-%.0s' {1..100}; echo ""
						echo "Invalid Choice"
						printf -- '-%.0s' {1..100}; echo "" ;;
				esac
			done ;;
		"Change Default SSH Key") #Reset default SSH Key
			printf -- '-%.0s' {1..100}; echo ""
			echo "Resetting SSH Key and creating backup"
			echo "Backing Up Current Keys in new directory: /etc/ssh/backup_keys"
			printf -- '-%.0s' {1..100}; echo ""
			cd /etc/ssh
		       	if [ -d backup_keys ] 
			then
				echo "The directory backup_keys exists"
				echo "Moving old keys now..."
				mv ssh_host_* /etc/ssh/backup_keys/
				dpkg-reconfigure openssh-server
				ls -l
			else
				echo "Creating directory: backup_keys"
				echo "Moving old keys..."
				mkdir backup_keys
				mv ssh_host_* /etc/ssh/backup_keys/
				dpkg-reconfigure openssh-server
				ls -l
			fi
			;;
		"Add New User") #Add a new user
			printf -- '-%.0s' {1..100}; echo ""
			echo "Please specify username"
			read -p "Username: " newuser
			adduser $newuser ;;
		*) 
			printf -- '-%.0s' {1..100}; echo ""
			echo "Invalid Choice $o"
			printf -- '-%.0s' {1..100}; echo "" ;;
	esac
done
