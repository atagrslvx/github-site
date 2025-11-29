import { useEffect, useMemo, useRef, useState, type FormEvent } from 'react';
import { MessageSquare, Send, Sparkles, X } from 'lucide-react';

type Message = {
  from: 'user' | 'bot';
  text: string;
};

const knowledgeBase = [
  {
    match: ['nerede', 'lokasyon', 'konum', 'istanbul', 'remote', 'hibrit'],
    reply:
      'İstanbul merkezli çalışıyorum; remote ve hibrit modellere açığım.',
  },
  {
    match: ['iletişim', 'mail', 'e-posta', 'email', 'telefon', 'iletişime geç'],
    reply:
      'Bana en hızlı mail veya telefonla ulaşabilirsin: atagursel@yahoo.com · +90 535 218 81 44 · LinkedIn: linkedin.com/in/atagursel.',
  },
  {
    match: ['deneyim', 'tecrübe', 'venhancer', 'qa', 'jr', 'software developer'],
    reply:
      'VENHANCER’da JR. Software Developer olarak Magento (PHP/JS) ve Spring Boot (Java, PostgreSQL, JWT) projelerinde çalıştım; öncesinde aynı şirkette QA stajı yaptım.',
  },
  {
    match: ['teknoloji', 'stack', 'yetenek', 'skills', 'hangi', 'kullanıyorsun'],
    reply:
      'Günlük stack: Java · PHP · JavaScript/TypeScript · React · Spring Boot · Magento · Tailwind · Docker · PostgreSQL/MySQL. DevOps: Git, Jira, CI/CD. Soft: problem çözme, ekip çalışması.',
  },
  {
    match: ['proje', 'github', 'repo', 'referans'],
    reply:
      'Projelerim GitHub’da listeleniyor (Showcase: baggage-tracker-desk, refactor-ai, marketpulse, vb.). Site içindeki “Projeler” bölümünden filtreleyebilirsin.',
  },
  {
    match: ['sertifika', 'cert', '146', 'google', 'aws', 'ibm', 'azure'],
    reply:
      '146+ doğrulanmış sertifika: Google Cybersecurity, IBM IT Support, AWS Cloud Solutions Architect, Azure Developer, ML & Data Analytics gibi seçkiler.',
  },
  {
    match: ['eğitim', 'üniversite', 'okul', 'toros', 'lisans', 'hazırlık'],
    reply:
      'Toros Üniversitesi Yazılım Mühendisliği (İngilizce, 2021-2024); öncesinde GAU hazırlık ve İzmir Ekonomi Ünv. Bilgisayar Programcılığı önlisans.',
  },
  {
    match: ['veri maskeleme', 'ag veri', 'swift', 'macos', 'dmg', 'mask', 'hash', 'redact'],
    reply:
      'AG Veri Maskeleme macOS uygulaması: SwiftUI native, 620 KB, 4 strateji (mask/hash/random/redact), CSV/JSON import/export, offline-first. İndirme: /veri-maskeleme sayfasındaki DMG linki.',
  },
  {
    match: ['aradığım', 'neden seni', 'neden', 'farkın', 'özellik'],
    reply:
      'Full-stack odaklıyım; e-ticaret ve fintech’te uçtan uca teslimat, temiz kod, performans, erişilebilirlik ve dokümantasyon önceliklerim. Yeni teknolojilere hızlı adapte olur, teslimat ve destek süreçlerinde aktif rol alırım.',
  },
];

const defaultReply =
  'Sorunu tam anlayamadım. İletişim: atagursel@yahoo.com · +90 535 218 81 44 · LinkedIn: linkedin.com/in/atagursel. Ayrıca “Projeler”, “Deneyim” ve “Yetenekler” bölümlerine bakabilirsin.';

function findAnswer(question: string): string {
  const normalized = question.toLowerCase();
  const hit = knowledgeBase.find((item) => item.match.some((kw) => normalized.includes(kw)));
  return hit?.reply ?? defaultReply;
}

const ProfileAssistant = () => {
  const [open, setOpen] = useState(false);
  const [input, setInput] = useState('');
  const [status, setStatus] = useState<'idle' | 'thinking'>('idle');
  const [messages, setMessages] = useState<Message[]>([
    {
      from: 'bot',
      text: 'Merhaba! Ben “AtaAI”. Profilimle ilgili merak ettiklerini sorabilirsin: teknoloji stack, deneyim, projeler, sertifikalar, iletişim.',
    },
  ]);
  const panelRef = useRef<HTMLDivElement>(null);

  const canSend = input.trim().length > 1 && status === 'idle';

  useEffect(() => {
    if (open) {
      requestAnimationFrame(() => {
        if (panelRef.current) {
          panelRef.current.scrollTop = panelRef.current.scrollHeight;
        }
      });
    }
  }, [messages, open]);

  const handleSend = (event: FormEvent) => {
    event.preventDefault();
    if (!canSend) return;

    const question = input.trim();
    setInput('');
    setStatus('thinking');
    setMessages((prev) => [...prev, { from: 'user', text: question }]);

    setTimeout(() => {
      const answer = findAnswer(question);
      setMessages((prev) => [...prev, { from: 'bot', text: answer }]);
      setStatus('idle');
    }, 200);
  };

  const suggestions = useMemo(
    () => [
      'Stack’in neler?',
      'Venhancer’da ne yaptın?',
      'AG Veri Maskeleme nedir?',
      'Sertifikaların var mı?',
      'Nasıl iletişime geçerim?',
    ],
    []
  );

  return (
    <>
      {!open && (
        <button
          onClick={() => setOpen(true)}
          className="fixed bottom-6 right-6 z-40 bg-primary-500 text-white p-4 rounded-full shadow-lg hover:bg-primary-600 transition-all duration-300 hover:scale-110 focus:outline-none focus:ring-2 focus:ring-primary-400"
          aria-label="Profil asistanını aç"
        >
          <MessageSquare className="w-5 h-5" />
        </button>
      )}

      {open && (
        <div className="fixed inset-0 z-40 bg-black/40 backdrop-blur-sm lg:bg-transparent lg:backdrop-blur-none" onClick={() => setOpen(false)} />
      )}

      <div
        className={`fixed bottom-6 right-6 z-50 w-full max-w-[360px] sm:max-w-[400px] h-[520px] glass-card border border-dark-800/70 rounded-2xl shadow-2xl flex flex-col transition-all duration-300 origin-bottom-right ${
          open ? 'opacity-100 scale-100' : 'opacity-0 scale-95 pointer-events-none'
        }`}
      >
        <div className="flex justify-between items-center p-4 border-b border-dark-800 bg-dark-900/70 rounded-t-2xl backdrop-blur">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-full bg-primary-500/20 flex items-center justify-center text-primary-200">
              <Sparkles className="w-5 h-5" />
            </div>
            <div>
              <h3 className="font-semibold text-dark-50 text-sm">AtaAI Asistan</h3>
              <p className="text-xs text-green-400 flex items-center gap-1">
                <span className="w-1.5 h-1.5 rounded-full bg-green-400 animate-pulse" />
                Çevrimiçi · Site verisine dayalı
              </p>
            </div>
          </div>
          <button
            onClick={() => setOpen(false)}
            className="text-dark-400 hover:text-dark-50 p-2 hover:bg-dark-800 rounded-full transition-colors"
            aria-label="Asistanı kapat"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        <div ref={panelRef} className="flex-1 overflow-y-auto p-4 space-y-3">
          {messages.map((message, index) => (
            <div
              key={`${message.from}-${index}-${message.text.slice(0, 8)}`}
              className={`flex ${message.from === 'user' ? 'justify-end' : 'justify-start'}`}
            >
              <div
                className={`max-w-[80%] p-3 rounded-2xl text-sm leading-relaxed ${
                  message.from === 'user'
                    ? 'bg-primary-500 text-white rounded-br-none'
                    : 'bg-dark-800 text-dark-100 border border-dark-700 rounded-bl-none'
                }`}
              >
                {message.text}
              </div>
            </div>
          ))}

          {status === 'thinking' && (
            <div className="flex justify-start">
              <div className="bg-dark-800 text-dark-100 border border-dark-700 rounded-2xl rounded-bl-none px-3 py-2 text-sm">
                Yazıyor...
              </div>
            </div>
          )}
        </div>

        <div className="p-4 border-t border-dark-800 bg-dark-900/70 rounded-b-2xl space-y-2">
          <form onSubmit={handleSend} className="relative">
            <input
              type="text"
              name="question"
              placeholder="Ata hakkında bir soru sor..."
              value={input}
              onChange={(e) => setInput(e.target.value)}
              className="w-full bg-dark-950/80 border border-dark-700 rounded-full py-3 pl-4 pr-12 text-sm text-dark-50 placeholder-dark-500 focus:outline-none focus:border-primary-500/60 focus:ring-2 focus:ring-primary-500/30 transition-colors"
            />
            <button
              type="submit"
              disabled={!canSend}
              className="absolute right-2 top-1/2 -translate-y-1/2 p-2 bg-primary-500 text-white rounded-full disabled:opacity-60 disabled:cursor-not-allowed hover:bg-primary-600 transition-colors"
              aria-label="Gönder"
            >
              <Send className="w-4 h-4" />
            </button>
          </form>
          <div className="flex flex-wrap gap-2">
            {suggestions.map((item) => (
              <button
                key={item}
                type="button"
                onClick={() => setInput(item)}
                className="px-3 py-1.5 text-xs rounded-full bg-dark-800 text-dark-300 border border-dark-700 hover:border-primary-500/50 transition-colors"
              >
                {item}
              </button>
            ))}
          </div>
          <p className="text-[10px] text-dark-500 text-center">Yanıtlar sitedeki bilgilerden derlenir; canlı API kullanmıyor.</p>
        </div>
      </div>
    </>
  );
};

export default ProfileAssistant;
