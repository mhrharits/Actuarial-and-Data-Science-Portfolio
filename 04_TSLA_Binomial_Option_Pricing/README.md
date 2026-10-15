# Penentuan Harga Opsi Saham Tesla (TSLA) Menggunakan Metode Pohon Binomial (Binomial Tree)

**Tim Penyusun:** Muhammad Harits Ramadhan, Ardenisa Dusi Santuni, Farah Nurina Zhafira, Dianike Marsalisa Mayori, Josephine Ayudhita Mawarni Sitorus, Randi Satria Purnama

## Ringkasan Proyek
Mengimplementasikan algoritma matriks Pohon Binomial (Cox-Ross-Rubinstein) hingga $N = 100$ langkah di R untuk menentukan harga opsi pada saham **Tesla, Inc. (TSLA)** serta mengevaluasi konvergensi numeriknya.

* **Parameter Historis TSLA:** $S_0 = \text{USD } 197,37$, volatilitas tahunan $\sigma = 68,33\%$, suku bunga bebas risiko $r = 5\%$, jatuh tempo $T = 0,5\text{ tahun}$, dan harga eksekusi $K = 0,9 S_0$.
* **Hasil Konvergensi:** Pada $N = 100$ langkah, estimasi harga opsi konvergen ke **USD 73,19506**, dengan galat relatif di bawah **0,043%** saat jumlah langkah mencapai $n = 64$.
