#!/bin/bash

sudo ps -ef | grep ToolServe_arm64 | grep -v grep | awk '{print $2}' | xargs kill -9  
sudo ps -ef | grep ToolServe_x86_64 | grep -v grep | awk '{print $2}' | xargs kill -9  

sudo launchctl unload -w "/Library/LaunchAgents/com.frigga.toolServe.plist"

sudo rm  -rf  "/Library/LaunchAgents/com.frigga.toolServe.plist"
sudo rm -rf "/usr/local/frigga"
sudo rm -rf "/tmp/frigga.log"
sudo rm -rf "/tmp/frigga.err.log"

sudo launchctl unload -w "/Library/LaunchAgents/com.frigga.toolServe.plist"

sudo ps -ef | grep ToolServe_arm64 | grep -v grep | awk '{print $2}' | xargs kill -9  
sudo ps -ef | grep ToolServe_x86_64 | grep -v grep | awk '{print $2}' | xargs kill -9  

# 调用 AppleScript 关闭终端窗口
osascript -e 'tell application "Terminal" to close first window' & exits
