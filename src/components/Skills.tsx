import { useRef, useState } from 'react';
import type { CSSProperties } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
  ChevronLeft,
  ChevronRight,
  Code2,
  Layers,
  Database as DatabaseIcon,
  Cog,
  PlugZap,
  MonitorSmartphone,
  UsersRound,
  type LucideIcon,
} from 'lucide-react';
import TechRadar from './TechRadar';
import TechIcon from './TechIcon';

type SkillCategoryKey =
  | 'languages'
  | 'frameworks'
  | 'database'
  | 'devops'
  | 'webapi'
  | 'desktop'
  | 'soft';

type SkillCategoryConfig = {
  title: string;
  skills: string[];
  icon: LucideIcon;
};

const skillCategories: Record<SkillCategoryKey, SkillCategoryConfig> = {
  languages: {
    title: 'Programlama Dilleri',
    skills: ['Java', 'PHP', 'JavaScript', 'TypeScript', 'SQL', 'HTML', 'CSS', 'Python', 'C#', 'PL/SQL'],
    icon: Code2,
  },
  frameworks: {
    title: 'Framework & Tools',
    skills: ['Spring Boot', 'Magento', 'React', 'Node.js', 'Express.js', 'Vue.js', 'TailwindCSS'],
    icon: Layers,
  },
  database: {
    title: 'Veritabanı',
    skills: ['PostgreSQL', 'MySQL', 'MongoDB', 'Redis'],
    icon: DatabaseIcon,
  },
  devops: {
    title: 'DevOps & Tools',
    skills: ['Docker', 'Git', 'Jira', 'CI/CD', 'AWS', 'Azure'],
    icon: Cog,
  },
  webapi: {
    title: 'Web & API',
    skills: ['RESTful API', 'Web Services', 'JWT Authentication', 'Microservices', 'GraphQL'],
    icon: PlugZap,
  },
  desktop: {
    title: 'Desktop & Other',
    skills: ['Delphi', 'Raspberry Pi', 'Unit Testing', 'Clean Code', 'Agile'],
    icon: MonitorSmartphone,
  },
  soft: {
    title: 'Soft Skills',
    skills: ['Problem Solving', 'Teamwork', 'Adaptability', 'Continuous Learning', 'Technical Support'],
    icon: UsersRound,
  },
};

const tabs = Object.keys(skillCategories) as SkillCategoryKey[];

const Skills = () => {
  const [activeTab, setActiveTab] = useState<SkillCategoryKey>('languages');
  const tabListRef = useRef<HTMLDivElement>(null);

  const activeCategory = skillCategories[activeTab];
  const marqueeDuration = Math.max(activeCategory.skills.length * 2.5, 18);
  const marqueeStyle: CSSProperties = {
    ['--marquee-duration' as string]: `${marqueeDuration}s`,
  };

  const scrollTabs = (direction: 'left' | 'right') => {
    if (!tabListRef.current) return;
    const amount = direction === 'left' ? -240 : 240;
    tabListRef.current.scrollBy({ left: amount, behavior: 'smooth' });
  };

  return (
    <section id="skills" className="py-20 lg:py-32 bg-dark-900/30">
      <div className="container-custom">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="text-center mb-16"
        >
          <p className="text-primary-400 font-semibold mb-4 uppercase tracking-wider">
            Teknik Yığın
          </p>
          <h2 className="section-title mb-4">
            Üretimde sık kullandığım araçlar
          </h2>
        </motion.div>

        {/* Tab Buttons */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="relative flex items-center gap-3 mb-12"
        >
          <button
            type="button"
            onClick={() => scrollTabs('left')}
            className="hidden sm:flex items-center justify-center p-2 glass-card rounded-full hover:border-primary-500/50 transition-colors"
            aria-label="Önceki kategori"
          >
            <ChevronLeft className="w-5 h-5" />
          </button>

          <div className="flex-1 overflow-hidden">
            <div
              ref={tabListRef}
              className="flex gap-3 overflow-x-auto no-scrollbar scroll-smooth pb-2"
            >
              {tabs.map((tab) => (
                <button
                  key={tab}
                  onClick={() => setActiveTab(tab)}
                  className={`px-6 py-3 rounded-full font-semibold transition-all duration-300 whitespace-nowrap ${
                    activeTab === tab
                      ? 'bg-gradient-to-r from-primary-500 to-primary-600 text-white shadow-md shadow-primary-500/30 border border-transparent'
                      : 'glass-card hover:bg-dark-800/70'
                  }`}
                >
                  {skillCategories[tab].title}
                </button>
              ))}
            </div>
          </div>

          <button
            type="button"
            onClick={() => scrollTabs('right')}
            className="hidden sm:flex items-center justify-center p-2 glass-card rounded-full hover:border-primary-500/50 transition-colors"
            aria-label="Sonraki kategori"
          >
            <ChevronRight className="w-5 h-5" />
          </button>
        </motion.div>

        {/* Skills Display */}
        <AnimatePresence mode="wait">
          <motion.div
            key={activeTab}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
            transition={{ duration: 0.3 }}
            className="glass-card p-8 lg:p-12"
          >
            <div className="flex items-center justify-center gap-3 mb-8">
              <activeCategory.icon className="w-6 h-6 text-primary-400" aria-hidden="true" />
              <h3 className="text-2xl font-bold text-center gradient-text">
                {activeCategory.title}
              </h3>
            </div>
            <div className="relative overflow-hidden -mx-4 sm:mx-0">
              <div className="marquee-track gap-4" style={marqueeStyle} aria-live="polite">
                {[0, 1].map((loopIndex) => (
                  <div className="flex gap-4 pr-4" key={`${activeTab}-loop-${loopIndex}`}>
                    {activeCategory.skills.map((skill) => (
                      <div
                        key={`${skill}-${loopIndex}`}
                        className="px-5 py-3 bg-dark-800/50 border border-dark-700 rounded-full text-dark-200 font-medium hover:border-primary-500/50 hover:bg-dark-700/50 transition-all duration-300 flex items-center gap-2 pulse-hover whitespace-nowrap"
                      >
                        <TechIcon name={skill} className="w-5 h-5" />
                        <span>{skill}</span>
                      </div>
                    ))}
                  </div>
                ))}
              </div>
            </div>
          </motion.div>
        </AnimatePresence>

        <div className="mt-12">
          <TechRadar />
        </div>
      </div>
    </section>
  );
};

export default Skills;
