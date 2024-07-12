from flask import Blueprint, request, jsonify
from mysql.connector import Error
from db import get_db_connection

add_delete_questions_api = Blueprint('add_delete_questions_api', __name__)

@add_delete_questions_api.route('/add-question', methods=['POST'])
def add_question():
    data = request.get_json()
    user_id = data['user_id']
    question = data['question']
    answer = data['answer']
    category_id = data['category_id']
    
    db = get_db_connection()

    if db is None:
        return jsonify({"message": "Database connection failed"}), 500

    try:
        cursor = db.cursor()
        
        # Add question to user_message table
        query = "INSERT INTO user_message (user_id, question) VALUES (%s, %s)"
        cursor.execute(query, (user_id, question))
        message_id = cursor.lastrowid
        
        # Add answer to bot_message table
        query = "INSERT INTO bot_message (message_id, answer, category_id) VALUES (%s, %s, %s)"
        cursor.execute(query, (message_id, answer, category_id))
        
        db.commit()
        cursor.close()
        
        return jsonify({"message": "Question added successfully"}), 201
    except Error as e:
        return jsonify({"message": "Failed to add question", "error": str(e)}), 500
    finally:
        db.close()

@add_delete_questions_api.route('/delete-question/<int:message_id>', methods=['DELETE'])
def delete_question(message_id):
    db = get_db_connection()

    if db is None:
        return jsonify({"message": "Database connection failed"}), 500

    try:
        cursor = db.cursor()
        
        # Delete question from bot_message table
        query = "DELETE FROM bot_message WHERE message_id = %s"
        cursor.execute(query, (message_id,))
        
        # Delete question from user_message table
        query = "DELETE FROM user_message WHERE message_id = %s"
        cursor.execute(query, (message_id,))
        
        db.commit()
        cursor.close()
        
        return jsonify({"message": "Question deleted successfully"}), 200
    except Error as e:
        return jsonify({"message": "Failed to delete question", "error": str(e)}), 500
    finally:
        db.close()
