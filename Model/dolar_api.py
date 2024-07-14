# exchange_rate.py
import requests

def get_exchange_rate():
    api_key = "your_api_key"
    base_currency = "USD"
    target_currency = "TRY"
    api_url = f"https://v6.exchangerate-api.com/v6/{api_key}/latest/{base_currency}"

    response = requests.get(api_url)
    exchange_data = response.json()
    
    if response.status_code == 200:
        exchange_rate = exchange_data["conversion_rates"][target_currency]
        exchange_sentence = f"1 Amerikan Doları şu anda {exchange_rate} Türk Lirası değerindedir."
        return exchange_sentence
    else:
        return "Döviz kuru bilgisi alınamadı."
