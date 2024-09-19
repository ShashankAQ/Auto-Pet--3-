# utils.py
import subprocess
import os

def download_weights():
    script_path = os.path.join('/opt/algorithm', 'download_model_weights.sh')
    subprocess.run(['bash', script_path], check=True)
