from filemover import Mover
import json
import os
from dotenv import load_dotenv

load_dotenv()


with open("tha-copya.json", "r") as f:
    copya_config = json.load(f)
with open("tha-archiva.json", "r") as f:
    archiva_config = json.load(f)

copya_config["source_directory"] = os.environ.get("NETWORK_PATH", "")
copya_config["destination_directory"] = os.environ.get("LOCAL_PATH", "")
archiva_config["source_directory"] = os.environ.get("NETWORK_PATH", "")
archiva_config["destination_directory"] = os.environ.get("ARCHIVE_PATH", "")

# Verify that the required environment variables are set
if not copya_config["source_directory"] or not copya_config["destination_directory"]:
    raise ValueError("NETWORK_PATH and LOCAL_PATH must be set in the environment variables.")
if not archiva_config["source_directory"] or not archiva_config["destination_directory"]:
    raise ValueError("NETWORK_PATH and ARCHIVE_PATH must be set in the environment variables.")
# Ensure the source and destination directories exist
if not os.path.exists(copya_config["source_directory"]):
    raise FileNotFoundError(f"Source directory {copya_config['source_directory']} does not exist.")
if not os.path.exists(copya_config["destination_directory"]):
    raise FileNotFoundError(f"Destination directory {copya_config['destination_directory']} does not exist.")
if not os.path.exists(archiva_config["source_directory"]):
    raise FileNotFoundError(f"Source directory {archiva_config['source_directory']} does not exist.")
if not os.path.exists(archiva_config["destination_directory"]):
    raise FileNotFoundError(f"Destination directory {archiva_config['destination_directory']} does not exist.")
# Ensure the source and destination directories are not the same
if copya_config["source_directory"] == copya_config["destination_directory"]:
    raise ValueError("Source and destination directories for copya must be different.")
if archiva_config["source_directory"] == archiva_config["destination_directory"]:
    raise ValueError("Source and destination directories for archiva must be different.")

# Create Mover instances and move files
copya = Mover(**copya_config)
archiva = Mover(**archiva_config)
copya.move_files()
archiva.move_files()