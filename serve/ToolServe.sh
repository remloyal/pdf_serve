
python3 -m venv venv
source ./venv/bin/activate
pip install PyPDF2 flask pyinstaller -i https://pypi.tuna.tsinghua.edu.cn/simple
sleep 3
pyinstaller -F -w ToolServe.py