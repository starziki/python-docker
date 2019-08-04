#!/usr/bin/env python3
from flask import Flask
from machine_running import entry_point
app = Flask("app")

@app.route('/')
def index() :
    return entry_point()

if __name__ =='__main__':
    app.run("0.0.0.0", port=5000, debug=True) 