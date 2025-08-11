<template>
  <div class="about-page">
    <!-- 导航栏 -->
    <AppHeader />

    <!-- 页面标题区域 -->
    <section class="page-hero">
      <div class="container">
        <div class="hero-content">
          <h1 class="page-title">关于我们</h1>
          <p class="page-subtitle">
            我们为更好的未来发明创造，致力于成为全球领先的美妆产品制造商
          </p>
        </div>
      </div>
    </section>

    <!-- 公司简介 -->
    <section class="company-intro">
      <div class="container">
        <div class="intro-layout">
          <div class="intro-content">
            <h2 class="section-title">企业概况</h2>
            <div class="intro-text">
              <p class="intro-description">
                珠海优美化妆品有限公司成立于2003年，是一家专业的化妆品ODM/OEM制造商。
                我们拥有20年的行业经验和先进的生产设备，为全球美妆品牌提供高质量的产品制造和研发服务。
              </p>
              <p class="intro-description">
                公司总部位于广东省珠海市高新区，拥有15000平方米的现代化生产基地，
                年产能达到5000万支/瓶。我们的产品远销全球30多个国家和地区，
                服务客户包括众多知名美妆品牌。
              </p>
            </div>
          </div>
          <div class="intro-media">
            <div class="intro-image">
              <div class="image-placeholder">
                <svg width="120" height="120" viewBox="0 0 120 120" fill="none">
                  <rect x="10" y="10" width="100" height="100" rx="8" stroke="currentColor" stroke-width="2"/>
                  <circle cx="35" cy="35" r="8" fill="currentColor"/>
                  <path d="M10 80L30 60L50 80L80 50L110 80V110H10V80Z" fill="currentColor"/>
                </svg>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 发展历程 -->
    <section class="company-history">
      <div class="container">
        <div class="section-header">
          <h2 class="section-title">发展历程</h2>
          <p class="section-subtitle">二十年专注，见证美妆行业变迁</p>
        </div>

        <div class="timeline">
          <div class="timeline-item">
            <div class="timeline-year">2003</div>
            <div class="timeline-content">
              <h3 class="timeline-title">公司成立</h3>
              <p class="timeline-desc">珠海优美化妆品有限公司在珠海成立，开始专注美妆产品代工服务</p>
            </div>
          </div>

          <div class="timeline-item">
            <div class="timeline-year">2008</div>
            <div class="timeline-content">
              <h3 class="timeline-title">扩大规模</h3>
              <p class="timeline-desc">投资建设新生产基地，产能提升至1000万支/年</p>
            </div>
          </div>

          <div class="timeline-item">
            <div class="timeline-year">2012</div>
            <div class="timeline-content">
              <h3 class="timeline-title">技术升级</h3>
              <p class="timeline-desc">引进国际先进生产设备，获得ISO9001认证</p>
            </div>
          </div>

          <div class="timeline-item">
            <div class="timeline-year">2016</div>
            <div class="timeline-content">
              <h3 class="timeline-title">全球布局</h3>
              <p class="timeline-desc">产品出口至30多个国家，成为国际知名品牌供应商</p>
            </div>
          </div>

          <div class="timeline-item">
            <div class="timeline-year">2020</div>
            <div class="timeline-content">
              <h3 class="timeline-title">创新发展</h3>
              <p class="timeline-desc">投入重资建设研发中心，年产能达到5000万支</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 企业文化 -->
    <section class="company-culture">
      <div class="container">
        <div class="culture-layout">
          <div class="culture-content">
            <h2 class="section-title">企业文化</h2>
            <div class="culture-values">
              <div class="value-card">
                <div class="value-icon">
                  <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                    <path d="M16 2L4 8V16C4 24 16 28 16 28C16 28 28 24 28 16V8L16 2Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
                    <path d="M12 16L14 18L20 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </div>
                <h3 class="value-title">品质为先</h3>
                <p class="value-desc">
                  坚持以品质为核心，建立完善的质量管理体系，
                  确保每一件产品都达到国际标准。
                </p>
              </div>

              <div class="value-card">
                <div class="value-icon">
                  <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                    <path d="M16 14C18.2091 14 20 12.2091 20 10C20 7.79086 18.2091 6 16 6C13.7909 6 12 7.79086 12 10C12 12.2091 13.7909 14 16 14Z" stroke="currentColor" stroke-width="2"/>
                    <path d="M6 26V24C6 20.6863 8.68629 18 12 18H20C23.3137 18 26 20.6863 26 24V26" stroke="currentColor" stroke-width="2"/>
                  </svg>
                </div>
                <h3 class="value-title">尊重他人</h3>
                <p class="value-desc">
                  尊重每一位员工和合作伙伴，营造多元化和包容性的工作环境，
                  共同创造价值。
                </p>
              </div>

              <div class="value-card">
                <div class="value-icon">
                  <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                    <path d="M16 28C22.6274 28 28 22.6274 28 16C28 9.37258 22.6274 4 16 4C9.37258 4 4 9.37258 4 16C4 22.6274 9.37258 28 16 28Z" stroke="currentColor" stroke-width="2"/>
                    <path d="M12 16L14 18L20 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </div>
                <h3 class="value-title">诚德与诚信</h3>
                <p class="value-desc">
                  诚实守信是我们业务运营的基础，
                  也是我们与客户建立长期关系的根本。
                </p>
              </div>

              <div class="value-card">
                <div class="value-icon">
                  <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                    <path d="M28 14H18C16.8954 14 16 14.8954 16 16V28C16 29.1046 16.8954 30 18 30H28C29.1046 30 30 29.1046 30 28V16C30 14.8954 29.1046 14 28 14Z" stroke="currentColor" stroke-width="2"/>
                    <path d="M12 10V8C12 5.79086 13.7909 4 16 4C18.2091 4 20 5.79086 20 8V10" stroke="currentColor" stroke-width="2"/>
                    <path d="M8 10H12H16H20H24C25.1046 10 26 10.8954 26 12V14H6V12C6 10.8954 6.89543 10 8 10Z" stroke="currentColor" stroke-width="2"/>
                  </svg>
                </div>
                <h3 class="value-title">创新和科研卓越</h3>
                <p class="value-desc">
                  持续的创新和科研投入，
                  确保我们始终走在美妆科技的前沿。
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 生产能力 -->
    <section class="production-capability">
      <div class="container">
        <div class="capability-layout">
          <div class="capability-media">
            <div class="capability-image">
              <div class="image-placeholder">
                <svg width="120" height="120" viewBox="0 0 120 120" fill="none">
                  <rect x="20" y="30" width="80" height="60" rx="4" stroke="currentColor" stroke-width="2"/>
                  <path d="M30 40H90" stroke="currentColor" stroke-width="2"/>
                  <path d="M30 50H90" stroke="currentColor" stroke-width="2"/>
                  <path d="M30 60H90" stroke="currentColor" stroke-width="2"/>
                  <path d="M30 70H90" stroke="currentColor" stroke-width="2"/>
                  <circle cx="35" cy="20" r="8" stroke="currentColor" stroke-width="2"/>
                  <path d="M35 12V28" stroke="currentColor" stroke-width="2"/>
                  <path d="M27 20H43" stroke="currentColor" stroke-width="2"/>
                </svg>
              </div>
            </div>
          </div>

          <div class="capability-content">
            <h2 class="section-title">生产能力</h2>
            <p class="section-subtitle">
              先进的设备，严格的管控，确保产品质量稳定可靠
            </p>

            <div class="capability-stats">
              <div class="stat-item">
                <div class="stat-number">15000</div>
                <div class="stat-unit">平方米</div>
                <div class="stat-label">生产面积</div>
              </div>

              <div class="stat-item">
                <div class="stat-number">5000万</div>
                <div class="stat-unit">支/年</div>
                <div class="stat-label">年产能</div>
              </div>

              <div class="stat-item">
                <div class="stat-number">200+</div>
                <div class="stat-unit">人</div>
                <div class="stat-label">专业团队</div>
              </div>

              <div class="stat-item">
                <div class="stat-number">30+</div>
                <div class="stat-unit">个</div>
                <div class="stat-label">出口国家</div>
              </div>
            </div>

            <div class="capability-features">
              <div class="feature-item">
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                  <path d="M10 1L13 7L19 7L14.5 11L16 18L10 14L4 18L5.5 11L1 7L7 7L10 1Z" fill="currentColor"/>
                </svg>
                <span>10万级洁净车间</span>
              </div>
              <div class="feature-item">
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                  <path d="M10 1L13 7L19 7L14.5 11L16 18L10 14L4 18L5.5 11L1 7L7 7L10 1Z" fill="currentColor"/>
                </svg>
                <span>全自动化生产线</span>
              </div>
              <div class="feature-item">
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                  <path d="M10 1L13 7L19 7L14.5 11L16 18L10 14L4 18L5.5 11L1 7L7 7L10 1Z" fill="currentColor"/>
                </svg>
                <span>严格质量检测体系</span>
              </div>
              <div class="feature-item">
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                  <path d="M10 1L13 7L19 7L14.5 11L16 18L10 14L4 18L5.5 11L1 7L7 7L10 1Z" fill="currentColor"/>
                </svg>
                <span>国际认证标准</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 资质认证 */
    <section class="certifications">
      <div class="container">
        <div class="section-header">
          <h2 class="section-title">资质认证</h2>
          <p class="section-subtitle">专业认证，品质保证</p>
        </div>

        <div class="certifications-grid">
          <div class="cert-item">
            <div class="cert-icon">
              <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
                <circle cx="24" cy="24" r="20" stroke="currentColor" stroke-width="2"/>
                <path d="M16 24L20 28L32 16" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <h3 class="cert-title">ISO9001</h3>
            <p class="cert-desc">质量管理体系认证</p>
          </div>

          <div class="cert-item">
            <div class="cert-icon">
              <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
                <circle cx="24" cy="24" r="20" stroke="currentColor" stroke-width="2"/>
                <path d="M16 24L20 28L32 16" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <h3 class="cert-title">GMPC</h3>
            <p class="cert-desc">化妆品良好生产规范</p>
          </div>

          <div class="cert-item">
            <div class="cert-icon">
              <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
                <circle cx="24" cy="24" r="20" stroke="currentColor" stroke-width="2"/>
                <path d="M16 24L20 28L32 16" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <h3 class="cert-title">FDA</h3>
            <p class="cert-desc">美国食品药品管理局认证</p>
          </div>

          <div class="cert-item">
            <div class="cert-icon">
              <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
                <circle cx="24" cy="24" r="20" stroke="currentColor" stroke-width="2"/>
                <path d="M16 24L20 28L32 16" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <h3 class="cert-title">CE</h3>
            <p class="cert-desc">欧盟安全认证标志</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 页脚 -->
    <AppFooter />
  </div>
</template>

<script setup lang="ts">
import AppHeader from '@/components/AppHeader.vue'
import AppFooter from '@/components/AppFooter.vue'
</script>

<style scoped>
.about-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

/* 页面标题区域 */
.page-hero {
  padding: 120px 0 80px;
  background: linear-gradient(135deg, #d4af37 0%, #f4d03f 50%, #aa580f 100%);
  color: white;
  margin-top: 90px;
  position: relative;
}

.page-hero::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background:
    radial-gradient(circle at 20% 30%, rgba(255,255,255,0.3) 2%, transparent 3%),
    radial-gradient(circle at 80% 70%, rgba(255,255,255,0.2) 1%, transparent 2%),
    radial-gradient(circle at 60% 20%, rgba(255,255,255,0.1) 3%, transparent 4%);
  background-size: 100px 100px, 150px 150px, 80px 80px;
}

.hero-content {
  text-align: center;
  position: relative;
  z-index: 1;
}

.page-title {
  font-size: 48px;
  font-weight: 300;
  margin-bottom: 24px;
  line-height: 1.2;
}

.page-subtitle {
  font-size: 20px;
  opacity: 0.9;
  max-width: 600px;
  margin: 0 auto;
  line-height: 1.5;
}

/* 公司简介 */
.company-intro {
  padding: 120px 0;
  background: var(--section-bg);
}

.intro-layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 80px;
  align-items: center;
}

.intro-content {
  max-width: 500px;
}

.section-title {
  font-size: 40px;
  font-weight: 300;
  color: var(--text-primary);
  margin-bottom: 32px;
  line-height: 1.2;
}

.intro-description {
  font-size: 16px;
  color: var(--text-secondary);
  line-height: 1.6;
  margin-bottom: 24px;
}

.intro-media {
  display: flex;
  justify-content: center;
}

.intro-image {
  width: 100%;
  max-width: 400px;
  height: 300px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: var(--shadow-lg);
}

.image-placeholder {
  width: 100%;
  height: 100%;
  background: var(--gray-bg);
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-muted);
}

/* 发展历程 */
.company-history {
  padding: 120px 0;
  background: var(--gray-bg);
}

.section-header {
  text-align: center;
  margin-bottom: 80px;
}

.section-subtitle {
  font-size: 18px;
  color: var(--text-secondary);
  margin-top: 16px;
}

.timeline {
  position: relative;
  max-width: 800px;
  margin: 0 auto;
}

.timeline::before {
  content: '';
  position: absolute;
  left: 50%;
  top: 0;
  bottom: 0;
  width: 2px;
  background: var(--primary-color);
  transform: translateX(-50%);
}

.timeline-item {
  position: relative;
  margin-bottom: 60px;
  display: flex;
  align-items: center;
  gap: 40px;
}

.timeline-item:nth-child(even) {
  flex-direction: row-reverse;
}

.timeline-year {
  flex-shrink: 0;
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: var(--primary-color);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  font-weight: 600;
  position: relative;
  z-index: 2;
}

.timeline-content {
  flex: 1;
  background: white;
  padding: 24px;
  border-radius: 8px;
  box-shadow: var(--shadow-sm);
}

.timeline-title {
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 8px;
}

.timeline-desc {
  font-size: 14px;
  color: var(--text-secondary);
  line-height: 1.5;
  margin: 0;
}

/* 企业文化 */
.company-culture {
  padding: 120px 0;
  background: var(--section-bg);
}

.culture-layout {
  text-align: center;
}

.culture-values {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 40px;
  margin-top: 60px;
}

.value-card {
  background: white;
  padding: 40px 32px;
  border-radius: 12px;
  box-shadow: var(--shadow-sm);
  transition: all 0.3s ease;
  text-align: center;
}

.value-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
}

.value-icon {
  width: 64px;
  height: 64px;
  border-radius: 16px;
  background: var(--primary-color);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 24px;
}

.value-title {
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 16px;
}

.value-desc {
  font-size: 14px;
  color: var(--text-secondary);
  line-height: 1.6;
  margin: 0;
}

/* 生产能力 */
.production-capability {
  padding: 120px 0;
  background: var(--gray-bg);
}

.capability-layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 80px;
  align-items: center;
}

.capability-image {
  width: 100%;
  height: 400px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: var(--shadow-lg);
}

.capability-stats {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 32px;
  margin: 40px 0;
}

.stat-item {
  text-align: center;
  padding: 24px;
  background: white;
  border-radius: 8px;
  box-shadow: var(--shadow-sm);
}

.stat-number {
  font-size: 32px;
  font-weight: 300;
  color: var(--primary-color);
  line-height: 1;
}

.stat-unit {
  font-size: 14px;
  color: var(--text-secondary);
  margin-bottom: 8px;
}

.stat-label {
  font-size: 12px;
  color: var(--text-muted);
}

.capability-features {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 14px;
  color: var(--text-secondary);
}

.feature-item svg {
  color: var(--primary-color);
}

/* 资质认证 */
.certifications {
  padding: 120px 0;
  background: var(--section-bg);
}

.certifications-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 40px;
  margin-top: 60px;
}

.cert-item {
  text-align: center;
  padding: 40px 24px;
  background: white;
  border-radius: 12px;
  box-shadow: var(--shadow-sm);
  transition: all 0.3s ease;
}

.cert-item:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
}

.cert-icon {
  color: var(--primary-color);
  margin-bottom: 24px;
}

.cert-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 8px;
}

.cert-desc {
  font-size: 14px;
  color: var(--text-secondary);
  margin: 0;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .page-title {
    font-size: 40px;
  }

  .intro-layout,
  .capability-layout {
    gap: 60px;
  }

  .culture-values {
    gap: 30px;
  }

  .capability-stats {
    gap: 24px;
  }

  .certifications-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 30px;
  }
}

@media (max-width: 768px) {
  .page-hero {
    padding: 100px 0 60px;
  }

  .page-title {
    font-size: 32px;
  }

  .company-intro,
  .company-history,
  .company-culture,
  .production-capability,
  .certifications {
    padding: 80px 0;
  }

  .intro-layout,
  .capability-layout {
    grid-template-columns: 1fr;
    gap: 40px;
  }

  .timeline::before {
    left: 40px;
  }

  .timeline-item {
    margin-left: 80px;
    gap: 20px;
  }

  .timeline-item:nth-child(even) {
    flex-direction: row;
  }

  .timeline-year {
    width: 60px;
    height: 60px;
    font-size: 16px;
    position: absolute;
    left: -70px;
  }

  .culture-values {
    grid-template-columns: 1fr;
    gap: 24px;
  }

  .capability-stats {
    grid-template-columns: 1fr;
  }

  .capability-features {
    grid-template-columns: 1fr;
  }

  .certifications-grid {
    grid-template-columns: 1fr;
    gap: 24px;
  }
}

@media (max-width: 480px) {
  .page-title {
    font-size: 28px;
  }

  .section-title {
    font-size: 32px;
  }

  .timeline-item {
    margin-left: 60px;
  }

  .timeline-year {
    width: 50px;
    height: 50px;
    font-size: 14px;
    left: -60px;
  }

  .value-card {
    padding: 32px 24px;
  }

  .cert-item {
    padding: 32px 20px;
  }
}
</style>
