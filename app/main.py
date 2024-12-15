from flask import Flask, render_template
from asgiref.wsgi import WsgiToAsgi

app = Flask(__name__)


@app.route("/")
def index():
    return render_template("index.html")

asgi_app = WsgiToAsgi(app) 

if __name__ == "__main__":
    app.run()  # Это только для локального запуска, не используется в Docker
