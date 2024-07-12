import requests
from bs4 import BeautifulSoup

def get_and_format_daily_meals():
    url = "https://sks.omu.edu.tr/gunun-yemegi/"
    
    # Web sitesinden veri al
    response = requests.get(url)

    # HTML yapısını analiz et
    soup = BeautifulSoup(response.text, "html.parser")

    # <tbody> etiketini seç
    tbody_tag = soup.find("tbody")

    # Yemek içeriklerini depolamak için bir liste oluştur
    meals = []

    # <tbody> etiketinin altındaki <td> etiketlerini bul
    if tbody_tag:
        cells = tbody_tag.find_all("td")
        for cell in cells:
            cell_content = cell.get_text(strip=True)  # Hücre içeriğini al
            # "çorba" ve "yemek" içeren hücreleri listeye ekleme
            if "çorba" not in cell_content.lower() and "yemek" not in cell_content.lower():
                meals.append(cell_content)
    else:
        return "<tbody> etiketi bulunamadı."

    if len(meals) <= 4:  # İlk 2 ve son 2 etiketi çıkardıktan sonra en az 1 öğün kalmalı
        return "Yemek menüsü bulunamadı."
    
    # İlk iki ve son iki etiketi kaldır
    meals = meals[2:-2]
    
    # "Bugün" diye başlayarak cümleyi oluştur
    if meals:
        formatted_meals = "Bugün yemekte " + ", ".join(meals[:-1]) + " ve " + meals[-1] + " var."
    else:
        formatted_meals = "Yemek menüsü bulunamadı."

    return formatted_meals

# Yemek listesini çek ve formatlayıp yazdır
print(get_and_format_daily_meals())

