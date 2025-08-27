<template>
  <div class="services-page">
    <!-- 导航栏 -->
    <AppHeader />

    <!-- 页面标题区域 -->
    <section class="page-hero">
      <div class="container">
        <div class="hero-content">
          <h1 class="page-title">服务范围</h1>
          <p class="page-subtitle">
            专业的ODM/OEM服务，从产品开发到生产制造的全方位解决方案
          </p>
        </div>
      </div>
    </section>

    <!-- 服务概览 -->
    <section class="services-overview">
      <div class="container">
        <div class="overview-content">
          <h2 class="section-title">全方位服务体系</h2>
          <p class="section-subtitle">
            我们提供从配方研发、产品设计、生产制造到质量控制的一站式服务，
            帮助客户实现从概念到成品的完整产品开发周期。
          </p>

          <div class="service-flow">
            <div class="flow-step">
              <div class="step-number">01</div>
              <h3 class="step-title">需求分析</h3>
              <p class="step-desc">深入了解客户需求和市场定位</p>
            </div>
            <div class="flow-arrow">→</div>

            <div class="flow-step">
              <div class="step-number">02</div>
              <h3 class="step-title">方案设计</h3>
              <p class="step-desc">制定专业的产品开发方案</p>
            </div>
            <div class="flow-arrow">→</div>

            <div class="flow-step">
              <div class="step-number">03</div>
              <h3 class="step-title">样品制作</h3>
              <p class="step-desc">快速制作产品样品供确认</p>
            </div>
            <div class="flow-arrow">→</div>

            <div class="flow-step">
              <div class="step-number">04</div>
              <h3 class="step-title">批量生产</h3>
              <p class="step-desc">严格质控，按时交付成品</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 服务详情 -->
    <section class="services-detail">
      <div class="container">
        <div v-if="loading" class="loading-state">
          <div class="loading-spinner"></div>
          <p>加载中...</p>
        </div>

        <div v-else-if="error" class="error-state">
          <p>{{ error }}</p>
          <button @click="loadServices" class="btn btn-primary">重试</button>
        </div>

        <div v-else class="services-grid">
          <div
            v-for="service in services"
            :key="service.id"
            class="service-card"
          >
            <div class="service-header">
              <div class="service-icon">
                <svg v-if="service.title.includes('ODM')" width="48" height="48" viewBox="0 0 48 48" fill="none">
                  <path d="M24 4L40 12V28C40 36 24 44 24 44C24 44 8 36 8 28V12L24 4Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
                  <path d="M18 24L22 28L30 20" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                <svg v-else-if="service.title.includes('OEM')" width="48" height="48" viewBox="0 0 48 48" fill="none">
                  <rect x="6" y="10" width="36" height="28" rx="4" stroke="currentColor" stroke-width="2"/>
                  <path d="M14 18H34" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                  <path d="M14 24H34" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                  <path d="M14 30H28" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                </svg>
                <svg v-else-if="service.title.includes('研发')" width="48" height="48" viewBox="0 0 48 48" fill="none">
                  <circle cx="24" cy="24" r="20" stroke="currentColor" stroke-width="2"/>
                  <path d="M24 8V24L32 32" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                <svg v-else width="48" height="48" viewBox="0 0 48 48" fill="none">
                  <rect x="8" y="8" width="32" height="32" rx="4" stroke="currentColor" stroke-width="2"/>
                  <circle cx="20" cy="20" r="4" fill="currentColor"/>
                  <path d="M8 32L16 24L24 32L32 24L40 32V40H8V32Z" fill="currentColor"/>
                </svg>
              </div>
              <h3 class="service-title">{{ service.title }}</h3>
            </div>

            <div class="service-content">
              <p class="service-description">{{ service.description }}</p>

              <div v-if="service.features?.length" class="service-features">
                <h4 class="features-title">服务特点</h4>
                <ul class="features-list">
                  <li v-for="feature in service.features" :key="feature" class="feature-item">
                    <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                      <path d="M13.5 4.5L6 12L2.5 8.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    {{ feature }}
                  </li>
                </ul>
              </div>

              <div v-if="service.process_steps?.length" class="service-process">
                <h4 class="process-title">服务流程</h4>
                <div class="process-steps">
                  <div
                    v-for="(step, index) in service.process_steps"
                    :key="index"
                    class="process-step"
                  >
                    <div class="process-number">{{ index + 1 }}</div>
                    <span class="process-text">{{ step }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 服务优势 -->
    <section class="service-advantages">
      <div class="container">
        <div class="section-header">
          <h2 class="section-title">为什么选择我们</h2>
          <p class="section-subtitle">专业实力，值得信赖</p>
        </div>

        <div class="advantages-grid">
          <div class="advantage-item">
            <div class="advantage-icon">
              <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                <path d="M16 2L4 8V16C4 24 16 28 16 28C16 28 28 24 28 16V8L16 2Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
                <path d="M12 16L14 18L20 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <h3 class="advantage-title">20年经验</h3>
            <p class="advantage-desc">
              深耕美妆代工行业20年，积累了丰富的生产经验和技术实力
            </p>
          </div>

          <div class="advantage-item">
            <div class="advantage-icon">
              <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                <circle cx="16" cy="16" r="12" stroke="currentColor" stroke-width="2"/>
                <path d="M16 8V16L20 20" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <h3 class="advantage-title">快速交付</h3>
            <p class="advantage-desc">
              高效的生产流程和完善的供应链体系，确保按时交付
            </p>
          </div>

          <div class="advantage-item">
            <div class="advantage-icon">
              <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                <rect x="4" y="4" width="24" height="24" rx="4" stroke="currentColor" stroke-width="2"/>
                <path d="M12 16L14 18L20 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <h3 class="advantage-title">质量保证</h3>
            <p class="advantage-desc">
              严格的质量管理体系，多项国际认证，确保产品质量
            </p>
          </div>

          <div class="advantage-item">
            <div class="advantage-icon">
              <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                <path d="M16 28C22.6274 28 28 22.6274 28 16C28 9.37258 22.6274 4 16 4C9.37258 4 4 9.37258 4 16C4 22.6274 9.37258 28 16 28Z" stroke="currentColor" stroke-width="2"/>
                <path d="M10 16L14 20L22 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <h3 class="advantage-title">全球服务</h3>
            <p class="advantage-desc">
              产品远销30多个国家，为全球客户提供专业服务
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- 联系咨询 -->
    <section class="contact-cta">
      <div class="container">
        <div class="cta-content">
          <h2 class="cta-title">开始您的项目</h2>
          <p class="cta-subtitle">
            联系我们的专业团队，获取定制化的解决方案
          </p>
          <div class="cta-actions">
            <router-link to="/contact" class="btn btn-primary">
              立即咨询
            </router-link>
            <a href="tel:400-888-9999" class="btn btn-outline">
              电话咨询
            </a>
          </div>
        </div>
      </div>
    </section>

    <!-- 页脚 -->
    <AppFooter />
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useServiceStore } from '@/stores'
import { storeToRefs } from 'pinia'

// 组件导入
import AppHeader from '@/components/AppHeader.vue'
import AppFooter from '@/components/AppFooter.vue'

// 状态管理
const serviceStore = useServiceStore()
const { services, loading, error } = storeToRefs(serviceStore)

// 方法
const loadServices = async () => {
  await serviceStore.getServices()
}

// 初始化
onMounted(async () => {
  await loadServices()
})
</script>

<style scoped>
.services-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

/* 页面标题区域 */
.page-hero {
  padding: 120px 0 80px;
  background: linear-gradient(135deg, #000000 0%, #2a2a2a 50%, #000000 100%);
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

/* 服务概览 */
.services-overview {
  padding: 120px 0;
  background: var(--section-bg);
}

.overview-content {
  text-align: center;
}

.section-title {
  font-size: 40px;
  font-weight: 300;
  color: var(--text-primary);
  margin-bottom: 24px;
  line-height: 1.2;
}

.section-subtitle {
  font-size: 18px;
  color: var(--text-secondary);
  line-height: 1.6;
  max-width: 800px;
  margin: 0 auto 60px;
}

/* 服务流程 */
.service-flow {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 32px;
  margin-top: 60px;
}

.flow-step {
  text-align: center;
  max-width: 180px;
}

.step-number {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  background: var(--primary-color);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  font-weight: 600;
  margin: 0 auto 16px;
}

.step-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 8px;
}

.step-desc {
  font-size: 14px;
  color: var(--text-secondary);
  line-height: 1.4;
  margin: 0;
}

.flow-arrow {
  font-size: 24px;
  color: var(--primary-color);
  font-weight: bold;
}

/* 服务详情 */
.services-detail {
  padding: 120px 0;
  background: var(--gray-bg);
  flex: 1;
}

/* 状态显示 */
.loading-state,
.error-state {
  text-align: center;
  padding: 80px 20px;
  color: var(--text-secondary);
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 3px solid var(--border-color);
  border-top: 3px solid var(--primary-color);
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 16px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* 服务卡片网格 */
.services-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: 40px;
}

.service-card {
  background: white;
  border-radius: 16px;
  padding: 40px;
  box-shadow: var(--shadow-sm);
  transition: all 0.3s ease;
}

.service-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
}

.service-header {
  text-align: center;
  margin-bottom: 32px;
}

.service-icon {
  width: 80px;
  height: 80px;
  border-radius: 20px;
  background: var(--primary-color);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 24px;
}

.service-title {
  font-size: 24px;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0;
}

.service-content {
  text-align: left;
}

.service-description {
  font-size: 16px;
  color: var(--text-secondary);
  line-height: 1.6;
  margin-bottom: 32px;
}

/* 服务特点 */
.service-features {
  margin-bottom: 32px;
}

.features-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 16px;
}

.features-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
  font-size: 14px;
  color: var(--text-secondary);
}

.feature-item svg {
  color: var(--primary-color);
  flex-shrink: 0;
}

/* 服务流程 */
.service-process {
  margin-bottom: 32px;
}

.process-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 16px;
}

.process-steps {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.process-step {
  display: flex;
  align-items: center;
  gap: 12px;
}

.process-number {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: var(--primary-color);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 600;
  flex-shrink: 0;
}

.process-text {
  font-size: 14px;
  color: var(--text-secondary);
}

/* 服务优势 */
.service-advantages {
  padding: 120px 0;
  background: var(--section-bg);
}

.section-header {
  text-align: center;
  margin-bottom: 80px;
}

.advantages-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 40px;
}

.advantage-item {
  text-align: center;
  padding: 40px 24px;
  background: white;
  border-radius: 12px;
  box-shadow: var(--shadow-sm);
  transition: all 0.3s ease;
}

.advantage-item:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
}

.advantage-icon {
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

.advantage-title {
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 16px;
}

.advantage-desc {
  font-size: 14px;
  color: var(--text-secondary);
  line-height: 1.6;
  margin: 0;
}

/* 联系咨询 */
.contact-cta {
  padding: 120px 0;
  background: var(--primary-color);
  color: white;
}

.cta-content {
  text-align: center;
}

.cta-title {
  font-size: 40px;
  font-weight: 300;
  margin-bottom: 24px;
  line-height: 1.2;
}

.cta-subtitle {
  font-size: 18px;
  opacity: 0.9;
  margin-bottom: 40px;
  line-height: 1.5;
}

.cta-actions {
  display: flex;
  justify-content: center;
  gap: 24px;
}

.cta-actions .btn {
  padding: 16px 32px;
  font-size: 16px;
  font-weight: 500;
}

.btn-outline {
  border-color: rgba(255, 255, 255, 0.5);
  color: white;
}

.btn-outline:hover {
  background: white;
  color: var(--primary-color);
  border-color: white;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .page-title {
    font-size: 40px;
  }

  .section-title {
    font-size: 36px;
  }

  .service-flow {
    flex-direction: column;
    gap: 24px;
  }

  .flow-arrow {
    transform: rotate(90deg);
  }

  .services-grid {
    grid-template-columns: 1fr;
    gap: 32px;
  }

  .advantages-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 32px;
  }
}

@media (max-width: 768px) {
  .page-hero {
    padding: 100px 0 60px;
  }

  .page-title {
    font-size: 32px;
  }

  .services-overview,
  .services-detail,
  .service-advantages,
  .contact-cta {
    padding: 80px 0;
  }

  .section-title {
    font-size: 32px;
  }

  .service-card {
    padding: 32px;
  }

  .service-icon {
    width: 64px;
    height: 64px;
  }

  .step-number {
    width: 48px;
    height: 48px;
    font-size: 18px;
  }

  .advantage-icon {
    width: 48px;
    height: 48px;
  }

  .advantages-grid {
    grid-template-columns: 1fr;
    gap: 24px;
  }

  .cta-actions {
    flex-direction: column;
    align-items: center;
  }

  .cta-actions .btn {
    width: 100%;
    max-width: 280px;
  }
}

@media (max-width: 480px) {
  .page-title {
    font-size: 28px;
  }

  .section-title {
    font-size: 28px;
  }

  .service-card {
    padding: 24px;
  }

  .advantage-item {
    padding: 32px 20px;
  }

  .cta-title {
    font-size: 32px;
  }
}
</style>
