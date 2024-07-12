from flask import Blueprint, request, jsonify
from mysql.connector import Error
from db import get_db_connection

login_api = Blueprint('login_api', __name__)

@login_api.route('/login', methods=['POST'])
def login():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    db = get_db_connection()

    if db is None:
        return jsonify({'message': 'Database connection failed'}), 500

    try:
        cursor = db.cursor()
        cursor.execute('SELECT user_id, role FROM users WHERE email = %s AND password = %s', (email, password))
        result = cursor.fetchone()

        if result:
            user_id, role = result
            return jsonify({'user_id': user_id, 'role': role}), 200
        else:
            return jsonify({'message': 'Invalid email or password'}), 401
    except Error as e:
        return jsonify({'message': 'Login failed', 'error': str(e)}), 500
    finally:
        cursor.close()
        db.close()
