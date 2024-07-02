from flask import Blueprint, request, jsonify
from mysql.connector import Error
from db import get_db_connection

edit_messages_api = Blueprint('edit_messages_api', __name__)

@edit_messages_api.route('/edit-message', methods=['POST'])
def edit_message():
    data = request.get_json()
    message_id = data.get('message_id')
    question = data.get('question')
    answer = data.get('answer')
    category_id = data.get('category_id')

    if not all([message_id, question, answer, category_id]):
        return jsonify({'message': 'All fields are required'}), 400

    db = get_db_connection()
    
    if db is None:
        return jsonify({'message': 'Database connection failed'}), 500

    try:
        cursor = db.cursor()

        # user_message tablosundaki soruyu güncelle
        update_question_query = '''
            UPDATE user_message
            SET question = %s
            WHERE message_id = %s
        '''
        cursor.execute(update_question_query, (question, message_id))

        # bot_message tablosundaki cevabı ve kategoriyi güncelle
        update_answer_query = '''
            UPDATE bot_message
            SET answer = %s, category_id = %s
            WHERE message_id = %s
        '''
        cursor.execute(update_answer_query, (answer, category_id, message_id))

        db.commit()

        return jsonify({'message': 'Message updated successfully'}), 200
    
    except Error as e:
        db.rollback()
        return jsonify({'message': 'Failed to update message', 'error': str(e)}), 500
    
    finally:
        cursor.close()
        db.close()

