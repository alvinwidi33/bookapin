# 📚 Bookapin

**Bookapin** adalah aplikasi mobile berbasis **Flutter** untuk manajemen peminjaman buku.  
Aplikasi ini mendukung **role Customer dan Admin**, menggunakan **Firebase Authentication**, arsitektur **BLoC**, serta integrasi **REST API** dan **Firestore**.

---
## ✨ Fitur Utama

### 👤 Authentication
- Sign In & Sign Up
- Firebase Authentication
- Role-based access (Admin & Customer)
- Proteksi halaman admin dengan Admin Guard
- Halaman Profile

### 📖 Customer
- Melihat daftar buku
- Melihat detail buku
- Menyewa buku
- Riwayat penyewaan
- Detail penyewaan & pengembalian

### 🛠️ Admin (email: admin@gmail.com, pw: admin333)
- Dashboard statistik
- Manajemen user
- Melihat riwayat sewa per user
- Status pengembalian buku

---

## 🏗️ Arsitektur & State Management

Project ini menerapkan:
- **Clean-ish Architecture**
- **BLoC (flutter_bloc)**
- **Repository Pattern**
- **REST API (Dio)**
- **Firebase Auth & Firestore**

---
---

## 📱 APK Release (Optional)

Aplikasi **Bookapin** telah berhasil dibuild menjadi file **APK (release)** menggunakan Flutter.

- **Lokasi file**: `apk/bookapin-release.apk`
- **Perintah build**:
  ```bash
  flutter build apk --release

## 📋 PPT
- [PPT](https://www.canva.com/design/DAG0qM9HwCk/wCOEemSXLNZq4TbnAGnNyw/edit?utm_content=DAG0qM9HwCk&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)

## 📂 Struktur Folder

lib/
├── components/ # Theme, reusable widgets
├── core/ # Konstanta, helper, shared utilities
├── data/
│ ├── models/ # Model (Book, Rent, User, dll)
│ ├── network/ # Dio client & API config
│ └── repositories/ # Repository layer
├── features/
│ ├── admin/
│ │ ├── dashboard/
│ │ ├── rents-user/
│ │ └── users/
│ ├── authentication/
│ │ ├── signin/
│ │ ├── signup/
│ │ └── admin_guard.dart
│ ├── customers/
│ │ ├── home/
│ │ ├── history/
│ │ ├── detail/
│ │ └── detail-rents/
│ └── profile/
├── firebase_options.dart
└── main.dart