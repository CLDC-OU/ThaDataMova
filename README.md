# ThaDataMova

It mova tha data 😎 (from a domain restricted network location) OUTTA THERE

## Dependencies

- [FileMover](https://github.com/CLDC-OU/FileMover)

## Setup

1. Clone the repository
   ```bash
   git clone https://github.com/CLDC-OU/ThaDataMova.git
   cd ThaDataMova
   ```
2. Create a virtual environment
   ```bash
   python -m venv .venv
   ```
3. Copy the `.env.example` file to `.env` and update the paths as described [below](#environment-variables)

### Environment Variables

An example `.env.example` file is provided. Copy it and rename it to `.env` then update the paths to match your environment.

- `NETWORK_PATH`: The path to the network location where the data is stored (i.e., the source)
- `LOCAL_PATH`: The path to the local folder where the data will be copied (i.e., the destination)
- `ARCHIVE_PATH`: The path to the archive location where the data will be moved after being copied (i.e., the archive destination)

## Usage

Schedule the script to run with `Schedule-Move.ps1`
```powershell
.\Schedule-Move.ps1
```