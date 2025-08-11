<template>
  <section class="research-section">
    <div class="container">
      <div class="research-layout">
        <!-- 图片内容（左侧） -->
        <div class="research-media">
          <div class="media-wrapper">
            <img
              v-if="research.image"
              :src="research.image"
              :alt="research.title"
              class="research-image"
            />
            <div v-else class="image-placeholder">
              <svg width="120" height="120" viewBox="0 0 120 120" fill="none">
                <circle cx="60" cy="60" r="50" stroke="currentColor" stroke-width="2"/>
                <path d="M40 60L50 70L80 40" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
          </div>

          <!-- 研发亮点卡片 -->
          <div class="research-highlights">
            <div class="highlight-card">
              <div class="highlight-icon">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                  <path d="M12 2L2 7L12 12L22 7L12 2Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
                  <path d="M2 17L12 22L22 17" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
                  <path d="M2 12L12 17L22 12" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
                </svg>
              </div>
              <div class="highlight-content">
                <h4 class="highlight-title">50+</h4>
                <p class="highlight-desc">专业研发人员</p>
              </div>
            </div>

            <div class="highlight-card">
              <div class="highlight-icon">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                  <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
                  <path d="M12 6V12L16 14" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <div class="highlight-content">
                <h4 class="highlight-title">8%</h4>
                <p class="highlight-desc">年研发投入占比</p>
              </div>
            </div>
          </div>
        </div>

        <!-- 文字内容（右侧） -->
        <div class="research-content">
          <h2 class="section-title">{{ research.title }}</h2>
          <div class="research-text">
            <p class="research-description">{{ research.content }}</p>
          </div>

          <!-- 研发能力列表 -->
          <div class="capabilities-list">
            <div class="capability-item">
              <div class="capability-icon">
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                  <path d="M10 1L13 7L19 7L14.5 11L16 18L10 14L4 18L5.5 11L1 7L7 7L10 1Z" fill="currentColor"/>
                </svg>
              </div>
              <div class="capability-text">
                <h4 class="capability-title">配方创新</h4>
                <p class="capability-desc">专注于天然成分和功效性配方的研发</p>
              </div>
            </div>

            <div class="capability-item">
              <div class="capability-icon">
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                  <rect x="2" y="3" width="16" height="14" rx="2" stroke="currentColor" stroke-width="2"/>
                  <path d="M6 7H14" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                  <path d="M6 11H14" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                </svg>
              </div>
              <div class="capability-text">
                <h4 class="capability-title">工艺优化</h4>
                <p class="capability-desc">持续改进生产工艺，提升产品质量</p>
              </div>
            </div>

            <div class="capability-item">
              <div class="capability-icon">
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                  <circle cx="10" cy="10" r="8" stroke="currentColor" stroke-width="2"/>
                  <path d="M6 10L9 13L14 7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <div class="capability-text">
                <h4 class="capability-title">安全测试</h4>
                <p class="capability-desc">严格的安全性和功效性测试体系</p>
              </div>
            </div>
          </div>

          <div class="research-actions">
            <router-link
              v-if="research.button_link"
              :to="research.button_link"
              class="btn btn-outline"
            >
              {{ research.button_text }}
            </router-link>
            <router-link
              v-else
              to="/services"
              class="btn btn-outline"
            >
              {{ research.button_text }}
            </router-link>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import type { ResearchSection } from '@/types'

interface Props {
  research: ResearchSection
}

const props = defineProps<Props>()
</script>

<style scoped>
.research-section {
  padding: 120px 0;
  background: var(--gray-bg);
}

/* 主要布局 - 左图右文 */
.research-layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 80px;
  align-items: center;
}

/* 图片内容 */
.research-media {
  position: relative;
  display: flex;
  flex-direction: column;
  gap: 40px;
}

.media-wrapper {
  position: relative;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: var(--shadow-lg);
}

.research-image {
  width: 100%;
  height: auto;
  display: block;
}

.image-placeholder {
  width: 100%;
  height: 300px;
  background: var(--section-bg);
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--primary-color);
}

/* 研发亮点卡片 */
.research-highlights {
  display: flex;
  gap: 20px;
}

.highlight-card {
  flex: 1;
  background: white;
  padding: 24px;
  border-radius: 12px;
  box-shadow: var(--shadow-sm);
  display: flex;
  align-items: center;
  gap: 16px;
  transition: transform 0.3s ease;
}

.highlight-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
}

.highlight-icon {
  flex-shrink: 0;
  width: 48px;
  height: 48px;
  border-radius: 12px;
  background: var(--primary-color);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
}

.highlight-content {
  flex: 1;
}

.highlight-title {
  font-size: 24px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 4px;
}

.highlight-desc {
  font-size: 14px;
  color: var(--text-secondary);
  margin: 0;
}

/* 文字内容 */
.research-content {
  max-width: 500px;
}

.section-title {
  font-size: 48px;
  font-weight: 300;
  color: var(--text-primary);
  margin-bottom: 32px;
  line-height: 1.2;
}

.research-text {
  margin-bottom: 40px;
}

.research-description {
  font-size: 18px;
  color: var(--text-secondary);
  line-height: 1.6;
  margin-bottom: 24px;
}

/* 研发能力列表 */
.capabilities-list {
  margin-bottom: 40px;
}

.capability-item {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  margin-bottom: 24px;
  padding: 20px;
  background: white;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.capability-item:hover {
  box-shadow: var(--shadow-sm);
  transform: translateX(8px);
}

.capability-icon {
  flex-shrink: 0;
  width: 40px;
  height: 40px;
  border-radius: 8px;
  background: var(--primary-color);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
}

.capability-text {
  flex: 1;
}

.capability-title {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 8px;
}

.capability-desc {
  font-size: 14px;
  color: var(--text-secondary);
  line-height: 1.5;
  margin: 0;
}

.research-actions .btn {
  padding: 16px 32px;
  font-size: 16px;
  font-weight: 500;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .research-section {
    padding: 100px 0;
  }

  .research-layout {
    gap: 60px;
  }

  .section-title {
    font-size: 40px;
  }

  .research-description {
    font-size: 16px;
  }

  .research-highlights {
    flex-direction: column;
    gap: 16px;
  }

  .highlight-title {
    font-size: 20px;
  }
}

@media (max-width: 768px) {
  .research-section {
    padding: 80px 0;
  }

  .research-layout {
    grid-template-columns: 1fr;
    gap: 40px;
  }

  .research-content {
    max-width: none;
  }

  .section-title {
    font-size: 32px;
  }

  .research-description {
    font-size: 14px;
  }

  .research-highlights {
    flex-direction: row;
    gap: 16px;
  }

  .highlight-card {
    padding: 20px;
    flex-direction: column;
    text-align: center;
    gap: 12px;
  }

  .highlight-icon {
    width: 40px;
    height: 40px;
  }

  .highlight-title {
    font-size: 18px;
  }

  .highlight-desc {
    font-size: 12px;
  }

  .capability-item {
    padding: 16px;
  }

  .capability-icon {
    width: 36px;
    height: 36px;
  }

  .capability-title {
    font-size: 14px;
  }

  .capability-desc {
    font-size: 12px;
  }
}

@media (max-width: 480px) {
  .research-section {
    padding: 60px 0;
  }

  .research-layout {
    gap: 32px;
  }

  .section-title {
    font-size: 28px;
  }

  .research-highlights {
    flex-direction: column;
  }

  .highlight-card {
    flex-direction: row;
    text-align: left;
  }

  .capability-item {
    margin-bottom: 16px;
    padding: 12px;
  }
}
</style>
