# AG Veri Maskeleme - Hızlı Başlangıç

## 🚀 5 Dakikada Kullanıma Hazır

### 1️⃣ Build (İlk Sefer)

```bash
cd apps/AGVeriMaskeleme
./build.sh release
```

Bu komut:
- ✅ Projeyi compile eder
- ✅ Ad-hoc code signing yapar
- ✅ DMG installer oluşturur
- ✅ SHA-256 hesaplar

**Çıktı:** `build/AG-Veri-Maskeleme.dmg`

### 2️⃣ Test Et

```bash
# DMG'yi aç
open build/AG-Veri-Maskeleme.dmg

# Uygulamayı Applications'a sürükle ve çalıştır
```

**Veya Xcode ile:**
```bash
open AGVeriMaskeleme.xcodeproj
# ⌘R ile çalıştır
```

### 3️⃣ Demo Veri ile Test

Uygulamayı açınca:
1. "Demo CSV" veya "Demo JSON" butonuna tıkla
2. Otomatik seçilen kolonları incele
3. Maskeleme stratejisi seç
4. "Maskele" butonuna bas
5. Export et

### 4️⃣ Kendi Verilerinle

```bash
# Test CSV oluştur
cat > test.csv << 'EOF'
id,ad,email,telefon,iban
1,Ahmet,ahmet@test.com,05321234567,TR180006200119000006672315
2,Ayşe,ayse@test.com,05421234567,TR750006200119000009992318
EOF
```

Uygulamada:
1. "Dosya Seç" → test.csv'yi seç
2. Hassas kolonlar otomatik seçilir (email, telefon, iban)
3. Canlı önizleme ile maskelenmiş hali gör
4. Maskele & Export

### 5️⃣ Web Sitesine Deploy

```bash
# DMG'yi public klasörüne kopyala
cp build/AG-Veri-Maskeleme.dmg ../../public/downloads/ag-veri-maskeleme.dmg

# Metadata güncelle (SHA-256 hash)
cd ../../
node scripts/update-dmg.mjs apps/AGVeriMaskeleme/build/AG-Veri-Maskeleme.dmg

# Git commit & push
git add .
git commit -m "Update AG Veri Maskeleme DMG"
git push
```

## 🎨 Özellikler

### Maskeleme Stratejileri

**1. Kısmi Maskeleme** (Varsayılan)
```
ahmet@example.com → ah***@ex***le.com
05321234567 → 0532***4567
TR180006200119000006672315 → TR18***************2315
```

**2. SHA-256 Hash**
```
ahmet@example.com → 2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae
(Salt ile deterministik)
```

**3. Rastgele**
```
ahmet@example.com → xkpzt@mxsbqrm.com
05321234567 → 09876543210
```

**4. Tamamen Gizle**
```
ahmet@example.com → [GIZLI]
```

### UI Özellikleri

- ✨ Modern gradient dark theme
- ✨ Smooth SwiftUI animations
- ✨ Canlı önizleme (ilk 3 satır)
- ✨ Otomatik hassas kolon tespiti
- ✨ İşlem istatistikleri
- ✨ Drag & drop (gelecek sürümde)

## 🐛 Sorun Giderme

### Build hatası alırsanız

```bash
# Xcode Command Line Tools kontrol
xcode-select --install

# Build cache temizle
rm -rf build/
./build.sh release
```

### "Hasarlı" DMG hatası

```bash
# Ad-hoc signing tekrar yap
cd build
codesign --force --deep --sign - "AG Veri Maskeleme.app"
hdiutil create -volname "AG Veri Maskeleme" -srcfolder "AG Veri Maskeleme.app" -ov -format UDZO AG-Veri-Maskeleme-signed.dmg
```

### macOS Gatekeeper uyarısı

```bash
# Uygulamayı güvenilir yap
xattr -cr "/Applications/AG Veri Maskeleme.app"
```

## 📝 Notlar

- **Minimum macOS:** 13.0 (Ventura)
- **Mimari:** Apple Silicon optimize (Universal binary)
- **Dosya boyutu:** ~5-10 MB (SwiftUI native)
- **Güvenlik:** App Sandbox, CryptoKit
- **Offline:** Hiçbir veri dışarı gönderilmez

## 🔗 Daha Fazla

- Detaylı döküman: [README.md](README.md)
- Web sitesi: [atagursel.com.tr](https://atagursel.com.tr)
- İletişim: atagursel@yahoo.com
