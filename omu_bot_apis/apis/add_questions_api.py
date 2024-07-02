from flask import Blueprint, request, jsonify
from mysql.connector import Error
from db import get_db_connection

add_questions_api = Blueprint('add_questions_api', __name__)

@add_questions_api.route('/add-question', methods=['POST'])
def add_question():
    data = request.get_json()
    user_id = data.get('user_id')
    question = data.get('question')
    answer = data.get('answer')
    category_id = data.get('category_id')

    if not all([user_id, question, answer, category_id]):
        return jsonify({'message': 'All fields are required'}), 400

    db = get_db_connection()

    if db is None:
        return jsonify({'message': 'Database connection failed'}), 500

    try:
        cursor = db.cursor()

        # user_message tablosuna soru ekle
        insert_question_query = '''
            INSERT INTO user_message (user_id, question)
            VALUES (%s, %s)
        '''
        cursor.execute(insert_question_query, (user_id, question))
        message_id = cursor.lastrowid

        # bot_message tablosuna cevap ekle
        insert_answer_query = '''
            INSERT INTO bot_message (message_id, answer, category_id)
            VALUES (%s, %s, %s)
        '''
        cursor.execute(insert_answer_query, (message_id, answer, category_id))

        db.commit()

        return jsonify({'message': 'Question added successfully'}), 201
    
    except Error as e:
        db.rollback()
        return jsonify({'message': 'Failed to add question', 'error': str(e)}), 500
    
    finally:
        cursor.close()
        db.close()
