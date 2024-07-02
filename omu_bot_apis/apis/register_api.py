from flask import Blueprint, request, jsonify
from mysql.connector import Error
from db import get_db_connection

register_api = Blueprint('register_api', __name__)

@register_api.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    email = data['email']
    password = data['password']

    db = get_db_connection()

    if db is None:
        return jsonify({'message': 'Database connection failed'}), 500

    try:
        cursor = db.cursor()
        query = "INSERT INTO users (email, password, role) VALUES (%s, %s, %s)"
        cursor.execute(query, (email, password, 'USER'))
        db.commit()
        cursor.close()
        return jsonify({"message": "User registered successfully"}), 201
    except Error as e:
        return jsonify({"message": "User registration failed", "error": str(e)}), 500
    finally:
        db.close()
