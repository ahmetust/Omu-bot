from flask import Blueprint, request, jsonify
from mysql.connector import Error
from db import get_db_connection

delete_questions_api = Blueprint('delete_questions_api', __name__)

@delete_questions_api.route('/delete-question/<int:message_id>', methods=['DELETE'])
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

@delete_questions_api.route('/get-category-id/<string:category_name>', methods=['GET'])
def get_category_id(category_name):
    db = get_db_connection()

    if db is None:
        return jsonify({"message": "Database connection failed"}), 500

    try:
        cursor = db.cursor()
        
        # Get category ID based on category name
        query = "SELECT category_id FROM categories WHERE category_name = %s"
        cursor.execute(query, (category_name,))
        category_id = cursor.fetchone()[0]  # Assuming category_name is unique

        cursor.close()
        return jsonify({"category_id": category_id}), 200

    except Error as e:
        return jsonify({"message": "Failed to fetch category ID", "error": str(e)}), 500
    finally:
        db.close()
