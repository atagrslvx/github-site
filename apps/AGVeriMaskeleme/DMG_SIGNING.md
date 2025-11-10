# DMG İmzalama & Notarization Rehberi

## 🎯 Genel Bakış

AG Veri Maskeleme uygulaması için DMG oluşturma ve imzalama süreci.

## 🚀 Otomatik Build (Önerilen)

Build script tüm süreci otomatikleştirir:

```bash
cd apps/AGVeriMaskeleme
./build.sh release
```

Bu komut:
1. ✅ Projeyi Release modunda build eder
2. ✅ Uygulamayı archive eder
3. ✅ Ad-hoc code signing yapar
4. ✅ DMG oluşturur
5. ✅ SHA-256 hesaplar

**Çıktı:** `build/AG-Veri-Maskeleme.dmg`

---

## 🔐 Ad-hoc İmzalama (Developer hesabı olmadan)

Build script otomatik yapar, ancak manuel olarak:

```bash
# 1. Uygulamayı imzala
codesign --force --deep --sign - "AG Veri Maskeleme.app"

# 2. Doğrula
codesign --verify --deep --verbose "AG Veri Maskeleme.app"

# 3. DMG oluştur
hdiutil create \
  -volname "AG Veri Maskeleme" \
  -srcfolder "AG Veri Maskeleme.app" \
  -ov -format UDZO \
  "AG-Veri-Maskeleme.dmg"
```

**Avantajlar:**
- ✅ Ücretsiz
- ✅ Developer hesabı gereksiz
- ✅ Yerel geliştirme için yeterli

**Dezavantajlar:**
- ⚠️ Kullanıcı ilk açışta "Güvenilmeyen geliştirici" uyarısı alır
- ⚠️ Çözüm: Sağ tık → Aç veya `xattr -cr`

---

## 🍎 Apple Notarization (Üretim için)

Apple Developer hesabınız varsa, Gatekeeper uyarısı olmadan dağıtım:

### Gereksinimler

1. **Apple Developer Account** ($99/yıl)
2. **Developer ID Application Certificate**
3. **App-Specific Password**

### Adımlar

#### 1. Environment Variables
```bash
export APPLE_ID="your-email@icloud.com"
export APPLE_TEAM_ID="YOUR_TEAM_ID"  # Developer hesabınızdan
export APPLE_APP_PASSWORD="xxxx-xxxx-xxxx-xxxx"  # App-specific password
```

#### 2. Developer ID ile İmzala
```bash
# Certificate'inizi bulun
security find-identity -v -p codesigning

# İmzalayın (ad-hoc - yerine certificate ID)
codesign --force --deep \
  --sign "Developer ID Application: Your Name (TEAM_ID)" \
  --options runtime \
  "AG Veri Maskeleme.app"
```

#### 3. DMG Oluştur
```bash
hdiutil create \
  -volname "AG Veri Maskeleme" \
  -srcfolder "AG Veri Maskeleme.app" \
  -ov -format UDZO \
  "AG-Veri-Maskeleme.dmg"

# DMG'yi de imzala
codesign --force --sign "Developer ID Application: Your Name (TEAM_ID)" \
  "AG-Veri-Maskeleme.dmg"
```

#### 4. Notarize Et
```bash
# DMG'yi Apple'a gönder
xcrun notarytool submit "AG-Veri-Maskeleme.dmg" \
  --apple-id "$APPLE_ID" \
  --team-id "$APPLE_TEAM_ID" \
  --password "$APPLE_APP_PASSWORD" \
  --wait

# Notarization ticket'ı DMG'ye ekle
xcrun stapler staple "AG-Veri-Maskeleme.dmg"

# Doğrula
spctl --assess --type open -v "AG-Veri-Maskeleme.dmg"
```

#### 5. SHA-256 Hesapla
```bash
shasum -a 256 "AG-Veri-Maskeleme.dmg"
```

### Otomatik Script

Proje root'ta `scripts/notarize-ag-dmg.sh` scripti var:

```bash
# Environment variables ayarla
export APPLE_ID="..."
export APPLE_TEAM_ID="..."
export APPLE_APP_PASSWORD="..."

# Notarize et
../../scripts/notarize-ag-dmg.sh build/AG-Veri-Maskeleme.dmg
```

---

## 🐛 Sorun Giderme

### "Hasarlı" DMG Hatası

```bash
# Quarantine attribute'ları temizle
xattr -cr "AG Veri Maskeleme.app"

# Veya DMG mount edip uygulamayı kopyala
hdiutil attach AG-Veri-Maskeleme.dmg
cp -R "/Volumes/AG Veri Maskeleme/AG Veri Maskeleme.app" /Applications/
xattr -cr "/Applications/AG Veri Maskeleme.app"
```

### Gatekeeper Uyarısı

**Kullanıcı için çözüm:**
1. Sağ tık → Aç
2. "Aç" butonuna tıkla
3. Uygulama artık güvenilir listeye eklendi

**Veya Terminal:**
```bash
xattr -cr "/Applications/AG Veri Maskeleme.app"
```

### Code Signing Hatası

```bash
# Mevcut imzaları kontrol
codesign -dvvv "AG Veri Maskeleme.app"

# Eski imzaları kaldır
codesign --remove-signature "AG Veri Maskeleme.app"

# Yeniden imzala
codesign --force --deep --sign - "AG Veri Maskeleme.app"
```

---

## 📊 Karşılaştırma

| Özellik | Ad-hoc Signing | Notarization |
|---------|---------------|--------------|
| Maliyet | Ücretsiz | $99/yıl |
| Kurulum | Kolay | Orta |
| Gatekeeper | ⚠️ Uyarı verir | ✅ Uyarı yok |
| Kullanıcı Deneyimi | Orta | Mükemmel |
| Önerilen | Geliştirme/Test | Üretim/Dağıtım |

---

## 🎯 Öneriler

### Geliştirme & Test
- ✅ Ad-hoc signing kullanın
- ✅ Build script yeterli: `./build.sh release`
- ✅ Hızlı iterasyon

### Üretim & Dağıtım
- ✅ Developer ID + Notarization
- ✅ Profesyonel görünüm
- ✅ Kullanıcı güveni

---

## 📝 Notlar

- **Build script** zaten ad-hoc signing yapıyor
- **DMG boyutu** ~5-10 MB (SwiftUI native)
- **Notarization süresi** ~5-15 dakika
- **Certificate geçerlilik** 5 yıl

---

## 🔗 Kaynaklar

- [Apple Notarization Guide](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)
- [Code Signing Guide](https://developer.apple.com/library/archive/documentation/Security/Conceptual/CodeSigningGuide/)
- [DMG Creation](https://ss64.com/osx/hdiutil.html)

---

© 2025 Ata Gürsel
