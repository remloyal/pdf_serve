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


frigga="/usr/local/frigga"
if [ ! -d "$frigga" ];then
    mkdir "$frigga"
fi 

rm  -rf  "$frigga/ToolServe"
# 定义安装路径和可执行文件名称
install_path="$frigga/ToolServe"
arm64_name="/Applications/ToolServe_arm64"
x86_64_name="/Applications/ToolServe_x86_64"
shname="/Applications/ToolServe.sh"

# plist_name="/Applications/com.frigga.toolServe.plist"
plist_name="/Applications/com.frigga.toolServe.plist"

# ver =$(uname -m)
# # 将可执行文件复制到安装路径
# if [ "$ver" == "arm64"]; then
#     cp "$arm64_name" "$install_path"
# else
#     cp "$x86_64_name" "$install_path"
# fi
cp "$x86_64_name" "$frigga"
cp "$arm64_name" "$frigga"
cp "$shname" "$frigga"
cp "$plist_name" "/Library/LaunchAgents"


sleep 2
rm  -rf  "$arm64_name"
rm  -rf  "$x86_64_name"
rm  -rf  "$plist_name"
rm  -rf  "$shname"

sudo chmod a+x /Library/LaunchAgents/com.frigga.toolServe.plist
# sudo chmod 755 /usr/local/bin/ToolServe
sudo chmod a+x "$frigga/ToolServe_arm64"
sudo chmod a+x "$frigga/ToolServe_x86_64"
sudo chmod a+x "$frigga/ToolServe.sh"

# 设置可执行文件为后台运行程序
sleep 1
sudo launchctl unload -w "/Library/LaunchAgents/com.frigga.toolServe.plist"
sudo launchctl unload -w "/Library/LaunchAgents/com.example.toolServe.plist"
rm  -rf  "/Library/LaunchAgents/com.example.toolServe.plist"

sleep 3
sudo launchctl load -w "/Library/LaunchAgents/com.frigga.toolServe.plist"
