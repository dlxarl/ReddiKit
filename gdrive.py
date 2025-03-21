import os
import json
import zipfile
import sys
from googledrivedownloader import download_file_from_google_drive

try:
    import rarfile
except ImportError:
    rarfile = None

user = os.environ.get("USER") or os.environ.get("LOGNAME")
PREFERENCES_FILE = f"/Users/{user}/preferences.json"

def load_preferences():
    if os.path.exists(PREFERENCES_FILE):
        with open(PREFERENCES_FILE, "r") as file:
            data = json.load(file)
            return data.get("savesFolder", ""), data.get("unzip", False)
    else:
        sys.stderr.write(f"Error: Preferences file not found at {PREFERENCES_FILE}\n")
        sys.exit(1)

def is_valid_zip(file_path):
    return zipfile.is_zipfile(file_path)

def is_small_file(file_path, min_size=1_000_000):
    return os.path.exists(file_path) and os.path.getsize(file_path) < min_size

def download(file_id):
    pathFromFile, unzip = load_preferences()
    
    if not pathFromFile:
        sys.stderr.write("Error: savesFolder path is not set in preferences.json\n")
        sys.exit(1)
    
    if not os.path.exists(pathFromFile):
        sys.stderr.write(f"Error: The savesFolder path does not exist: {pathFromFile}\n")
        sys.exit(1)
    
    file_path = os.path.join(pathFromFile, f"{file_id}.zip")

    print(f"Downloading file with ID: {file_id} to {file_path}")
    try:
        download_file_from_google_drive(file_id=file_id, dest_path=file_path, unzip=False, showsize=True)

        if is_small_file(file_path):
            os.remove(file_path)
            sys.stderr.write("Error: Unable to archive the folder.\n")
            sys.exit(1)

        if unzip:
            if is_valid_zip(file_path):
                with zipfile.ZipFile(file_path, "r") as zip_ref:
                    zip_ref.extractall(pathFromFile)
                os.remove(file_path)
                print("ZIP file unzipped and original archive removed.")
            else:
                print("ZIP file is invalid. Retrying as RAR...")
                os.remove(file_path)
                file_path = os.path.join(pathFromFile, f"{file_id}.rar")

                download_file_from_google_drive(file_id=file_id, dest_path=file_path, unzip=False, showsize=True)

                if is_small_file(file_path):
                    os.remove(file_path)
                    sys.stderr.write("Error: Unable to archive the folder.\n")
                    sys.exit(1)

                if rarfile:
                    try:
                        with rarfile.RarFile(file_path) as rf:
                            rf.extractall(pathFromFile)
                        os.remove(file_path)
                        print("RAR file unzipped and original archive removed.")
                    except Exception as extract_err:
                        sys.stderr.write(f"Error: Failed to extract RAR file: {extract_err}\n")
                        sys.exit(1)
                else:
                    sys.stderr.write("Error: rarfile module is not installed. Install it with: pip install rarfile\n")
                    sys.exit(1)
        else:
            print(f"File successfully downloaded to: {file_path}")
    
    except Exception as e:
        sys.stderr.write(f"Error while downloading: {e}\n")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.stderr.write("Usage: python3 gdrive.py <FILE_ID>\n")
        sys.exit(1)
    
    file_id = sys.argv[1]
    download(file_id)
