from flask import Flask
from flask_cors import CORS

def create_app():
    app = Flask(__name__)
    CORS(app)
    
    # Blueprintleri import et ve uygulamaya kaydet
    from apis import init_app
    init_app(app)

    return app

if __name__ == '__main__':
    app = create_app()
    app.run(port=3300, host='0.0.0.0')
