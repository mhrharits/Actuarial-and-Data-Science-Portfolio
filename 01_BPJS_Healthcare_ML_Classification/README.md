# Perbandingan Metode Klasifikasi Supervised Learning pada Data Sampel BPJS Kesehatan Tahun 2015–2020

**Penulis:** Muhammad Harits Ramadhan, Andyta Putri Pramesty, Krishna Wahyu Ardian, Jayeng Raja, Zidni Kamal Hasan  
**Afiliasi:** Departemen Matematika, Fakultas MIPA, Institut Pertanian Bogor

## Abstrak
Status seorang pasien sehat atau tidak setelah mendapatkan fasilitas kunjungan tahap pertama (FKTP) dipengaruhi oleh beberapa faktor pada data sampel BPJS Kesehatan. Penelitian ini membandingkan enam metode klasifikasi supervised machine learning: Regresi Logistik, K-Nearest Neighbors (KNN), Support Vector Machine (SVM), XGBoost, Decision Tree, dan Random Forest pada 100.000 sampel acak dari 4.056.898 baris data kunjungan FKTP BPJS Kesehatan (2015–2020). Dengan menggunakan 5-Fold Cross Validation dan F1-Score sebagai metrik evaluasi, diperoleh dua metode terbaik yaitu Support Vector Machine (F1-Score: 0,996993) dan XGBoost (F1-Score: 0,996946).

## Hasil Evaluasi Model (Testing Set 30%)
| Metode | Presisi | Recall | F1-Score |
| :--- | :---: | :---: | :---: |
| **Support Vector Machine (SVM)** | 0,999330 | 0,994477 | **0,996993** |
| **XGBoost** | 0,999235 | 0,994668 | **0,996946** |
| **Random Forest (5-Fold CV)** | 0,998280 | **0,995049** | 0,996662 |
| **Random Forest (Manual Tuned: ntree=50, mtry=7)** | - | - | **0,996817** |
| **Regresi Logistik** | **0,999711** | 0,989240 | 0,994448 |
| **Decision Tree** | 0,999231 | 0,989240 | 0,994210 |
| **KNN (K = 1)** | 0,970399 | 0,961436 | 0,965897 |
| **KNN (K = 3)** | 0,965968 | 0,956770 | 0,961347 |
| **KNN (K = 5)** | 0,958920 | 0,953533 | 0,956219 |
