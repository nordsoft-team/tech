#!/bin/bash
#use this script in recovery mode
echo "disk list:"
ls "/Volumes"
read -p "please select the main disk:" disk
while [ ! -d "/Volumes/$disk/Users" ];do read -p "error, please input again:" disk; done
mkdir -p "/Volumes/$disk/System/Library/LaunchAgentsDisabled";
mkdir -p "/Volumes/$disk/System/Library/LaunchDaemonsDisabled";
mv "/Volumes/$disk/System/Library/LaunchAgents/com.apple.ManagedClientAgent.agent.plist" "/Volumes/$disk/System/Library/LaunchAgentsDisabled";
mv "/Volumes/$disk/System/Library/LaunchAgents/com.apple.ManagedClientAgent.enrollagent.plist" "/Volumes/$disk/System/Library/LaunchAgentsDisabled";
mv "/Volumes/$disk/System/Library/LaunchDaemons/com.apple.ManagedClient.cloudconfigurationd.plist" "/Volumes/$disk/System/Library/LaunchDaemonsDisabled";
mv "/Volumes/$disk/System/Library/LaunchDaemons/com.apple.ManagedClient.enroll.plist" "/Volumes/$disk/System/Library/LaunchDaemonsDisabled";
mv "/Volumes/$disk/System/Library/LaunchDaemons/com.apple.ManagedClient.plist" "/Volumes/$disk/System/Library/LaunchDaemonsDisabled";
mv "/Volumes/$disk/System/Library/LaunchDaemons/com.apple.ManagedClient.startup.plist" "/Volumes/$disk/System/Library/LaunchDaemonsDisabled";

ls -al "/Volumes/$disk/System/Library/LaunchAgentsDisabled";
ls -al "/Volumes/$disk/System/Library/LaunchDaemonsDisabled";