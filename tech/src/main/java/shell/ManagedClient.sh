#!/bin/bash
sudo mkdir /System/Library/LaunchAgentsDisabled;
sudo mkdir /System/Library/LaunchDaemonsDisabled;
sudo mv /System/Library/LaunchAgents/com.apple.ManagedClientAgent.agent.plist /System/Library/LaunchAgentsDisabled;
sudo mv /System/Library/LaunchAgents/com.apple.ManagedClientAgent.enrollagent.plist /System/Library/LaunchAgentsDisabled;
sudo mv /System/Library/LaunchDaemons/com.apple.ManagedClient.cloudconfigurationd.plist /System/Library/LaunchDaemonsDisabled;
sudo mv /System/Library/LaunchDaemons/com.apple.ManagedClient.enroll.plist /System/Library/LaunchDaemonsDisabled;
sudo mv /System/Library/LaunchDaemons/com.apple.ManagedClient.plist /System/Library/LaunchDaemonsDisabled;
sudo mv /System/Library/LaunchDaemons/com.apple.ManagedClient.startup.plist /System/Library/LaunchDaemonsDisabled;