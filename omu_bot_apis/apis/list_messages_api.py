from flask import Blueprint, jsonify
from mysql.connector import Error
from db import get_db_connection

list_messages_api = Blueprint('list_messages_api', __name__)

@list_messages_api.route('/list-messages', methods=['GET'])
def list_messages():
    db = get_db_connection()
    
    if db is None:
        return jsonify({'message': 'Database connection failed'}), 500

    try:
        cursor = db.cursor(dictionary=True)
        
        # user_message ve bot_message tablolarından gerekli bilgileri almak için sorgu
        query = '''
            SELECT 
                um.message_id,
                um.user_id, 
                um.question, 
                bm.answer, 
                c.category_name
            FROM 
                user_message um
            LEFT JOIN 
                bot_message bm ON um.message_id = bm.message_id
            LEFT JOIN 
                categories c ON bm.category_id = c.category_id
        '''
        cursor.execute(query)
        results = cursor.fetchall()
        
        return jsonify(results), 200
    
    except Error as e:
        return jsonify({'message': 'Failed to fetch messages', 'error': str(e)}), 500
    
    finally:
        cursor.close()
        db.close()
