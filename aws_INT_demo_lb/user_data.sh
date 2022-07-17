#!/bin/bash
set -ex
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

pip3 install flask


echo '
import os
from flask import Flask, send_file, request

app = Flask(__name__)

hostname = os.environ.get('HOSTNAME', None)


# Try by:  curl localhost:8080
@app.route('/', methods=['GET'])
def index():
    return 'Hello world\n'


# Try by: curl -X POST -H "Content-Type: application/json" -d '{"name": "linuxize", "email": "linuxize@example.com"}' http://localhost:8080/update-profile
@app.route('/update-profile', methods=['POST'])
def update_profile():
    data = request.json
    print(f'Doing something with the data...\n{data}')
    return 'Done!\n'


# Try by: curl localhost:8080/get-profile-picture
@app.route('/get-profile-picture')
def profile_picture():
    return send_file('images/profile-1.jpg', mimetype='image/gif')


@app.route('/status')
def status():
    return 'OK'


@app.route('/load-test')
def load_test_endpoint():
    x = 6
    for i in range(100000):
        x = x ** i

    return f'Done {hostname}'


if __name__ == '__main__':
    app.run(debug=True, port=8080, host='0.0.0.0')' > app.py
