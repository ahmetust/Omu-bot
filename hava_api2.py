# weather.py
import requests

def get_weather():
    api_key = "a8743e08a49208fb5d220b1dd8a58cb7"
    city = "Samsun"
    api_url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=metric"

    response = requests.get(api_url)
    weather_data = response.json()
    
    city_name = weather_data['name']
    temperature = weather_data['main']['temp']
    weather_description = weather_data['weather'][0]['description']
    
    celsius_temperature = round(temperature)
    weather_description_tr = {
        'clear sky': 'güneşli',
        'few clouds': 'az bulutlu',
        'scattered clouds': 'parçalı bulutlu',
        'broken clouds': 'çok bulutlu',
        'shower rain': 'sağanak yağmurlu',
        'rain': 'yağmurlu',
        'thunderstorm': 'gök gürültülü fırtınalı',
        'snow': 'karlı',
        'mist': 'sisli',
        'overcast clouds': 'bulutlu'
    }.get(weather_description, weather_description)
    
    weather_sentence = f"{city_name}'da bugün hava {weather_description_tr} ve {celsius_temperature} derece."
    
    return weather_sentence

