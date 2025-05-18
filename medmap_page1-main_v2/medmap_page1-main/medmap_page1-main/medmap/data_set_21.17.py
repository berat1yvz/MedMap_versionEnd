import openai
from dotenv import load_dotenv
import os
import json
import googlemaps
from datetime import datetime
import math
from flask import Flask, request, jsonify

# .env dosyasından API anahtarlarını yükle
load_dotenv()

# OpenAI API anahtarını ayarla
openai.api_key = os.getenv('OPENAI_API_KEY')

# Google Maps API anahtarını ayarla
gmaps = googlemaps.Client(key=os.getenv('GOOGLE_MAPS_API_KEY'))

app = Flask(__name__)

@app.route('/plan', methods=['POST'])
def plan():
    data = request.json
    complaint = data.get('complaint')
    location = data.get('location')
    date_range = data.get('date_range')

    # Tedavi alanı bul
    treatment_area = get_treatment_area(complaint)
    # Doktorları bul
    doctors_text, all_doctors = find_matching_doctors(treatment_area)
    # (İsterseniz burada doktor seçimini de API üzerinden yapabilirsiniz)
    # İyileşme ve planlama örneği (ilk doktor ile)
    if all_doctors:
        selected_doctor = all_doctors[0]
        recovery_plan, planning, recovery_days, restaurants, attractions = get_recovery_and_planning(
            {"complaint": complaint, "location": location, "date_range": date_range},
            selected_doctor
        )
    else:
        selected_doctor = None
        recovery_plan = planning = recovery_days = restaurants = attractions = None

    return jsonify({
        "treatment_area": treatment_area,
        "doctors": doctors_text,
        "selected_doctor": selected_doctor,
        "recovery_plan": recovery_plan,
        "planning": planning,
        "restaurants": restaurants,
        "attractions": attractions
    })

def get_treatment_area(user_input):
    """
    Kullanıcının girdiği şikayeti analiz edip uygun tedavi alanını belirler.
    """
    try:
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": """Sen bir sağlık uzmanısısın. Kullanıcının şikayetini analiz edip, 
                sadece aşağıdaki alanlardan birini seçmelisin:
                - Kardiyoloji
                - Nöroloji
                - Ortopedi
                - Göz Hastalıkları
                - Kulak Burun Boğaz
                - Dermatoloji
                - Gastroenteroloji
                - Üroloji
                - Kadın Hastalıkları ve Doğum
                - Çocuk Sağlığı ve Hastalıkları
                - Psikiyatri
                - Göğüs Hastalıkları
                - İç Hastalıkları
                - Genel Cerrahi
                - Beyin ve Sinir Cerrahisi
                - Plastik Cerrahi
                - Medikal Estetik
                - Ağız Diş ve Çene Cerrahisi
                - Beslenme ve Diyet
                
                Lütfen sadece bu alanlardan birini seç ve başka önerilerde bulunma."""},
                {"role": "user", "content": f"Şikayetim: {user_input}"}
            ]
        )
        return response.choices[0].message.content.strip()
    except Exception as e:
        print(f"GPT API hatası: {str(e)}")
        return None

def find_matching_doctors(treatment_area):
    """
    Belirlenen tedavi alanına uygun doktorları bulur.
    """
    try:
        # Doktor listelerini tanımla
        este_world_doctors = [
            {"id": 1, "unvan": "Dr.", "isim": "Sena Nur Yetkin", "alan": "Pratisyen Hekim", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 2, "unvan": "Dr.", "isim": "Burak Kılıç", "alan": "Pratisyen Hekim", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 3, "unvan": "Dr.", "isim": "Ömer Faruk Doğan", "alan": "Pratisyen Hekim", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 4, "unvan": "Dt.", "isim": "Duygu Mustafa Pamuk", "alan": "Diş Hekimi", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 5, "unvan": "Dt.", "isim": "Elçin Keskin Özyer", "alan": "Diş Hekimi", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 6, "unvan": "Dt.", "isim": "Yusuf Polat", "alan": "Diş Hekimi", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 7, "unvan": "Dt.", "isim": "Ramazan Alp", "alan": "Diş Hekimi", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 8, "unvan": "Dr.", "isim": "Medet Saf", "alan": "Diş Hekimi", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 9, "unvan": "Op. Dr.", "isim": "Cengiz Ertekin", "alan": "Plastik Cerrahi Uzmanı", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 10, "unvan": "Op. Dr.", "isim": "Mehmet Mesut İnan", "alan": "Plastik Rekonstrüktif ve Estetik Cerrahi Uzmanı", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 11, "unvan": "Uzm. Dr.", "isim": "Esra Bağcı", "alan": "Dermatoloji Uzmanı", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 12, "unvan": "Uzm. Dr.", "isim": "Hülya Süslü", "alan": "Dermatoloji Uzmanı", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 13, "unvan": "Uzm. Dr.", "isim": "Harika Ödemiş", "alan": "Dermatoloji Uzmanı", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 14, "unvan": "Uzm. Dr.", "isim": "Fatoş Ezer", "alan": "Anestezi ve Reanimasyon Uzmanı", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 15, "unvan": "Uzm. Dr.", "isim": "Cemal Bektaş", "alan": "Anesteziyoloji ve Reanimasyon Uzmanı", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 16, "unvan": "Uzm. Dr.", "isim": "Filiz Oral", "alan": "Anestezi ve Reanimasyon Uzmanı", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 17, "unvan": "Dr.", "isim": "Burak Tuncer", "alan": "Medikal Direktör", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 18, "unvan": "Prof. Dr.", "isim": "Ahmet Doğrul", "alan": "Medikal Estetik Uzmanı", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 19, "unvan": "Dr.", "isim": "Feyman Duygu Oktar", "alan": "Medikal Estetik Uzmanı", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 20, "unvan": "Op. Dr.", "isim": "Lütfi Tekeş", "alan": "Plastik Cerrahi Uzmanı", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 21, "unvan": "Op. Dr.", "isim": "Bükem Cüce", "alan": "Plastik Cerrahi Uzmanı", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 22, "unvan": "Op. Dr.", "isim": "Kıvanç Emre Davun", "alan": "Plastik Cerrahi Uzmanı", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 23, "unvan": "Op. Dr.", "isim": "Mert Canli", "alan": "Plastik Cerrahi Uzmanı", "hastane": "Este World", "konum": (41.006930, 28.872253)},
            {"id": 24, "unvan": "Op. Dr.", "isim": "Serdar Biz", "alan": "Medikal Estetik Uzmanı", "hastane": "Este World", "konum": (41.006930, 28.872253)}
        ]

        medipol_doctors = [
            {"id": 25, "unvan": "Prof. Dr.", "isim": "Aysun Şimşek", "alan": "Genel Cerrahi", "hastane": "Medipol Koşuyolu", "konum": (40.9776004, 28.8727806)},
            {"id": 26, "unvan": "Doç. Dr.", "isim": "Refik Bademci", "alan": "Genel Cerrahi", "hastane": "Medipol Koşuyolu", "konum": (40.9776004, 28.8727806)},
            {"id": 27, "unvan": "Op. Dr.", "isim": "Eyüp Sevim", "alan": "Genel Cerrahi", "hastane": "Medipol Koşuyolu", "konum": (40.9776004, 28.8727806)},
            {"id": 28, "unvan": "Op. Dr.", "isim": "İzzettin Kahraman", "alan": "Genel Cerrahi", "hastane": "Medipol Koşuyolu", "konum": (40.9776004, 28.8727806)},
            {"id": 29, "unvan": "Uzm. Dr.", "isim": "Sıraç Akgül", "alan": "Genel Cerrahi", "hastane": "Medipol Koşuyolu", "konum": (40.9776004, 28.8727806)},
            {"id": 30, "unvan": "Prof. Dr.", "isim": "Naci Karacaoğlan", "alan": "Plastik ve Rekonstrüktif Cerrahi", "hastane": "Medipol Koşuyolu", "konum": (40.9776004, 28.8727806)},
            {"id": 31, "unvan": "Doktor Öğretim Üyesi", "isim": "Ayşe Gül Baysak", "alan": "Göğüs Hastalıkları", "hastane": "Medipol Koşuyolu", "konum": (40.9776004, 28.8727806)},
            {"id": 32, "unvan": "Prof. Dr.", "isim": "Cemalettin Aydın", "alan": "Genel Cerrahi", "hastane": "Medipol Koşuyolu", "konum": (40.9776004, 28.8727806)},
            {"id": 33, "unvan": "Doç. Dr.", "isim": "Hüsnü Aydın", "alan": "Genel Cerrahi", "hastane": "Medipol Koşuyolu", "konum": (40.9776004, 28.8727806)},
            {"id": 34, "unvan": "Doç. Dr.", "isim": "Sina Ferahman", "alan": "Meme Kanseri ve Hastalıkları", "hastane": "Medipol Koşuyolu", "konum": (40.9776004, 28.8727806)},
            {"id": 35, "unvan": "Doç. Dr.", "isim": "Burak Özkan", "alan": "Plastik ve Rekonstrüktif Cerrahi", "hastane": "Medipol Koşuyolu", "konum": (40.9776004, 28.8727806)},
            {"id": 36, "unvan": "Doktor Öğretim Üyesi", "isim": "Burak Ergün Tatar", "alan": "Plastik ve Rekonstrüktif Cerrahi", "hastane": "Medipol Koşuyolu", "konum": (40.9776004, 28.8727806)},
            {"id": 37, "unvan": "Prof. Dr.", "isim": "Sina Uçkan", "alan": "Ağız Diş ve Çene Cerrahisi", "hastane": "Medipol Bahçelievler", "konum": (40.9988635, 28.8304814)},
            {"id": 38, "unvan": "Doç. Dr.", "isim": "Muazzez Süzen", "alan": "Ağız Diş ve Çene Cerrahisi", "hastane": "Medipol Bahçelievler", "konum": (40.9988635, 28.8304814)},
            {"id": 39, "unvan": "Doktor Öğretim Üyesi", "isim": "Abdullah Özel", "alan": "Ağız Diş ve Çene Cerrahisi", "hastane": "Medipol Bahçelievler", "konum": (40.9988635, 28.8304814)},
            {"id": 40, "unvan": "Doktor Öğretim Üyesi", "isim": "Bilal Cemşit Sarı", "alan": "Ağız Diş ve Çene Cerrahisi", "hastane": "Medipol Bahçelievler", "konum": (40.9988635, 28.8304814)},
            {"id": 41, "unvan": "Doktor Öğretim Üyesi", "isim": "Ceylan Güzel", "alan": "Ağız Diş ve Çene Cerrahisi", "hastane": "Medipol Bahçelievler", "konum": (40.9988635, 28.8304814)},
            {"id": 42, "unvan": "Doktor Öğretim Üyesi", "isim": "Gamze Şenol", "alan": "Ağız Diş ve Çene Cerrahisi", "hastane": "Medipol Bahçelievler", "konum": (40.9988635, 28.8304814)},
            {"id": 43, "unvan": "Doktor Öğretim Üyesi", "isim": "Mustafa Temiz", "alan": "Ağız Diş ve Çene Cerrahisi", "hastane": "Medipol Bahçelievler", "konum": (40.9988635, 28.8304814)},
            {"id": 44, "unvan": "Doktor Öğretim Üyesi", "isim": "Sümer Münnevveroğlu", "alan": "Diş Tedavi", "hastane": "Medipol Bahçelievler", "konum": (40.9988635, 28.8304814)},
            {"id": 45, "unvan": "Doktor Öğretim Üyesi", "isim": "Tuba Develi", "alan": "Ağız Diş ve Çene Cerrahisi", "hastane": "Medipol Bahçelievler", "konum": (40.9988635, 28.8304814)},
            {"id": 46, "unvan": "Diyetisyen", "isim": "Arif Kaçan", "alan": "Beslenme ve Diyet", "hastane": "Medipol Bahçelievler", "konum": (40.9988635, 28.8304814)},
            {"id": 47, "unvan": "Diyetisyen", "isim": "Asya Naz Al", "alan": "Beslenme ve Diyet", "hastane": "Medipol Bahçelievler", "konum": (40.9988635, 28.8304814)},
            {"id": 48, "unvan": "Diyetisyen", "isim": "Beyza Tağraf", "alan": "Beslenme ve Diyet", "hastane": "Medipol Vatan", "konum": (41.0150738, 28.9418707)},
            {"id": 49, "unvan": "Diyetisyen", "isim": "Burcu Uludağ", "alan": "Beslenme ve Diyet", "hastane": "Medipol Vatan", "konum": (41.0150738, 28.9418707)},
            {"id": 50, "unvan": "Diyetisyen", "isim": "Melisa Çise Gökkaya", "alan": "Beslenme ve Diyet", "hastane": "Medipol Vatan", "konum": (41.0150738, 28.9418707)},
            {"id": 51, "unvan": "Diyetisyen", "isim": "Songül Sabir", "alan": "Beslenme ve Diyet", "hastane": "Medipol Vatan", "konum": (41.0150738, 28.9418707)},
            {"id": 52, "unvan": "Diyetisyen", "isim": "Tuğba Tunç", "alan": "Beslenme ve Diyet", "hastane": "Medipol Vatan", "konum": (41.0150738, 28.9418707)},
            {"id": 53, "unvan": "Prof. Dr.", "isim": "Gonca Yetkin Yıldırım", "alan": "Kadın Hastalıkları ve Doğum", "hastane": "Medipol Vatan", "konum": (41.0150738, 28.9418707)},
            {"id": 54, "unvan": "Doç. Dr.", "isim": "Aysu Akça", "alan": "Kadın Hastalıkları ve Doğum", "hastane": "Medipol Vatan", "konum": (41.0150738, 28.9418707)},
            {"id": 55, "unvan": "Doç. Dr.", "isim": "Aysun Fırat", "alan": "Kadın Hastalıkları ve Doğum", "hastane": "Medipol Vatan", "konum": (41.0150738, 28.9418707)},
            {"id": 56, "unvan": "Doktor Öğretim Üyesi", "isim": "Nur Cansu Yılmaz", "alan": "Kadın Hastalıkları ve Doğum", "hastane": "Medipol Vatan", "konum": (41.0150738, 28.9418707)},
            {"id": 57, "unvan": "Uzm. Dr.", "isim": "İpek Uzaldı", "alan": "Kadın Hastalıkları ve Doğum", "hastane": "Medipol Vatan", "konum": (41.0150738, 28.9418707)},
            {"id": 58, "unvan": "Embriyolog", "isim": "Tuba Varlı Yelke", "alan": "Tüp Bebek Merkezi", "hastane": "Medipol Vatan", "konum": (41.0150738, 28.9418707)}
        ]

        acibadem_doktorlari = [
            {"id": 59, "unvan": "Profesör Doktor", "isim": "Hakan Ağır", "alan": "Plastik, Rekonstrüktif ve Estetik Cerrahi", "hastane": "Acıbadem Bakırköy", "konum": (40.9776166, 28.8728127)},
            {"id": 60, "unvan": "Profesör Doktor", "isim": "Şükrü Yazar", "alan": "Plastik, Rekonstrüktif ve Estetik Cerrahi", "hastane": "Acıbadem Bakırköy", "konum": (40.9776166, 28.8728127)},
            {"id": 61, "unvan": "Doktor", "isim": "Ayşe İrem İskenderoğlu", "alan": "Plastik, Rekonstrüktif ve Estetik Cerrahi", "hastane": "Acıbadem Bakırköy", "konum": (40.9776166, 28.8728127)},
            {"id": 62, "unvan": "Profesör Doktor", "isim": "Bülent Saçak", "alan": "Plastik, Rekonstrüktif ve Estetik Cerrahi", "hastane": "Acıbadem Bakırköy", "konum": (40.9776166, 28.8728127)},
            {"id": 63, "unvan": "Doktor Öğretim Üyesi", "isim": "Berkhan Yılmaz", "alan": "Plastik, Rekonstrüktif ve Estetik Cerrahi", "hastane": "Acıbadem Bakırköy", "konum": (40.9776166, 28.8728127)},
            {"id": 64, "unvan": "Doktor", "isim": "Abdullah Etöz", "alan": "Plastik, Rekonstrüktif ve Estetik Cerrahi", "hastane": "Acıbadem Bakırköy", "konum": (40.9776166, 28.8728127)},
            {"id": 65, "unvan": "Profesör Doktor", "isim": "CİHAN URAS", "alan": "Genel Cerrahi", "hastane": "Acıbadem Bakırköy", "konum": (40.9776166, 28.8728127)},
            {"id": 66, "unvan": "Doçent Doktor", "isim": "EYÜP GEMİCİ", "alan": "Genel Cerrahi", "hastane": "Acıbadem Altunizade", "konum": (41.0200077, 29.04548510)},
            {"id": 67, "unvan": "Doktor", "isim": "AHMET ALAN", "alan": "Genel Cerrahi", "hastane": "Acıbadem Altunizade", "konum": (41.0200077, 29.04548510)},
            {"id": 68, "unvan": "Profesör Doktor", "isim": "MELİH PAKSOY", "alan": "Genel Cerrahi", "hastane": "Acıbadem Altunizade", "konum": (41.0200077, 29.04548510)},
            {"id": 69, "unvan": "Profesör Doktor", "isim": "ŞÜKRÜ AKTAN", "alan": "Genel Cerrahi", "hastane": "Acıbadem Altunizade", "konum": (41.0200077, 29.04548510)},
            {"id": 70, "unvan": "Profesör Doktor", "isim": "YAMAN TOKAT", "alan": "Genel Cerrahi", "hastane": "Acıbadem Altunizade", "konum": (41.0200077, 29.04548510)},
            {"id": 71, "unvan": "Doçent Doktor", "isim": "ABDÜLHAK HAMİT KARAYAĞIZ", "alan": "Genel Cerrahi", "hastane": "Acıbadem Altunizade", "konum": (41.0200077, 29.04548510)},
            {"id": 72, "unvan": "Doçent Doktor", "isim": "DENİZ ATASOY", "alan": "Genel Cerrahi", "hastane": "Acıbadem Altunizade", "konum": (41.0200077, 29.04548510)}
        ]

        # Tüm doktor listelerini birleştir
        all_doctors = este_world_doctors + medipol_doctors + acibadem_doktorlari
        
        # GPT'ye doktor listesini ve tedavi alanını gönder
        response = openai.ChatCompletion.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": """Hastanın şikayeti ve seçilen doktorun uzmanlık alanına göre hastaya doktor önerisi yap.
                Her hastaneden sadece 1 doktor seç, toplam 4 doktor öner.
                Yanıtını şu formatta ver:
                ID: [doktor_id]
                İsim: [doktor_unvan] [doktor_isim]
                Hastane: [hastane_adi]
                Uzmanlık: [uzmanlik_alani]
                
                ID: [doktor_id]
                İsim: [doktor_unvan] [doktor_isim]
                Hastane: [hastane_adi]
                Uzmanlık: [uzmanlik_alani]
                
                ID: [doktor_id]
                İsim: [doktor_unvan] [doktor_isim]
                Hastane: [hastane_adi]
                Uzmanlık: [uzmanlik_alani]"""},
                {"role": "user", "content": f"Tedavi Alanı: {treatment_area}\n\nDoktor Listesi:\n{json.dumps(all_doctors, ensure_ascii=False, indent=2)}"}
            ],
            max_tokens=200
        )
        return response.choices[0].message.content.strip(), all_doctors
    except Exception as e:
        print(f"Doktor bulma hatası: {str(e)}")
        return None, None

def select_doctor(doctors_list):
    """
    Kullanıcıdan doktor seçmesini ister ve seçilen doktorun bilgilerini döndürür.
    """
    while True:
        print("\nSeçenekler:")
        print("1-72: Doktor ID'si ile seç")
        print("q: Çıkış")
        
        choice = input("\nSeçiminiz: ").lower()
        
        if choice == 'q':
            return None
        else:
            try:
                choice_num = int(choice)
                # ID'ye göre doktoru bul
                selected_doctor = next((doc for doc in doctors_list if doc['id'] == choice_num), None)
                if selected_doctor:
                    print(f"\nSeçilen Doktor: {selected_doctor['unvan']} {selected_doctor['isim']}")
                    print(f"ID: {selected_doctor['id']}")
                    return selected_doctor
                else:
                    print("Geçersiz ID! Lütfen tekrar deneyin.")
            except ValueError:
                print("Geçersiz seçim! Lütfen tekrar deneyin.")

def find_nearby_hotels(doctor_location):
    """
    Doktorun konumuna yakın otelleri bulur ve puanlarına göre sıralar.
    """
    try:
        # Sabit arama yarıçapı (2 km)
        SEARCH_RADIUS = 2000
        
        # Doktorun konumuna yakın otelleri ara
        places_result = gmaps.places_nearby(
            location=doctor_location,
            radius=SEARCH_RADIUS,
            type='lodging'
        )

        hotels = []
        seen_hotels = set()  # Tekrarlanan otelleri engellemek için

        for place in places_result.get('results', []):
            # Her otel için detaylı bilgi al
            place_details = gmaps.place(place['place_id'], fields=['name', 'rating', 'user_ratings_total', 'url'])
            details = place_details['result']
            
            # Minimum yorum sayısı kontrolü
            total_ratings = details.get('user_ratings_total', 0)
            if total_ratings < 100:  # Minimum 100 yorum
                continue
                
            # Tekrarlanan otelleri engelle
            hotel_name = details['name'].lower().strip()
            if hotel_name in seen_hotels:
                continue
            seen_hotels.add(hotel_name)
            
            # Puanlama algoritması
            rating = details.get('rating', 0)
            max_ratings = 5000  # Örnek maksimum yorum sayısı
            
            # Normalize edilmiş yorum oranı
            rating_ratio = min(total_ratings / max_ratings, 1.0)
            
            # Toplam puan hesaplama
            total_score = (rating * 0.7) + (rating_ratio * 0.3)
            
            hotels.append({
                'name': details['name'],
                'rating': rating,
                'total_ratings': total_ratings,
                'maps_url': details['url'],
                'score': total_score
            })
        
        # Puanlara göre sırala ve en iyi 3'ü döndür
        return sorted(hotels, key=lambda x: x['score'], reverse=True)[:3]
    
    except Exception as e:
        print(f"Otel arama hatası: {str(e)}")
        return None

def get_treatment_details():
    """
    Kullanıcıdan tedavi detaylarını alır.
    """
    print("\nLütfen şikayet ve tedavi detaylarınızı belirtin:")
    print("1. Şikayetiniz nedir , nasıl bir işlem talep ediyorsunuz?")
    complaint = input("> ")
    
    print("\n2. Tercih ettiğiniz şehir nedir? (Varsayılan: İstanbul)")
    location = input("> ").strip() or "İstanbul"
    
    print("\n3. Tercih ettiğiniz tarih aralığı nedir? (Örnek: 1 Temmuz - 15 Temmuz)")
    date_range = input("> ").strip()
    
    return {
        "complaint": complaint,
        "location": location,
        "date_range": date_range
    }

def find_nearby_places(doctor_location, place_type):
    """
    Doktorun konumuna yakın yerleri bulur (restoran, turistik yer vb.)
    """
    try:
        SEARCH_RADIUS = 2000
        
        places_result = gmaps.places_nearby(
            location=doctor_location,
            radius=SEARCH_RADIUS,
            type=place_type
        )

        places = []
        seen_places = set()  # Tekrarlanan yerleri engellemek için
        seen_names = set()   # Benzer isimleri engellemek için

        for place in places_result.get('results', []):
            try:
                place_details = gmaps.place(place['place_id'], fields=['name', 'rating', 'user_ratings_total', 'url', 'geometry'])
                details = place_details['result']
                
                # Minimum yorum sayısı kontrolü
                total_ratings = details.get('user_ratings_total', 0)
                if total_ratings < 50:  # Restoranlar için daha düşük yorum sayısı
                    continue
                    
                # İsim normalizasyonu
                normalized_name = details['name'].lower().strip()
                # Benzer isimleri kontrol et
                if any(normalized_name in seen_name or seen_name in normalized_name for seen_name in seen_names):
                    continue
                    
                seen_names.add(normalized_name)
                
                # Mesafe hesaplama
                distance = calculate_distance(doctor_location, details['geometry']['location'])
                
                # Puanlama algoritması
                rating = details.get('rating', 0)
                max_ratings = 5000  # Örnek maksimum yorum sayısı
                rating_ratio = min(total_ratings / max_ratings, 1.0)
                distance_score = 1 - (distance / SEARCH_RADIUS)  # Mesafeye göre puan
                
                # Toplam puan hesaplama
                total_score = (rating * 0.4) + (rating_ratio * 0.3) + (distance_score * 0.3)
                
                places.append({
                    'name': details['name'],
                    'rating': rating,
                    'total_ratings': total_ratings,
                    'maps_url': details['url'],
                    'distance': distance,
                    'score': total_score
                })
            except Exception as e:
                continue  # Hatalı yerleri atla
        
        # Puanlara göre sırala ve en iyi 3'ü döndür
        return sorted(places, key=lambda x: x['score'], reverse=True)[:3]
    
    except Exception as e:
        print("Üzgünüm, yakın yerler aranırken bir sorun oluştu. Lütfen daha sonra tekrar deneyin.")
        return None

def calculate_distance(point1, point2):
    """
    İki nokta arasındaki mesafeyi hesaplar (metre cinsinden)
    """
    from math import radians, sin, cos, sqrt, atan2
    
    R = 6371000  # Dünya'nın yarıçapı (metre)
    
    lat1, lon1 = radians(point1[0]), radians(point1[1])
    lat2, lon2 = radians(point2['lat']), radians(point2['lng'])
    
    dlat = lat2 - lat1
    dlon = lon2 - lon1
    
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * atan2(sqrt(a), sqrt(1-a))
    
    return R * c

def get_recovery_and_planning(treatment_details, selected_doctor):
    """
    İyileşme sürecini ve planlamayı yapar.
    """
    try:
        # İyileşme sürecini al (daha kısa prompt)
        recovery_response = openai.ChatCompletion.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": """Hastanın şikayeti ve seçilen doktorun uzmanlık alanına göre hastaya doktor önerisi yap.
                Yanıtını şu formatta ver:
                1. Tahmini İyileşme Süresi: (gün)
                2. Aktivite Kısıtlamaları:
                   - 1-4 gün: (kısıtlamalar)
                   - 4-7 gün: (kısıtlamalar)
                   - 7-15 gün: (kısıtlamalar)"""},
                {"role": "user", "content": f"""Şikayet: {treatment_details['complaint']}
                Doktor: {selected_doctor['unvan']} {selected_doctor['isim']}
                Uzmanlık Alanı: {selected_doctor['alan']}"""}
            ],
            max_tokens=200
        )
        recovery_plan = recovery_response.choices[0].message.content.strip()
        
        # İyileşme süresini çıkar
        recovery_days = 15  # Varsayılan değer
        if "Tahmini İyileşme Süresi:" in recovery_plan:
            try:
                days_text = recovery_plan.split("Tahmini İyileşme Süresi:")[1].split("\n")[0].strip()
                recovery_days = int(''.join(filter(str.isdigit, days_text)))
            except:
                pass
        
        # Yakın yerleri bul
        restaurants = find_nearby_places(selected_doctor['konum'], 'restaurant')
        attractions = find_nearby_places(selected_doctor['konum'], 'tourist_attraction')
        
        # Tarih ve aktivite planlaması (daha kısa prompt)
        planning_response = openai.ChatCompletion.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": f"""Seyahat planı oluştur. Yanıtını şu formatta ver:
                1. Önerilen Tarih Aralığı: (başlangıç - bitiş)
                2. Günlük Aktivite Planı:
                   - İlk 4 gün: (yakın yerler)
                   - 4-7 gün: (orta mesafe)
                   - 7-15 gün: (uzak yerler)"""},
                {"role": "user", "content": f"""Tercih Edilen Tarih: {treatment_details['date_range']}
                İyileşme Süresi: {recovery_days} gün
                Doktor Uzmanlık Alanı: {selected_doctor['alan']}
                Yakın Restoranlar: {[r['name'] for r in restaurants] if restaurants else 'Yok'}
                Yakın Turistik Yerler: {[a['name'] for a in attractions] if attractions else 'Yok'}"""}
            ],
            max_tokens=200
        )
        planning = planning_response.choices[0].message.content.strip()
        
        return recovery_plan, planning, recovery_days, restaurants, attractions
    except Exception as e:
        print(f"Planlama hatası: {str(e)}")
        return None, None, None, None, None

if __name__ == '__main__':
    app.run(debug=True)