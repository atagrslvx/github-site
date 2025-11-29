import { useState, type FormEvent } from 'react';
import { motion } from 'framer-motion';
import { Github, Linkedin, Mail, Heart, ArrowUp, Send } from 'lucide-react';

const Footer = () => {
  const scrollToTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const [status, setStatus] = useState<'idle' | 'loading' | 'success' | 'error'>('idle');
  const [errorText, setErrorText] = useState<string | null>(null);

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setStatus('loading');
    setErrorText(null);

    const form = event.currentTarget;
    const formData = new FormData(form);
    formData.append('_subject', 'Portfolio iletişim formu');

    try {
      const response = await fetch('https://formspree.io/f/xnnkygng', {
        method: 'POST',
        body: formData,
        headers: { Accept: 'application/json' },
      });

      if (!response.ok) {
        const data = await response.json().catch(() => ({}));
        throw new Error(data?.error || 'Form gönderilemedi');
      }

      form.reset();
      setStatus('success');
    } catch (error) {
      console.error(error);
      setErrorText(error instanceof Error ? error.message : 'Form gönderilemedi');
      setStatus('error');
    }

    setTimeout(() => setStatus('idle'), 3500);
  };

  return (
    <footer id="contact" className="relative py-16 bg-dark-900/50 border-t border-dark-800/50">
      <div className="container-custom">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="text-center space-y-8"
        >
          {/* Main Content */}
          <div className="space-y-4">
            <h2 className="text-3xl font-bold gradient-text">Bana Ulaş</h2>
            <p className="text-dark-300 max-w-2xl mx-auto">
              Yeni projeler, iş birlikleri veya sadece merhaba demek için iletişime geçmekten çekinmeyin.
            </p>
          </div>

          {/* Contact Form */}
          <div className="max-w-4xl mx-auto w-full">
            <div className="glass-card p-6 md:p-8 rounded-2xl border border-dark-800/60">
              <form onSubmit={handleSubmit} className="space-y-6" aria-live="polite">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <label htmlFor="name" className="text-sm text-dark-400">
                      Adınız
                    </label>
                    <input
                      id="name"
                      name="name"
                      type="text"
                      required
                      placeholder="Ad Soyad"
                      className="w-full rounded-xl bg-dark-900/70 border border-dark-700 px-4 py-3 text-dark-50 placeholder-dark-500 focus:outline-none focus:border-primary-500/60 focus:ring-2 focus:ring-primary-500/30 transition-colors"
                    />
                  </div>
                  <div className="space-y-2">
                    <label htmlFor="email" className="text-sm text-dark-400">
                      E-posta
                    </label>
                    <input
                      id="email"
                      name="email"
                      type="email"
                      required
                      placeholder="ornek@eposta.com"
                      className="w-full rounded-xl bg-dark-900/70 border border-dark-700 px-4 py-3 text-dark-50 placeholder-dark-500 focus:outline-none focus:border-primary-500/60 focus:ring-2 focus:ring-primary-500/30 transition-colors"
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <label htmlFor="subject" className="text-sm text-dark-400">
                    Konu
                  </label>
                  <input
                    id="subject"
                    name="subject"
                    type="text"
                    placeholder="Proje / iş birliği"
                    className="w-full rounded-xl bg-dark-900/70 border border-dark-700 px-4 py-3 text-dark-50 placeholder-dark-500 focus:outline-none focus:border-primary-500/60 focus:ring-2 focus:ring-primary-500/30 transition-colors"
                  />
                </div>

                <div className="space-y-2">
                  <label htmlFor="message" className="text-sm text-dark-400">
                    Mesajınız
                  </label>
                  <textarea
                    id="message"
                    name="message"
                    rows={4}
                    required
                    placeholder="Kısa bir özet paylaşın, aynı gün dönüş yaparım."
                    className="w-full rounded-xl bg-dark-900/70 border border-dark-700 px-4 py-3 text-dark-50 placeholder-dark-500 focus:outline-none focus:border-primary-500/60 focus:ring-2 focus:ring-primary-500/30 transition-colors resize-none"
                  />
                </div>

                <input type="text" name="_gotcha" className="hidden" aria-hidden="true" />

                <button
                  type="submit"
                  disabled={status === 'loading'}
                  className="btn-primary w-full justify-center flex items-center gap-2 disabled:opacity-70"
                >
                  <Send className="w-4 h-4" />
                  {status === 'loading' ? 'Gönderiliyor...' : 'Gönder'}
                </button>

                {status === 'success' && (
                  <div className="text-sm text-green-400 glass-card bg-dark-900/80 border border-green-500/40 px-4 py-3 rounded-xl">
                    Mesaj ulaştı, en kısa sürede dönüş yapacağım.
                  </div>
                )}
                {status === 'error' && (
                  <div className="text-sm text-amber-400 glass-card bg-dark-900/80 border border-amber-500/40 px-4 py-3 rounded-xl">
                    {errorText ?? 'Bir sorun oluştu, lütfen tekrar deneyin.'}
                  </div>
                )}
              </form>
            </div>
          </div>

          {/* Contact Links */}
          <div className="flex items-center justify-center gap-4 flex-wrap mt-8">
            <a
              href="tel:+905352188144"
              className="glass-card-hover px-6 py-3 flex items-center gap-2 text-dark-100 hover:text-primary-400"
            >
              <span className="font-medium">+90 535-218-81-44</span>
            </a>
            <a
              href="mailto:atagursel@yahoo.com"
              className="glass-card-hover px-6 py-3 flex items-center gap-2 text-dark-100 hover:text-primary-400"
            >
              <Mail className="w-5 h-5" />
              <span className="font-medium">atagursel@yahoo.com</span>
            </a>
            <a
              href="https://www.linkedin.com/in/atagursel/"
              target="_blank"
              rel="noopener noreferrer"
              className="glass-card-hover px-6 py-3 flex items-center gap-2 text-dark-100 hover:text-primary-400"
            >
              <Linkedin className="w-5 h-5" />
              <span className="font-medium">LinkedIn</span>
            </a>
            <a
              href="https://github.com/ATAGRSL"
              target="_blank"
              rel="noopener noreferrer"
              className="glass-card-hover px-6 py-3 flex items-center gap-2 text-dark-100 hover:text-primary-400"
            >
              <Github className="w-5 h-5" />
              <span className="font-medium">GitHub</span>
            </a>
          </div>

          {/* Divider */}
          <div className="flex items-center justify-center gap-3 my-8 text-primary-400/70">
            <span className="h-px w-16 bg-gradient-to-r from-transparent via-dark-700 to-primary-500/30" />
            <span className="w-2 h-2 rounded-full bg-primary-500/70 shadow-[0_0_18px_rgba(20,184,166,0.5)]" />
            <span className="h-px w-16 bg-gradient-to-l from-transparent via-dark-700 to-primary-500/30" />
          </div>

          {/* Bottom */}
          <div className="flex flex-col items-center justify-center gap-2 text-sm text-dark-500">
            <p className="flex items-center gap-2">
              © 2025 Ata Gürsel · Made with <Heart className="w-5 h-5 text-red-500 fill-current" />
            </p>
          </div>
        </motion.div>
      </div>

      {/* Scroll to Top Button */}
      <motion.button
        initial={{ opacity: 0, scale: 0.8 }}
        whileInView={{ opacity: 1, scale: 1 }}
        viewport={{ once: true }}
        onClick={scrollToTop}
        className="fixed bottom-6 left-6 md:left-10 p-4 glass-card-hover rounded-full shadow-lg shadow-primary-500/20 z-40 glow-hover"
        whileHover={{ y: -4 }}
        aria-label="Başa dön"
      >
        <ArrowUp className="w-5 h-5" />
      </motion.button>
    </footer>
  );
};

export default Footer;
