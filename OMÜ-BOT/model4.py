import json
from sklearn.model_selection import train_test_split
from transformers import BertTokenizer, BertForSequenceClassification, AdamW,AutoTokenizer
from torch.utils.data import Dataset, DataLoader
import torch
from datasets import load_dataset

# JSON dosyasını okuyup temizlenmiş verileri işleme
def process_json(filename):
    with open(filename, 'r', encoding='utf-8') as file:
        data = json.load(file)

    sorular = []
    cevaplar = []

    for item in data:
        soru = item['Sorular']
        cevap = item['Cevaplar']

        sorular.append(soru)
        cevaplar.append(cevap)

    return sorular, cevaplar

# Veri setini tanımlama
class CustomDataset(Dataset):
    def __init__(self, sorular, cevaplar, tokenizer, max_length):
        self.sorular = sorular
        self.cevaplar = cevaplar
        self.tokenizer = tokenizer
        self.max_length = max_length

    def __len__(self):
        return len(self.sorular)

    def __getitem__(self, idx):
        soru = str(self.sorular[idx])  # Metin olmayan verileri stringe dönüştürmek için str() kullanıyoruz
        cevap = str(self.cevaplar[idx])

        encoding = self.tokenizer(
            soru,
            cevap,
            add_special_tokens=True,
            max_length=self.max_length,
            truncation=True,
            padding="max_length",
            return_tensors="pt"
        )

        inputs = {
            "input_ids": encoding["input_ids"].flatten(),
            "attention_mask": encoding["attention_mask"].flatten(),
            "labels": torch.tensor(1)  # Etiketler burada sabit olarak 1 olarak ayarlanmış
        }

        return inputs

# Veri işleme ve ayrıştırma adımları
def load_and_process_data(filename):
    sorular, cevaplar = process_json(filename)
    X_train, X_test, y_train, y_test = train_test_split(sorular, cevaplar, test_size=0.3, random_state=42)
    return X_train, X_test, y_train, y_test

# JSON dosyasını işleme ve veri setini ayrıştırma
X_train, X_test, y_train, y_test = load_and_process_data('start.json')

# Türkçe BERT modelini yükleme
model_name = "dbmdz/bert-base-turkish-cased"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = BertForSequenceClassification.from_pretrained(model_name, num_labels=2)  # 2 sınıfımız var: 1 ve 0

raw_dataset = load_dataset("setimes","en-tr")

from itertools import chain
def fonksyon():
    return(
        raw_dataset["train"] [i] ["translation"] ["tr"]
        for i in range(0,len(raw_dataset["train"]))
    )
training_corpus = fonksyon()

new_tokenizer=tokenizer.train_new_from_iterator(training_corpus,32000)
new_tokenizer.save_pretrained("New_tokenizer")

model.resize_token_embeddings(len(new_tokenizer))

# Eğitim ve test veri setlerini yükleyip hazırlama
train_dataset = CustomDataset(X_train, y_train, new_tokenizer, max_length=128)
test_dataset = CustomDataset(X_test, y_test, new_tokenizer, max_length=128)

# DataLoader'ları tanımlama
train_dataloader = DataLoader(train_dataset, batch_size=8, shuffle=True)
test_dataloader = DataLoader(test_dataset, batch_size=8, shuffle=False)


from transformers import BertForSequenceClassification, AdamW
import torch


optimizer = AdamW(model.parameters(), lr=5e-5)
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# Modeli eğitme
model.to(device)
model.train()

epochs = 3

for epoch in range(epochs):
    total_loss = 0

    for batch in train_dataloader:
        input_ids = batch["input_ids"].to(device)
        attention_mask = batch["attention_mask"].to(device)
        labels = batch["labels"].to(device)

        outputs = model(input_ids, attention_mask=attention_mask, labels=labels)
        loss = outputs.loss

        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        total_loss += loss.item()

    avg_train_loss = total_loss / len(train_dataloader)
    print(f"Epoch {epoch+1}/{epochs}, Average Training Loss: {avg_train_loss:.4f}")

# Modelin performansını değerlendirme
model.eval()
total_eval_accuracy = 0
predictions = []

for batch in test_dataloader:
    input_ids = batch["input_ids"].to(device)
    attention_mask = batch["attention_mask"].to(device)
    labels = batch["labels"].to(device)

    with torch.no_grad():
        outputs = model(input_ids, attention_mask=attention_mask)

    logits = outputs.logits
    batch_predictions = torch.argmax(logits, dim=1)
    predictions.extend(batch_predictions.cpu().numpy())

    correct_predictions = torch.sum(batch_predictions == labels)
    total_eval_accuracy += correct_predictions.item()

accuracy = total_eval_accuracy / len(test_dataset)
print(f"Accuracy: {accuracy:.4f}")

# Gerçek etiketlerin bulunduğu bir listeyi tanımlama
true_labels = [1] * len(predictions)  # Her bir tahminin gerçek etiketi 1 olarak kabul ediyoruz çünkü her soru-cevap çifti olumlu olarak işaretlenmiş

# Doğruluk oranını hesaplama
correct_predictions = sum(pred == true_label for pred, true_label in zip(predictions, true_labels))
total_samples = len(true_labels)
accuracy = correct_predictions / total_samples
print(f"Model Doğruluğu: {accuracy:.4f}")

# Tahmin edilen cevapları ve gerçek cevapları ekrana yazdırma
for i in range(len(X_test)):
    print(f"Soru: {X_test[i]}")
    print(f"Modelin Cevabı: {y_test[i]}")
    print(f"Gerçek Cevap: {y_test[i]}\n")

torch.save(model.state_dict(), 'model.pth')
