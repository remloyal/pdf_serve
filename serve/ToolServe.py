from os import abort,system
import os
import sys
from flask import Flask, jsonify,request
from PyPDF2 import PdfReader
import threading
import socket  

app = Flask(__name__)

VERSION = 1
ALLOWED_EXTENSIONS = {'csv', 'pdf'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS
@app.route('/')
def index():
    return 'Welcome to tool'
@app.route('/version')
def get_version():
    return jsonify({"code":0,"message":'success',"data":VERSION})

def remove_quotes(s):
    return s.strip('"').strip("'")

@app.route('/file',methods=["POST","GET"])
def get_file():
    target_path = request.args.get('path')
    try:
        target_path = remove_quotes(target_path)
        if os.path.isfile(target_path):  # 如果给定路径是文件
            if allowed_file(target_path):
                if target_path.endswith('.pdf'):
                    with open(target_path, 'rb') as file:
                        reader = PdfReader(file)
                        pdf_content = ''
                        for page_number in range(len(reader.pages)):
                            pdf_content += reader.pages[page_number].extract_text()
                    return jsonify({"code":0,"message":'success',"data":pdf_content})
                else:  # For CSV files
                    with open(target_path, 'r') as file:
                        csv_content = file.read()
                    return jsonify({"code":0,"message":'success',"data":csv_content})
            else:
                return jsonify({"code":403,"message":'路径错误'})# 如果文件类型不被允许，则返回 403 错误
        elif os.path.isdir(target_path):  # 如果给定路径是文件夹
            files_content = {}
            for file_name in os.listdir(target_path):
                file_path = os.path.join(target_path, file_name)
                try:
                    if os.path.isfile(file_path) and allowed_file(file_name):
                        if file_name.endswith('.pdf'):
                            with open(file_path, 'rb') as file:
                                reader = PdfReader(file)
                                pdf_content = ''
                                for page_number in range(len(reader.pages)):
                                    pdf_content += reader.pages[page_number].extract_text()
                                files_content[file_name] = pdf_content
                        else:  # For CSV files
                            with open(file_path, 'r') as file:
                                csv_content = file.read()
                                files_content[file_name] = csv_content
                except Exception as e:
                    print(e)
            return  jsonify({"code":0,"message":'success',"data":files_content})
        else:
            return jsonify({"code":403,"message":'路径错误'}) # 如果路径既不是文件也不是文件夹，则返回 404 错误
    except Exception as e:
        print(e)
        return jsonify({"code":404,"message":e})
@app.route('/saveFile',methods=['POST'])
def save_file():
    # file = request.form.get("file")
    file = request.files.get("file")
    filePath = request.form.get("filePath")
    # filename = file.filename
    file.save(filePath)
    return jsonify({"code":0,"message":'success',"data":'csv_content'})
@app.route('/message')
def message():
    message = request.args.get('msg')
    print(f'message===>  {message}')
    return jsonify({"code":0,"message":message})

@app.route('/open',methods=['POST'])
def openFile():
    # path = request.args.get('path')
    path = request.json.get('path')
    try:
        system(f"open {path}")
    except Exception as e:
        print('Failed to start the server:', e)
    print(f'path===>  {path}')
    return jsonify({"code":0,"message":path})

def run_app(port):
    new_port = find_free_port(port)
    app.run(port=new_port)

def find_free_port(start_port=54321, end_port=54421):  
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  
    for port in range(start_port, end_port + 1):  
        try:  
            s.bind(('127.0.0.1', port))  
            s.close()  
            return port  
        except socket.error:  
            print(f'{port} 端口已被占用')
            pass  # Port is already bound, try next one  
    raise Exception("No free port found in the range {}-{}".format(start_port, end_port))  
  
if __name__=='__main__':
    if len(sys.argv) > 1:  # 如果传入了命令行参数
        port = sys.argv[1]
        try:
            # app.run(port=port)
            run_app(port)
        except Exception as e:
            print('Failed to start the server:', e)
    else:  # 如果没有传入命令行参数
        run_app(54321)

