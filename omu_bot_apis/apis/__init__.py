
# Blueprintlerin import edilmesi
from .register_api import register_api
from .login_api import login_api
from .list_messages_api import list_messages_api
from .add_delete_questions_api import add_delete_questions_api
from .get_bot_message_api import get_bot_message_api

# Blueprint listesini oluşturma
def init_app(app):
    app.register_blueprint(register_api)
    app.register_blueprint(login_api)
    app.register_blueprint(list_messages_api)
    app.register_blueprint(add_delete_questions_api)
    app.register_blueprint(get_bot_message_api)
    
