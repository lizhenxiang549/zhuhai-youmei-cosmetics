<template>
  <section class="about-section">
    <div class="container">
      <div class="about-layout">
        <!-- 文字内容 -->
        <div class="about-content">
          <h2 class="section-title">{{ about.title }}</h2>
          <p class="about-subtitle">{{ about.subtitle }}</p>
          <div class="about-text">
            <p class="about-description">{{ about.content }}</p>
          </div>

          <div class="about-actions">
            <router-link
              v-if="about.button_link"
              :to="about.button_link"
              class="btn btn-primary"
            >
              {{ about.button_text }}
            </router-link>
            <router-link
              v-else
              to="/about"
              class="btn btn-primary"
            >
              {{ about.button_text }}
            </router-link>
          </div>
        </div>

        <!-- 图片内容 -->
        <div class="about-media">
          <div class="media-wrapper">
            <img
              v-if="about.image"
              :src="about.image"
              :alt="about.title"
              class="about-image"
            />
            <div v-else class="image-placeholder">
              <svg width="120" height="120" viewBox="0 0 120 120" fill="none">
                <rect x="10" y="10" width="100" height="100" rx="8" stroke="currentColor" stroke-width="2"/>
                <circle cx="35" cy="35" r="8" fill="currentColor"/>
                <path d="M10 80L30 60L50 80L80 50L110 80V110H10V80Z" fill="currentColor"/>
              </svg>
            </div>
          </div>

          <!-- 装饰元素 -->
          <div class="decorative-elements">
            <div class="element element-1"></div>
            <div class="element element-2"></div>
            <div class="element element-3"></div>
          </div>
        </div>
      </div>

      <!-- 统计数据区域 -->
      <div class="stats-section">
        <div class="stats-grid">
          <div class="stat-item">
            <div class="stat-number">20+</div>
            <div class="stat-label">年行业经验</div>
          </div>
          <div class="stat-item">
            <div class="stat-number">200+</div>
            <div class="stat-label">专业员工</div>
          </div>
          <div class="stat-item">
            <div class="stat-number">15000</div>
            <div class="stat-label">平方米厂房</div>
          </div>
          <div class="stat-item">
            <div class="stat-number">5000万</div>
            <div class="stat-label">年产能（支/瓶）</div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import type { AboutSection } from '@/types'

interface Props {
  about: AboutSection
}

const props = defineProps<Props>()
</script>

<style scoped>
.about-section {
  padding: 120px 0;
  background: var(--section-bg);
}

/* 主要布局 */
.about-layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 80px;
  align-items: center;
  margin-bottom: 120px;
}

/* 文字内容 */
.about-content {
  max-width: 500px;
}

.section-title {
  font-size: 48px;
  font-weight: 300;
  color: var(--text-primary);
  margin-bottom: 24px;
  line-height: 1.2;
}

.about-subtitle {
  font-size: 24px;
  font-weight: 400;
  color: var(--primary-color);
  margin-bottom: 32px;
  line-height: 1.3;
}

.about-text {
  margin-bottom: 40px;
}

.about-description {
  font-size: 18px;
  color: var(--text-secondary);
  line-height: 1.6;
  margin-bottom: 24px;
}

.about-actions .btn {
  padding: 16px 32px;
  font-size: 16px;
  font-weight: 500;
}

/* 图片内容 */
.about-media {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
}

.media-wrapper {
  position: relative;
  width: 100%;
  max-width: 450px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: var(--shadow-lg);
}

.about-image {
  width: 100%;
  height: auto;
  display: block;
}

.image-placeholder {
  width: 100%;
  height: 300px;
  background: var(--gray-bg);
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-muted);
}

/* 装饰元素 */
.decorative-elements {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
}

.element {
  position: absolute;
  border-radius: 50%;
  background: var(--primary-color);
  opacity: 0.1;
}

.element-1 {
  width: 80px;
  height: 80px;
  top: -40px;
  right: -40px;
  background: var(--primary-color);
}

.element-2 {
  width: 60px;
  height: 60px;
  bottom: -30px;
  left: -30px;
  background: var(--secondary-color);
}

.element-3 {
  width: 40px;
  height: 40px;
  top: 50%;
  right: -20px;
  background: var(--accent-color);
}

/* 统计数据区域 */
.stats-section {
  padding: 60px 0;
  background: var(--gray-bg);
  border-radius: 16px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 40px;
}

.stat-item {
  text-align: center;
  padding: 20px;
  transition: transform 0.3s ease;
}

.stat-item:hover {
  transform: translateY(-4px);
}

.stat-number {
  font-size: 48px;
  font-weight: 300;
  color: var(--primary-color);
  margin-bottom: 12px;
  line-height: 1;
}

.stat-label {
  font-size: 16px;
  color: var(--text-secondary);
  font-weight: 500;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .about-section {
    padding: 100px 0;
  }

  .about-layout {
    gap: 60px;
    margin-bottom: 100px;
  }

  .section-title {
    font-size: 40px;
  }

  .about-subtitle {
    font-size: 20px;
  }

  .about-description {
    font-size: 16px;
  }

  .stat-number {
    font-size: 40px;
  }

  .stat-label {
    font-size: 14px;
  }
}

@media (max-width: 768px) {
  .about-section {
    padding: 80px 0;
  }

  .about-layout {
    grid-template-columns: 1fr;
    gap: 40px;
    margin-bottom: 80px;
    text-align: center;
  }

  .about-content {
    max-width: none;
  }

  .section-title {
    font-size: 32px;
  }

  .about-subtitle {
    font-size: 18px;
  }

  .about-description {
    font-size: 14px;
  }

  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 30px;
  }

  .stat-number {
    font-size: 32px;
  }

  .stat-label {
    font-size: 12px;
  }
}

@media (max-width: 480px) {
  .about-section {
    padding: 60px 0;
  }

  .about-layout {
    gap: 32px;
    margin-bottom: 60px;
  }

  .section-title {
    font-size: 28px;
  }

  .about-subtitle {
    font-size: 16px;
  }

  .stats-grid {
    grid-template-columns: 1fr;
    gap: 24px;
  }

  .stat-item {
    padding: 16px;
  }

  .stat-number {
    font-size: 28px;
  }

  .stat-label {
    font-size: 12px;
  }
}
</style>
