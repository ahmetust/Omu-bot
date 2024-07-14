import requests

def get_samsun_news():
    api_key = "your_api_key"
    query = "Samsun"
    url = f"https://newsapi.org/v2/everything?q={query}&language=tr&apiKey={api_key}"
    
    response = requests.get(url)
    news_data = response.json()
    
    if news_data["status"] == "ok":
        articles = news_data["articles"]
        headlines = []
        for article in articles[:5]:  # En fazla 5 haber başlığı döndürelim
            title = article["title"]
            url = article["url"]
            headlines.append(f"{title} - {url}")
        
        if headlines:
            return "\n".join(headlines)
        else:
            return "Samsun ile ilgili haber bulunamadı."
    else:
        return "Haberler alınamadı."

# Örnek kullanım
if __name__ == "__main__":
    news = get_samsun_news()
    print(news)
