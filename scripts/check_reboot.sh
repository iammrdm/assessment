#!/bin/bash

# AWS CLI must be configured with proper permissions
# Required variables
EC2_INSTANCE_ID="${1}"
SNS_TOPIC_ARN="${2}"

# Get the current day of the month
current_day=$(date +%d)

# Check if the current day is an odd number
if (( current_day % 2 != 0 )); then
    # Attempt to reboot the EC2 instance
    reboot_response=$(aws ec2 reboot-instances --instance-ids $EC2_INSTANCE_ID 2>&1)
    reboot_status=$?

    if [ $reboot_status -eq 0 ]; then
        message="Reboot of EC2 instance $EC2_INSTANCE_ID was successful."
    else
        message="Reboot of EC2 instance $EC2_INSTANCE_ID failed. Error: $reboot_response"
    fi

    # Publish message to SNS topic
    aws sns publish --topic-arn $SNS_TOPIC_ARN --message "$message"

    echo $message
else
    echo "Today is not an odd day of the month. No action taken."
fi
