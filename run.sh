#! /bin/bash

python3 -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
#pip3 install -r requirements.txt
export FLASK_APP=app.py
flask run --debug
