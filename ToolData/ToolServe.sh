#!/bin/bash

frigga="/usr/local/frigga"
arm64_name="ToolServe_arm64"
x86_64_name="ToolServe_x86_64"

ver=$(uname  -m)
echo $ver
# 将可执行文件复制到安装路径
if [ "$ver" == "x86_64" ]; then
    "/usr/local/frigga/ToolServe_x86_64"
else
    "/usr/local/frigga/ToolServe_arm64"
fi