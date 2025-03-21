import os
import json
from googledrivedownloader import download_file_from_google_drive

user = os.getlogin()

PREFERENCES_FILE = f"/Users/{user}/preferences.json"

def load_preferences():
    if os.path.exists(PREFERENCES_FILE):
        with open(PREFERENCES_FILE, "r") as file:
            data = json.load(file)
            return data.get("savesFolder", ""), data.get("unzip", False)
    return "", False

def download(url):
    pathFromFile, unzip = load_preferences()
    
    if not pathFromFile:
        raise ValueError("savesFolder path is not set in preferences.json")
    
    if "/file/d/" in url:
        id_part = url.split("/file/d/")[1]
    elif "/folders/" in url:
        id_part = url.split("/folders/")[1]
    else:
        raise ValueError("Unknown URL format: " + url)

    id = id_part.split("/view")[0] if "/view" in id_part else id_part.split("?")[0]
    file_path = os.path.join(pathFromFile, f"{id}.zip")
    
    try:
        download_file_from_google_drive(file_id=id, dest_path=file_path, unzip=unzip, showsize=True)
        if unzip:
            os.remove(file_path)
    except Exception as e:
        if "does not look like a valid zip file" in str(e):
            if os.path.exists(file_path):
                os.remove(file_path)

            file_path = os.path.join(pathFromFile, f"{id}.rar")
            download_file_from_google_drive(file_id=id, dest_path=file_path, unzip=False, showsize=True)
        else:
            raise e
