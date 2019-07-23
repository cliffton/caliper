#!/usr/bin/python3

import sys
import psutil
from flask import Flask,request, jsonify

server = Flask(__name__)

PID = 0


@server.route('/stats')
def get_process_data():
    print("PID:" + str(PID))
    if psutil.pid_exists(PID):
        process = psutil.Process(pid=PID)
        cpu1 = process.cpu_percent(interval=1)
        print(cpu1)
        cpu2 = process.cpu_percent(interval=None)
        print(cpu2)
        mem = process.memory_percent(memtype="rss")
        print(mem)
        response = {
            'cpu_percent': cpu1,
            'mem_usage': mem
        }
    else:
        response = {
            'msg':"no such process"
        }
        return jsonify(response), 400
    return jsonify(response), 200


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 processMonitor.py <PID>")

    port = int(sys.argv[1])
    PID = int(sys.argv[2])
    server.run(host="0.0.0.0", port=port)