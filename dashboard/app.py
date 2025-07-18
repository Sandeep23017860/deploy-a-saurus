from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "<h1>Deploy-a-Saurus Dashboard</h1><p>Analytics will be here soon!</p>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)