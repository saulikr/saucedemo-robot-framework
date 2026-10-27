# SauceDemo UI Tests

Robot Framework UI tests for [SauceDemo](https://www.saucedemo.com/).

## Prerequisites (macOS)

Install [Python 3.12 for macOS (.pkg)](https://www.python.org/ftp/python/3.12.10/python-3.12.10-macos11.pkg). Internet access is required to install dependencies and run the tests.

Open a new terminal in the project folder after installing Python.

## Setup

```bash
python3.12 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
rfbrowser install chromium
```

## Run all tests

```bash
bash run_tests.sh
```

To watch the browser:

```bash
HEADLESS=False bash run_tests.sh
```

Each run is saved separately under `results/<timestamp>/`: reports in `reports/` and the dated order receipt in `pdf/`. Previous runs are preserved.
