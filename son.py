from numpy.random import shuffle
from sklearn.model_selection import train_test_split
from pickle import dump
import json
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from transformers import BertTokenizer, BertForSequenceClassification, AdamW
from torch.utils.data import Dataset, DataLoader
from gtts import gTTS
import os
import torch
from hava_api2 import get_weather
from dolar import get_exchange_rate
from haber import get_samsun_news
from yemek import get_and_format_daily_meals
import re
from spellchecker import SpellChecker

os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'

def clean_text(text):
    text = text.lower()
    text = re.sub(r'[^a-zğüşıöç\s]', '', text)
    text = ' '.join(text.split())
    text = re.sub(r'[^\w\s]', '', text)
    return text
    


def process_json(filename):
    with open(filename, 'r', encoding='utf-8') as file:
        data = json.load(file)

        sorular = []
        cevaplar = []

        for item in data:
            if not isinstance(item['Sorular'], list):
                item['Sorular'] = [item['Sorular']]
            if not isinstance(item['Cevaplar'], list):
                item['Cevaplar'] = [item['Cevaplar']]

            for soru in item['Sorular']:
                sorular.append(soru)
                cevaplar.append(item['Cevaplar'][0])

        return sorular, cevaplar

def save_clean_data(data, filename):
    with open(filename, 'w', encoding='utf-8') as file:
        json.dump(data, file, ensure_ascii=False, indent=4)  # indent=4 ile güzelce formatlanmış JSON dosyası elde edilir
    print('Saved: %s' % filename)

spell = SpellChecker()

# JSON dosyasını işle
temizlenmis_sorular, temizlenmis_cevaplar = process_json('start.json')

# Verileri karıştır
combined = list(zip(temizlenmis_sorular, temizlenmis_cevaplar))
shuffle(combined)
temizlenmis_sorular, temizlenmis_cevaplar = zip(*combined)

X_train, X_test, y_train, y_test = train_test_split(temizlenmis_sorular, temizlenmis_cevaplar, test_size=0.3, random_state=42)
# Modelin ve tokenizer'ın yolunu ayarlayın
model_path = 'model.pth'
tokenizer_name = "dbmdz/bert-base-turkish-cased"


# Modeli ve tokenizer'ı yükleyin
model_name = "dbmdz/bert-base-turkish-cased"
model = BertForSequenceClassification.from_pretrained(model_name, num_labels=2)
model.load_state_dict(torch.load('model.pth'))
model.eval()
tokenizer = BertTokenizer.from_pretrained(tokenizer_name)

# device değişkenini tanımlayın (GPU veya CPU seçin)
if torch.cuda.is_available():
    device = torch.device('cuda')
else:
    device = torch.device('cpu')


def save_unanswered_question(question):
    unanswered_data = {
        "question": question,
        "answer": "Şu anda bu soruya cevap veremiyorum."
    }
    
    try:
        with open('unanswered_questions.json', 'r', encoding='utf-8') as file:
            data = json.load(file)
    except FileNotFoundError:
        data = []
    
    data.append(unanswered_data)
    
    with open('unanswered_questions.json', 'w', encoding='utf-8') as file:
        json.dump(data, file, ensure_ascii=False, indent=4)
    
    print('Unanswered question saved:', question)


    

def soru_getir(alinan_soru): 
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
    if en_yuksek_benzerlik_skuru < 0.4:
        save_unanswered_question(alinan_soru)
        return "Şu anda bu soruya cevap veremiyorum."


    # En yakın sorunun cevabını alın
    en_yakin_cevap = cevaplar[en_yakin_soru_indexi[0]]

    # Kullanıcıya en yakın sorunun cevabını gösterin
    return en_yakin_cevap




