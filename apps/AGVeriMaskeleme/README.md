# AG Veri Maskeleme

Modern, native macOS veri maskeleme uygulaması. SwiftUI ile geliştirilmiştir.

## 🎯 Özellikler

### Core Features
- ✅ **CSV/JSON Desteği** - Her iki formatı da parse edip export eder
- ✅ **4 Maskeleme Stratejisi**
  - Kısmi Maskeleme (partial masking)
  - SHA-256 Hash (deterministik)
  - Rastgele (randomize)
  - Tamamen Gizle (redact)
- ✅ **Akıllı Maskeleme**
  - Email pattern detection
  - IBAN maskeleme
  - Telefon numarası maskeleme
  - TC Kimlik no maskeleme
- ✅ **Canlı Önizleme** - İlk 3 satırı maskeleyip gösterir
- ✅ **Demo Veri** - Hazır test verisi ile deneme
- ✅ **Modern UI** - Gradient, smooth animations, dark theme

### Security & Privacy
- 🔒 **Offline-First** - Tüm işlemler yerel cihazda
- 🔒 **Sandbox** - App Sandbox enabled
- 🔒 **CryptoKit** - Native Apple kriptografi
- 🔒 **No Analytics** - Hiçbir veri toplanmaz

## 🛠️ Geliştirme

### Gereksinimler
- macOS 13.0+ (Ventura)
- Xcode 15.0+
- Swift 5.9+

### Build

#### Debug Build (Test için)
```bash
cd apps/AGVeriMaskeleme
chmod +x build.sh
./build.sh debug
```

#### Release Build (DMG ile)
```bash
./build.sh release
```

Build script otomatik olarak:
1. Projeyi compile eder
2. Ad-hoc code signing yapar
3. DMG installer oluşturur
4. SHA-256 hesaplar

### Manuel Xcode Build

1. Projeyi aç:
```bash
open AGVeriMaskeleme.xcodeproj
```

2. Scheme'i seçin: `AGVeriMaskeleme`
3. Run (⌘R) veya Archive (⌘⇧B)

## 📦 Deployment

### DMG Oluşturma

```bash
# Build script otomatik DMG oluşturur
./build.sh release

# DMG konumu
ls -lh build/AG-Veri-Maskeleme.dmg

# SHA-256 doğrulama
cat build/AG-Veri-Maskeleme.dmg.sha256
```

### Web Sitesine Deploy

```bash
# DMG'yi public klasörüne kopyala
cp build/AG-Veri-Maskeleme.dmg ../../public/downloads/ag-veri-maskeleme.dmg

# Metadata güncelle
cd ../../
node scripts/update-dmg.mjs apps/AGVeriMaskeleme/build/AG-Veri-Maskeleme.dmg
```

### Notarization (Opsiyonel)

Apple Developer hesabınız varsa:

```bash
# Environment variables ayarla
export APPLE_ID="your-email@example.com"
export APPLE_TEAM_ID="YOUR_TEAM_ID"
export APPLE_APP_PASSWORD="app-specific-password"

# Notarize et
../../scripts/notarize-ag-dmg.sh build/AG-Veri-Maskeleme.dmg
```

## 🏗️ Mimari

```
AGVeriMaskeleme/
├── Models/
│   ├── DataModel.swift          # Core data structures
│   └── DemoData.swift            # Sample data
├── Services/
│   ├── MaskingEngine.swift       # Core masking logic
│   ├── CSVParser.swift           # CSV parsing
│   ├── JSONParser.swift          # JSON parsing
│   └── ExportManager.swift       # File export
├── ViewModels/
│   └── MaskingViewModel.swift    # Main view model
├── Views/
│   ├── ContentView.swift         # Main screen
│   ├── ColumnSelectorView.swift  # Column picker
│   └── PreviewView.swift         # Preview table
└── Utils/
    └── FileImporter.swift        # File handling
```

## 🧪 Testing

### Demo Veri ile Test

Uygulama içinde:
1. "Demo CSV" veya "Demo JSON" butonuna tıklayın
2. Otomatik seçilen kolonları inceleyin
3. Strateji seçip maskeleyin
4. Export edin

### Kendi Verilerinizle

```bash
# Test CSV oluştur
cat > test.csv << EOF
id,ad,email,telefon
1,Ahmet,ahmet@test.com,05321234567
2,Ayşe,ayse@test.com,05421234567
EOF

# Uygulamada "Dosya Seç" ile yükle
```

## 📝 Maskeleme Stratejileri

### 1. Kısmi Maskeleme
```
ahmet@example.com → ah***@ex***le.com
05321234567 → 0532***4567
TR180006200119000006672315 → TR18***************2315
```

### 2. SHA-256 Hash
```
ahmet@example.com → 2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae
```

### 3. Rastgele
```
ahmet@example.com → xkpzt@mxsbqrm.com
05321234567 → 09876543210
```

### 4. Tamamen Gizle
```
ahmet@example.com → [GIZLI]
```

## 🔐 Güvenlik

- **Sandbox**: Uygulama sandbox modda çalışır
- **File Access**: Sadece kullanıcının seçtiği dosyalara erişir
- **No Network**: İnternet bağlantısı kullanmaz
- **Local Processing**: Tüm işlemler cihazda yapılır
- **CryptoKit**: Apple'ın native kriptografi kütüphanesi

## 📄 Lisans

© 2025 Ata Gürsel. Tüm hakları saklıdır.

## 🤝 Destek

Sorularınız için:
- Email: atagursel@yahoo.com
- LinkedIn: [linkedin.com/in/atagursel](https://www.linkedin.com/in/atagursel/)
- Website: [atagursel.com.tr](https://atagursel.com.tr)

## 🚀 Changelog

### v1.0.0 (2025-11-10)
- ✨ İlk sürüm
- ✅ CSV/JSON parser
- ✅ 4 maskeleme stratejisi
- ✅ Modern SwiftUI UI
- ✅ Demo data
- ✅ Export functionality
- ✅ Ad-hoc code signing
- ✅ DMG installer
