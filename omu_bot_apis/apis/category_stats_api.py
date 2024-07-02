from flask import Blueprint, jsonify
from db import get_db_connection

# Blueprint oluşturulması
category_stats_api = Blueprint('category_stats_api', __name__)

@category_stats_api.route('/category-stats', methods=['GET'])
def category_stats():
    db = get_db_connection()
    if db is None:
        return jsonify({"message": "Database connection failed"}), 500

    try:
        cursor = db.cursor(dictionary=True)

        # Kategorilere göre soru sayılarını sorgula
        query = '''
            SELECT c.category_id,c.category_name, COUNT(um.message_id) as question_count
            FROM categories c
            LEFT JOIN bot_message bm ON c.category_id = bm.category_id
            LEFT JOIN user_message um ON bm.message_id = um.message_id
            GROUP BY c.category_id
        '''
        cursor.execute(query)
        results = cursor.fetchall()

        # Sonuçları JSON formatında frontend'e gönder
        return jsonify(results), 200
    
    except Exception as e:
        return jsonify({"message": "Failed to fetch category stats", "error": str(e)}), 500
    
    finally:
        cursor.close()
        db.close()
