import { useState } from 'react';
import { motion } from 'framer-motion';
import {
  ShieldCheck,
  Download,
  Terminal,
  Lock,
  Cpu,
  FileCode,
  CheckCircle2,
  Copy,
  Check,
  AlertTriangle,
} from 'lucide-react';
import agDmgMeta from '../data/ag-dmg.json';

const features = [
  {
    title: 'Native SwiftUI App',
    description: 'Tamamen Swift ile yazılmış, modern gradient UI, smooth animations. Electron değil, gerçek native.',
    icon: ShieldCheck,
  },
  {
    title: 'Offline & Güvenli',
    description: 'App Sandbox, CryptoKit şifreleme. Tüm işlemler yerel cihazda, hiçbir veri dışarı gönderilmez.',
    icon: Lock,
  },
  {
    title: '4 Maskeleme Stratejisi',
    description: 'Kısmi maskeleme, SHA-256 hash, rastgele ve tamamen gizle. Akilli email/IBAN/telefon tespit.',
    icon: Cpu,
  },
];

const steps = [
  { title: 'Dosya seç veya demo yükle', detail: 'CSV/JSON dosyasını sürükle-bırak veya hazır demo veri ile test et' },
  { title: 'Kolonları seç & strateji belirle', detail: 'Hassas kolonlar otomatik seçilir. Canlı önizleme ile sonucu gör' },
  { title: 'Maskele & export et', detail: 'İşlem istatistikleri ile birlikte CSV veya JSON olarak kaydet' },
];

const dmgUrl = import.meta.env.PUBLIC_AG_DMG_URL?.trim() || agDmgMeta.defaultPath;

const DataMaskingApp = () => {
  const guiSha = agDmgMeta.sha256;
  const [shaCopied, setShaCopied] = useState(false);

  const copySha = async () => {
    try {
      await navigator.clipboard.writeText(guiSha);
      setShaCopied(true);
      setTimeout(() => setShaCopied(false), 1800);
    } catch {
      setShaCopied(false);
    }
  };

  return (
    <section id="masking-app" className="py-20 lg:py-32 bg-gradient-to-b from-dark-950 via-dark-900 to-dark-950">
      <div className="container-custom">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="text-center mb-16 max-w-3xl mx-auto"
        >
          <span className="inline-flex items-center gap-2 px-4 py-1 rounded-full bg-primary-500/10 text-primary-300 text-sm font-semibold mb-4">
            <ShieldCheck className="w-4 h-4" />
            KVKK uyumlu veri maskeleme
          </span>
          <h2 className="section-title mb-4">AG Veri Maskeleme - Native macOS App</h2>
          <p className="section-subtitle">
            SwiftUI ile geliştirilmiş profesyonel veri maskeleme uygulaması. Modern arayüz, hızlı performans ve tam güvenlik.
            DMG formatında indirip hemen kullanmaya başlayabilirsin.
          </p>
        </motion.div>

        <div className="grid lg:grid-cols-2 gap-10">
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            className="space-y-8"
          >
            <div className="glass-card p-6 lg:p-8 space-y-6 border border-primary-500/10">
              <h3 className="text-2xl font-semibold text-dark-50">Neler sunuyor?</h3>
              <div className="grid sm:grid-cols-2 gap-4">
                {features.map((feature) => (
                  <div key={feature.title} className="glass-card-hover p-4 rounded-2xl border border-dark-700/60">
                    <feature.icon className="w-6 h-6 text-primary-400 mb-3" />
                    <h4 className="text-lg font-semibold mb-2">{feature.title}</h4>
                    <p className="text-sm text-dark-400">{feature.description}</p>
                  </div>
                ))}
              </div>
              <div className="rounded-2xl border border-dashed border-primary-500/40 p-5 text-sm text-dark-300 bg-dark-900/40">
                <p className="font-mono text-xs uppercase tracking-wider text-primary-300 mb-2">Öne çıkan akış</p>
                <p className="text-sm text-dark-400">
                  Dosyayı seç → Kolonları işaretle → Stratejiyi belirle → Maskelenmiş çıktıyı tek tıkla oluştur.
                </p>
              </div>
            </div>

            <div className="grid gap-4">
              {steps.map((step, index) => (
                <div key={step.title} className="flex items-start gap-4">
                  <div className="w-10 h-10 flex items-center justify-center rounded-full bg-primary-500/10 text-primary-200 font-semibold">
                    {index + 1}
                  </div>
                  <div>
                    <p className="text-dark-50 font-semibold">{step.title}</p>
                    <p className="text-dark-400 text-sm">{step.detail}</p>
                  </div>
                </div>
              ))}
            </div>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, x: 20 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
          >
            <div className="space-y-8">
              <div className="glass-card p-6 lg:p-8 rounded-3xl border border-primary-500/20 space-y-6">
                <div className="flex items-center justify-between gap-4 flex-wrap">
                  <div>
                    <p className="text-sm text-primary-300 uppercase tracking-wide">macOS GUI</p>
                    <h3 className="text-2xl font-bold text-dark-50">Veri Masker Masaüstü</h3>
                  </div>
                  <Download className="w-10 h-10 text-primary-300" />
                </div>
                <ul className="space-y-3 text-sm text-dark-300">
                  <li className="flex items-center gap-2">
                    <FileCode className="w-4 h-4 text-primary-400" />
                    macOS 13.0+ (Ventura) · Apple Silicon · Native SwiftUI
                  </li>
                  <li className="flex items-center gap-2">
                    <Terminal className="w-4 h-4 text-primary-400" />
                    Modern UI, gradient design, smooth animations, dark theme
                  </li>
                  <li className="flex items-center gap-2">
                    <CheckCircle2 className="w-4 h-4 text-primary-400" />
                    SHA-256:
                    <button
                      type="button"
                      onClick={copySha}
                      className="inline-flex items-center gap-1 px-2 py-1 rounded-full bg-dark-800 text-xs font-mono"
                    >
                      {shaCopied ? <Check className="w-3 h-3 text-primary-300" /> : <Copy className="w-3 h-3" />}
                      {guiSha.slice(0, 10)}…
                    </button>
                  </li>
                </ul>
                <div className="grid gap-3">
                  <a
                    href={dmgUrl}
                    className="btn-primary w-full flex items-center justify-center gap-2"
                    download
                  >
                    <Download className="w-4 h-4" />
                    DMG dosyasını indir
                  </a>
                  <p className="text-xs text-dark-400">
                    Kurulum: DMG’yi aç → `Veri Masker.app` → `Applications` klasörüne sürükle.
                  </p>
                </div>
              </div>

              <div className="glass-card p-6 lg:p-8 rounded-3xl border border-dark-800/60 space-y-4">
                <div className="flex items-center gap-3">
                  <AlertTriangle className="w-5 h-5 text-amber-300" />
                  <div>
                    <p className="text-sm text-primary-300 uppercase tracking-wide">Kurulum & güvenlik</p>
                    <h3 className="text-xl font-semibold text-dark-50">Gatekeeper uyarısı için çözüm</h3>
                  </div>
                </div>
                <ol className="text-sm text-dark-300 space-y-3 list-decimal list-inside">
                  <li>Notarize edilmiş DMG indirdiğinizden emin olun; indirilen dosya için `shasum -a 256` sonucunu karşılaştırın.</li>
                  <li>
                    Alternatif olarak Terminal’de
                    <code className="block font-mono text-xs text-primary-200 mt-2">
                      xattr -cr /Applications/"Veri Masker.app"
                    </code>
                    komutunu çalıştırıp uygulamayı yeniden başlatın.
                  </li>
                  <li>
                    Yayımlamadan önce `scripts/notarize-ag-dmg.sh` betiğini çalıştırarak Apple Notary hizmetine gönderin ve DMG’yi \"staple\" edin.
                  </li>
                </ol>
                <p className="text-xs text-dark-500">
                  Boyut ~70&nbsp;MB (SwiftUI runtime). Dağıtım için DMG’yi Git LFS veya dış CDN üzerinden barındırmanız önerilir.
                </p>
              </div>
            </div>
          </motion.div>
        </div>
      </div>
    </section>
  );
};

export default DataMaskingApp;
