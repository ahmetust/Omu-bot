**[EN]** **Hello, this is OMU-BOT** 

OMU-BOT is a question answering made created for Ondokuz Mayıs Üniversity. It is aimed to develop a chatbot that can answer the questions of Ondokuz Mayıs University students. Questions about the university, which are necessary for training the chatbot, were collected from students with a survey. The collected questions were aimed to be tokenized using the pre-trained Turkish bert model together with their answers. For a better tokenization process, a new token dictionary was created with a dataset containing Turkish words and added to the existing dictionary so that the model can better understand Turkish expressions. BERT for Sequence Classification is an effective and powerful BERT model used in text classification tasks. The text given as input to this model is divided into pieces with the WordPiece tokenization method. Some special tokens are added to these texts. Each token is represented by a pre-trained vector. Positional information is added to indicate the positions of the tokens in the text. The input text is processed through BERT’s multilayer Transformer encoders. These layers include self-attention and feedforward neural networks.

The model was trained using the mechanisms described above and the outputs were obtained. The model was trained with approximately 1000 questions for 3 epochs. As a result of 3 epochs, 0.98 model accuracy was obtained. Then, the model was tested with the data in the test set. The predicted and real answers of the model are given below.

![Test](https://github.com/ahmetust/Omu-bot/blob/main/Screenshot1.png)


Since the model answers the question entered by the user by matching it with the closest question in the dataset, a similarity rate is created between the question received from the user and all the data. As a result, the model gives the answer to the question with the highest similarity rate as output to the user. However, if the question entered by the user is not similar to any of the questions in the dataset (if the similarity rate of all questions is less than 30%), the model produces an answer such as I cannot answer this question at the moment and saves the question to be answered later.

![Unanswered questions](https://github.com/ahmetust/Omu-bot/blob/main/Screenshot4.png)

API services were used in the project so that the developed chat bot could respond more accurately to current information. Examples of these services include API services such as dollar exchange rate, weather forecast, and the university's current cafeteria menu.

In addition, the Model can work both via web application and mobile devices, and in addition to these, it can also communicate with users via Telegram. In this way, users can access the model more easily.

![Telegram chat](https://github.com/ahmetust/Omu-bot/blob/main/Screenshot2.png)


The web and mobile application interfaces of the model are made via Flutter and the question-answer screen is as follows.

![Interface](https://github.com/ahmetust/Omu-bot/blob/main/Screenshot5.png)


Finally, a diagram that summarizes the Project in general is given below.

![Summary](https://github.com/ahmetust/Omu-bot/blob/main/Screenshot3.JPG)

**[TR]**
**Merhaba, ben OMU-BOT** 

OMU-BOT, Ondokuz Mayıs Üniversitesi için oluşturulan bir soru cevaplama chatbotudur. Ondokuz Mayıs Üniversitesi öğrencilerinin sorularına cevap verebilecek bir chatbot geliştirilmesi amaçlanmıştır. Chatbotu eğitmek için gerekli olan üniversiteyle ilgili sorular, öğrencilerden bir anketle toplanmıştır. Toplanan soruların cevaplarıyla birlikte önceden eğitilmiş Türkçe bert modeli kullanılarak belirteçleştirilmesi amaçlanmıştır. Daha iyi bir belirteçleme süreci için, Türkçe kelimeler içeren bir veri kümesiyle yeni bir belirteç sözlüğü oluşturulmuş ve modelin Türkçe ifadeleri daha iyi anlayabilmesi için mevcut sözlüğe eklenmiştir. Dizi Sınıflandırması için BERT, metin sınıflandırma görevlerinde kullanılan etkili ve güçlü bir BERT modelidir. Bu modele girdi olarak verilen metin, WordPiece belirteçleme yöntemi ile parçalara ayrılır. Bu metinlere bazı özel belirteçler eklenir. Her belirteç, önceden eğitilmiş bir vektörle temsil edilir. Belirteçlerin metindeki konumlarını belirtmek için konumsal bilgi eklenir. Giriş metni, BERT'in çok katmanlı Transformer kodlayıcıları aracılığıyla işlenir. Bu katmanlar, öz-dikkat ve ileri beslemeli sinir ağlarını içerir.

Yukarıda anlatılan mekanizmalar kullanılarak model eğitimi yapılmış ve çıktılar elde edilmiştir. Model yaklaşık 1000 soru ile 3 epoch boyunca eğitilmiştir. 3 epoch sonucunda 0.98 model doğruluğu elde edilmiştir. Ardından model test kümesinde bulunan veriler ile test edilmiştir. Modelin tahmin ettiği ve gerçek cevaplar aşağıda verilmiştir.
![Test](https://github.com/ahmetust/Omu-bot/blob/main/Screenshot1.png)

Model kullanıcıların girdiği soruyu veri setindeki en yakın soru ile eşleştirip cevap verdiği için kullanıcıdan alınan soru ile tüm veriler arasında bir benzerlik oranı oluşturulur. Sonuç olarak en fazla benzerlik oranının olduğu sorunun cevabını model kullanıcıya çıktı olarak verir. Fakat kullanıcının girdiği soru veri setindeki soruların hiçbirine benzemiyorsa (tüm soruların benzerlik oranı %30 dan az ise) model şu anda bu soruya cevap veremiyorum gibi bir yanıt üretir ve soruyu daha sonra cevaplanmak üzere kayıt eder.

![Cevaplanamayan Sorular](https://github.com/ahmetust/Omu-bot/blob/main/Screenshot4.png)

Geliştirilmiş olan sohbet botunun güncel bilgilere daha doğru cevap verebilmesi için projede API servislerinden yararlanılmıştır. Bu servislere dolar kuru, hava durumu ve üniversitenin güncel yemekhane menüsü gibi API servisleri örnek olarak verilebilir.


Ayrıca Model hem web uygulaması üzerinden hem de mobil cihazlar üzerinden çalışabildiği gibi bunlara ek olarak telegram üzerinden de kullanıcılar ile iletişime geçebilmektedir. Bu sayede kullanıcıların modele daha kolay ulaşması sağlanmıştır.

![Telegram sohbeti](https://github.com/ahmetust/Omu-bot/blob/main/Screenshot2.png)


Modelin web ve mobil uygulama arayüzleri flutter üzerinden yapılmış olup soru-cevap ekranı aşağıdaki gibidir.

![Arayüz](https://github.com/ahmetust/Omu-bot/blob/main/Screenshot5.png)


Son olarak Projeyi genel olarak özetleyen bir şema aşağıda verilmiştir.


![Genel Şema](https://github.com/ahmetust/Omu-bot/blob/main/Screenshot3.JPG)
