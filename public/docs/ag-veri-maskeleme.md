# AG Veri Maskeleme - Kurulum Rehberi

## 🚀 Hızlı Kurulum

### 1. DMG İndirme
[AG-Veri-Maskeleme.dmg](/downloads/ag-veri-maskeleme.dmg) dosyasını indirin.

### 2. Uygulama Kurulumu
1. DMG dosyasını çift tıklayarak açın
2. `AG Veri Maskeleme.app` simgesini `Applications` klasörüne sürükleyin
3. Spotlight (⌘+Space) ile "AG Veri Maskeleme" arayıp açın

### 3. İlk Kullanım
- **Demo ile test:** Uygulamayı açınca "Demo CSV" veya "Demo JSON" butonuna tıklayın
- **Kendi dosyanız:** "Dosya Seç" ile CSV veya JSON dosyanızı seçin

## ✨ Özellikler

- ✅ **Native SwiftUI** - Modern macOS arayüzü
- ✅ **4 Maskeleme Stratejisi**
  - Kısmi maskeleme (email, IBAN, telefon akıllı tespit)
  - SHA-256 hash (salt desteği)
  - Rastgele (karakter tipini korur)
  - Tamamen gizle (REDACTED)
- ✅ **Canlı Önizleme** - İlk 3 satırı maskelemeyi gösterir
- ✅ **Demo Veri** - Test için hazır veri setleri
- ✅ **Offline** - Hiçbir veri dışarı gönderilmez
- ✅ **CSV & JSON** - Her iki format için import/export

## 🔐 Güvenlik

### Gatekeeper Uyarısı
İlk açılışta macOS Gatekeeper uyarısı alabilirsiniz:

**Çözüm 1:** Sistem Ayarları
1. `Sistem Ayarları > Gizlilik ve Güvenlik` açın
2. "Yine de Aç" butonuna tıklayın

**Çözüm 2:** Terminal
```bash
xattr -cr "/Applications/AG Veri Maskeleme.app"
```

### SHA-256 Doğrulama
İndirdiğiniz DMG'nin bütünlüğünü kontrol edin:
```bash
shasum -a 256 ~/Downloads/ag-veri-maskeleme.dmg
```

## 💡 Kullanım İpuçları

### Maskeleme Örnekleri

**Kısmi Maskeleme:**
```
ahmet@example.com → ah***@ex***le.com
05321234567 → 0532***4567
TR180006200119000006672315 → TR18***************2315
```

**SHA-256 Hash:**
```
ahmet@example.com → a7f3d2e1c9b8...
```

## 📊 Sistem Gereksinimleri

- macOS 13.0+ (Ventura)
- Apple Silicon veya Intel
- ~10 MB disk alanı

## 🆘 Destek

- Email: atagursel@yahoo.com
- LinkedIn: [linkedin.com/in/atagursel](https://www.linkedin.com/in/atagursel/)

---

© 2025 Ata Gürsel
