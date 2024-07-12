from numpy.random import shuffle
from sklearn.model_selection import train_test_split
import json
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from transformers import BertTokenizer, BertForSequenceClassification
import torch
from hava_durumu_api import get_weather
from dolar_api import get_exchange_rate
from haber_api import get_samsun_news
from yemek_api import get_and_format_daily_meals
import re

def clean_text(text):
    # Küçük harfe dönüştürme
    text = text.lower()
    
    # Özel karakterleri ve sayıları kaldırma
   # text = re.sub(r'[^a-zğüşıöç\s]', '', text)
    
    # Gereksiz boşlukları kaldırma
    text = ' '.join(text.split())
    
    # Noktalama işaretlerini kaldırma
    text = re.sub(r'[^\w\s]', '', text)
    
    return text

def process_json(filename):
    with open(filename, 'r', encoding='utf-8') as file:
        data = json.load(file)

        sorular = []
        cevaplar = []

        for item in data:
            soru = item['Sorular']
            cevap = item['Cevaplar']

            if isinstance(soru, list):
                for s in soru:
                    sorular.append(s)
                    cevaplar.append(cevap)
            else:
                sorular.append(soru)
                cevaplar.append(cevap)

        return sorular, cevaplar
    
def soru_cevap_eslestir(alinan_soru): 
    soru = clean_text(alinan_soru)
   
    
    if "bugün hava nasıl" in soru or "hava durumu" in soru or "hava kaç derece" in soru:
        return get_weather()
        
    if "dolar kuru" in soru or "dolar ne kadar" in soru or "dolar kaç tl" in soru:
        return get_exchange_rate()
        
    if "samsun haber" in soru or "samsun ile ilgili haber" in soru or "samsun haberler" in soru:
        return get_samsun_news()
        
    if "bugün yemekte ne var" in soru or "yemekte ne var" in soru or "günün yemeği" in soru or "günün yemeği ne" in soru:
        return get_and_format_daily_meals()    

    tokenized_input = tokenizer.encode_plus(
        soru,
        max_length=128,
        truncation=True,
        padding="max_length",
        return_tensors="pt"
    )

    input_ids = tokenized_input["input_ids"].to(device)
    attention_mask = tokenized_input["attention_mask"].to(device)

    with torch.no_grad():
        outputs = model(input_ids, attention_mask=attention_mask)

    logits = outputs.logits

    sorular = X_train + X_test
    cevaplar = y_train + y_test

    # TfidfVectorizer kullanarak soruları vektörize edin
    vectorizer = TfidfVectorizer()
    sorular_vt = vectorizer.fit_transform(sorular)

    # Kullanıcının sorduğu soruyu vektörize edin
    soru_vt = vectorizer.transform([soru])

    # Kosinüs benzerliğini hesaplayın
    benzerlikler = cosine_similarity(soru_vt, sorular_vt)

    # En yüksek benzerlik skorunu bulun
    en_yakin_soru_indexi = benzerlikler.argsort(axis=1)[:, -1]
    en_yuksek_benzerlik_skuru = benzerlikler[0, en_yakin_soru_indexi[0]]

        # Eğer benzerlik oranı %50'den düşükse, özel bir mesaj döndürün
    if en_yuksek_benzerlik_skuru < 0.3:
        return "Şu anda bu soruya cevap veremiyorum."

    # En yakın sorunun cevabını alın
    en_yakin_cevap = cevaplar[en_yakin_soru_indexi[0]]

    # Kullanıcıya en yakın sorunun cevabını gösterin
    return en_yakin_cevap



temizlenmis_sorular, temizlenmis_cevaplar = process_json('start.json')

combined = list(zip(temizlenmis_sorular, temizlenmis_cevaplar))
shuffle(combined)
temizlenmis_sorular, temizlenmis_cevaplar = zip(*combined)

X_train, X_test, y_train, y_test = train_test_split(temizlenmis_sorular, temizlenmis_cevaplar, test_size=0.3, random_state=42)

model_name = "dbmdz/bert-base-turkish-cased"
tokenizer = BertTokenizer.from_pretrained(model_name)
model = BertForSequenceClassification.from_pretrained(model_name, num_labels=2)
model.load_state_dict(torch.load('model.pth'))
model.eval()

if torch.cuda.is_available():
    device = torch.device('cuda')
else:
    device = torch.device('cpu')

while True:
    soru = input("Sorunuzu yazın (Çıkmak için 'q' tuşuna basın): ")
    
    if soru.lower() == 'q':
        print("Program sonlandırılıyor...")
        break
    
    cevap = soru_cevap_eslestir(soru)
    print("Cevap:", cevap)
