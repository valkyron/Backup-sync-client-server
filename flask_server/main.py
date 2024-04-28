# Flask server code (app.py)
from flask import Flask, send_file
import os
from datetime import datetime
import zipfile

app = Flask(__name__)

# Endpoint to serve the folder
@app.route('/download_backup')
def download_folder():
    folder_path = './backup'  # Change this to the path of your folder
    folder_name = 'backup'
    current_time = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    zip_file_path = f'{folder_name}_{current_time}.zip'  # Rename with datetime

    # zip_file_path = 'backup.json'

    # Create a zip file containing the folder contents
    with zipfile.ZipFile(zip_file_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for root, dirs, files in os.walk(folder_path):
            for file in files:
                zipf.write(os.path.join(root, file), os.path.relpath(os.path.join(root, file), folder_path))

    covered_zip_file_path = 'backup.zip'

    # Create a zip file containing the original zip file
    with zipfile.ZipFile(covered_zip_file_path, 'w', zipfile.ZIP_DEFLATED) as final_zip:
        final_zip.write(zip_file_path, os.path.basename(zip_file_path))


    # Send the zip file for download
    return send_file(covered_zip_file_path, as_attachment=True)

if __name__ == '__main__':
    app.run(debug=True)
    # app.run(host='172.31.13.126', port=5000, debug=True)
