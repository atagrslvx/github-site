# Ata Gürsel - Portfolio Website 🚀

Modern, performant ve animasyonlu portfolio sitesi. Astro, React, Tailwind CSS ve Framer Motion ile oluşturuldu.

## ✨ Özellikler

### Core Features
- ⚡️ **Ultra Hızlı** - Astro'nun static site generation (SSG) özelliği
- 🎨 **Modern Design** - Glassmorphism ve gradient efektleri  
- 🎭 **Smooth Animations** - Framer Motion ile profesyonel animasyonlar
- 📱 **Responsive** - Tüm cihazlarda mükemmel görünüm
- 🌙 **Dark Theme** - Modern dark mode tasarım

### 2025 Modern Features 🆕
- 📱 **PWA Support** - Progressive Web App (offline çalışma, install prompt)
- ✨ **View Transitions API** - Smooth page transitions
- 🖼️ **Image Optimization** - Sharp ile otomatik image optimization
- ♿️ **Accessibility First** - WCAG 2.1 AA, reduced motion, high contrast
- 🚀 **Performance** - Preload, prefetch, DNS prefetch, compression
- 📊 **Analytics Ready** - Google Analytics hazır entegrasyon
- 🔍 **SEO Optimized** - Enhanced Open Graph, Twitter Cards, robots.txt
- 🧭 **Tech Radar** - @nivo/radar ile görselleştirilen beceri yoğunluk haritası
- 📈 **GitHub Aktivitesi** - atagrslvx hesabından gerçek zamanlı katkı özetleri + sparkline trendi
- 🧑‍💻 **Dinamik Proje Feed'i** - atagrsl reposundan build-time'da çekilen showcase listesi
- 💾 **AG Veri Maskeleme** - Native SwiftUI macOS uygulaması, 4 maskeleme stratejisi, modern gradient UI, offline-first

### AG Veri Maskeleme - Native SwiftUI App
Profesyonel veri maskeleme uygulaması `apps/AGVeriMaskeleme/` dizininde.

**Özellikler:**
- SwiftUI modern arayüz (gradient, dark theme, smooth animations)
- 4 maskeleme stratejisi (kısmi, hash, rastgele, redact)
- CSV/JSON parser & export
- Canlı önizleme & demo veri
- CryptoKit şifreleme
- App Sandbox security

**Build & Deploy:**
```bash
cd apps/AGVeriMaskeleme

# Debug build (test için)
./build.sh debug

# Release build (DMG ile)
./build.sh release

# DMG'yi siteye kopyala
cp build/AG-Veri-Maskeleme.dmg ../../public/downloads/ag-veri-maskeleme.dmg

# Metadata güncelle
cd ../..
node scripts/update-dmg.mjs apps/AGVeriMaskeleme/build/AG-Veri-Maskeleme.dmg
```

Detaylı dokümantasyon: `apps/AGVeriMaskeleme/README.md`

## 🛠️ Tech Stack

### Core
- **Framework:** Astro 5 - Static site generation
- **UI Library:** React 19 - Interactive components
- **Styling:** Tailwind CSS 3 - Utility-first CSS
- **Animations:** Framer Motion - Smooth animations
- **Icons:** Lucide React - Modern icon set
- **Language:** TypeScript - Type safety

### Performance & Optimization
- **Image Processing:** Sharp - Image optimization
- **Service Worker:** PWA support - Offline functionality
- **View Transitions:** Native browser API - Smooth navigation

### Deployment & Tools
- **Deployment:** GitHub Pages - Free hosting
- **CI/CD:** GitHub Actions - Automated deployment
- **Analytics:** Ready for Google Analytics/Vercel Analytics

## 🧞 Komutlar

Tüm komutlar projenin root dizininden terminal üzerinden çalıştırılır:

| Komut              | Açıklama                                      |
| :----------------- | :-------------------------------------------- |
| `npm install`      | Dependencies'leri yükler                      |
| `npm run dev`      | Local dev server başlatır `localhost:4321`    |
| `npm run build`    | Production build oluşturur `./dist/`          |
| `npm run preview`  | Build'i local olarak önizler                  |

## 🚀 Kurulum

```bash
# Dependencies'leri yükle
npm install

# Dev server'ı başlat
npm run dev

# Production build
npm run build
```

## 📦 Deployment

Site otomatik olarak GitHub Pages'e deploy edilir. Her `main` branch'e push işleminde GitHub Actions workflow çalışır.

## 📝 Lisans

© 2025 Ata Gürsel. Tüm hakları saklıdır.

## 🔗 Bağlantılar

- **Website:** https://atagursel.com.tr
- **LinkedIn:** https://www.linkedin.com/in/atagursel/
- **GitHub:** https://github.com/ATAGRSL
- **Email:** atagursel@yahoo.com
