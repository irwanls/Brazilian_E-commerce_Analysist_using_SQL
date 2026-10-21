# Olist Seller and Customer Analysis
**SQL Data Preparation & E-Commerce Business Analysis**

## Project Overview

Proyek ini bertujuan untuk menganalisis performa penjualan, seller, dan customer pada platform e-commerce Olist di Brasil menggunakan **SQL** dan dataset **Brazilian E-Commerce Public Dataset by Olist**.

Analisis dilakukan dengan mengintegrasikan beberapa tabel yang saling berhubungan untuk memperoleh informasi mengenai status pesanan, performa kategori produk, tingkat pembatalan pesanan oleh seller, serta perilaku transaksi customer.

Pendekatan ini bertujuan untuk mengidentifikasi permasalahan operasional, mengevaluasi performa bisnis, dan menghasilkan insight yang dapat mendukung pengambilan keputusan berbasis data.

## Dataset

Dataset yang digunakan adalah **Brazilian E-Commerce Public Dataset by Olist**, dengan lima tabel utama:

| Dataset | Total Rows | Description |
|---|---:|---|
| `olist_orders_dataset` | 99,441 | Informasi pesanan, status, dan waktu transaksi |
| `olist_order_items_dataset` | 112,650 | Detail produk, seller, harga, dan ongkos kirim |
| `olist_products_dataset` | 32,951 | Informasi kategori dan karakteristik produk |
| `olist_sellers_dataset` | 3,095 | Informasi identitas dan lokasi seller |
| `olist_customers_dataset` | 99,441 | Informasi identitas dan lokasi customer |

Kelima tabel diintegrasikan menggunakan relasi **Primary Key dan Foreign Key** untuk menghasilkan data yang dapat dianalisis lebih lanjut.

## Project Workflow

### 1. Data Understanding & Preparation

Melakukan pemeriksaan struktur dan kualitas data menggunakan SQL, meliputi:

- Pemeriksaan tipe data dan konversi kolom tanggal.
- Identifikasi duplikat untuk memastikan keunikan data.
- Penentuan Primary Key dan Foreign Key antar tabel.
- Identifikasi missing values pada setiap tabel.
- Identifikasi outlier menggunakan metode Interquartile Range (IQR).
- Penggabungan data berdasarkan relasi antar tabel.

### 2. Sales & Order Performance Analysis

Menganalisis performa transaksi berdasarkan status pesanan untuk mengevaluasi keberhasilan proses penjualan dan pengiriman.

Analisis meliputi:

- Distribusi status pesanan (*delivered, shipped, canceled,* dan *unavailable*).
- Persentase pesanan yang berhasil diterima customer.
- Identifikasi pesanan yang dibatalkan atau tidak dapat diproses.

### 3. Product Performance Analysis

Membandingkan performa kategori produk berdasarkan:

- Total produk terjual.
- Total revenue berdasarkan kategori.
- Perbedaan kategori dengan volume penjualan tertinggi dan kategori penghasil revenue terbesar.

### 4. Seller Performance Analysis

Mengevaluasi performa seller menggunakan beberapa indikator:

- Total order yang ditangani.
- Jumlah canceled orders.
- **Cancellation rate** sebagai indikator tingkat pembatalan pesanan.
- **Price lost** untuk mengevaluasi nilai transaksi yang berpotensi hilang akibat pembatalan.

### 5. Customer Transaction Analysis

Menganalisis perilaku customer berdasarkan riwayat transaksi, meliputi:

- Frekuensi transaksi.
- Total spending customer.
- Perbandingan jumlah transaksi dan nilai pembelian.
- Identifikasi indikasi customer loyalty berdasarkan data transaksi.

## Key Findings

Berdasarkan hasil analisis, diperoleh beberapa temuan utama:

1. **Order Fulfillment Performance:** Dari 99.441 pesanan, sebanyak **97,02% (96.478 order)** berhasil diterima customer. Sementara itu, 0,62% pesanan dibatalkan dan 0,61% tidak dapat dilanjutkan karena berstatus unavailable.

2. **Product Performance:** Kategori *cama_mesa_banho* memiliki jumlah penjualan tertinggi, sedangkan kategori *beleza_saude* menghasilkan revenue terbesar. Hal ini menunjukkan bahwa kategori dengan volume penjualan tertinggi belum tentu menghasilkan pendapatan terbesar.

3. **Seller Performance:** Seller dengan jumlah pembatalan tertinggi tidak selalu memiliki cancellation rate atau price lost terbesar. Oleh karena itu, evaluasi performa seller perlu mempertimbangkan proporsi pembatalan terhadap total order.

4. **Customer Behavior:** Customer dengan frekuensi transaksi tertinggi, yaitu 16 transaksi, memiliki total spending sebesar 729,62. Sementara itu, customer dengan spending tertinggi sebesar 4.080 hanya melakukan 4 transaksi.

5. **Customer Loyalty:** Belum ditemukan pola loyalitas customer yang konsisten berdasarkan frekuensi transaksi dan total spending yang dianalisis.

## Business Recommendations

Berdasarkan hasil analisis, rekomendasi yang diberikan meliputi:

- **Maintain Order Fulfillment Performance:** Mempertahankan performa pemenuhan pesanan yang telah mencapai tingkat keberhasilan pengiriman sebesar 97,02%.
- **Seller Performance Monitoring:** Memberikan perhatian dan peringatan kepada seller dengan cancellation rate tinggi, khususnya di atas 50%.
- **Product Prioritization:** Memprioritaskan kategori produk dengan mempertimbangkan kombinasi volume penjualan dan revenue yang tinggi.
- **Cancellation Evaluation:** Mengevaluasi seller berdasarkan cancellation rate dan potensi nilai transaksi yang hilang, bukan hanya jumlah pesanan yang dibatalkan.

## Tools & Technologies

- **SQL** — Data extraction, cleaning, integration, dan analysis.
- **Relational Database** — Pengelolaan relasi data menggunakan Primary Key dan Foreign Key.
- **SQL Aggregation & Analysis** — Perhitungan order status, revenue, cancellation rate, dan customer spending.

## Conclusion

Proyek ini menunjukkan bagaimana integrasi beberapa tabel menggunakan SQL dapat menghasilkan informasi yang bermanfaat untuk mengevaluasi performa bisnis e-commerce.

Hasil analisis menunjukkan bahwa Olist memiliki tingkat keberhasilan pengiriman pesanan yang tinggi, namun masih terdapat peluang evaluasi pada pembatalan pesanan, performa seller, serta prioritas kategori produk berdasarkan kontribusi penjualan dan revenue.

Selain itu, analisis customer menunjukkan bahwa frekuensi transaksi tidak selalu berbanding lurus dengan total spending, sehingga data yang dianalisis belum menunjukkan pola customer loyalty yang konsisten.

Secara keseluruhan, hasil proyek ini dapat digunakan sebagai dasar pertimbangan dalam meningkatkan efisiensi operasional, mengevaluasi performa seller, dan mengembangkan strategi penjualan berbasis data.

---

**Author:** Irwan Lazuardi Saldeni

**Project:** SQL Data Analysis — Olist Seller and Customer Analysis

**Dataset:** Brazilian E-Commerce Public Dataset by Olist
