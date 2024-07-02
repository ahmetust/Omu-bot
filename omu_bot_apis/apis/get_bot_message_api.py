""" from flask import Blueprint, request, jsonify
from son import soru_getir  # son modülünden soru_getir fonksiyonunu import ediyoruz

get_bot_message_api = Blueprint('get_bot_message_api', __name__)

@get_bot_message_api.route('/cevap-al', methods=['POST'])
def getmessage():
    data = request.json
    soru = data.get('soru')
    if not soru:
        return jsonify({'error': 'Soru gerekli'}), 400

    try:
        cevap = soru_getir(soru)  # soru_getir fonksiyonunu çağırıyoruz
        return jsonify({'cevap': cevap})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
 """