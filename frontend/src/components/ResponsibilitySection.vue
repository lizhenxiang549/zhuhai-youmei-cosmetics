<template>
  <section class="responsibility-section">
    <div class="container">
      <div class="responsibility-layout">
        <!-- 文字内容（左侧） -->
        <div class="responsibility-content">
          <h2 class="section-title">{{ responsibility.title }}</h2>
          <div class="responsibility-text">
            <p class="responsibility-description">{{ responsibility.content }}</p>
          </div>

          <!-- 责任承诺列表 -->
          <div class="commitments-list">
            <div class="commitment-item">
              <div class="commitment-icon">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                  <path d="M12 2L3 7V14C3 20 12 22 12 22C12 22 21 20 21 14V7L12 2Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
                  <path d="M9 12L11 14L15 10" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <div class="commitment-text">
                <h4 class="commitment-title">环境保护</h4>
                <p class="commitment-desc">致力于可持续发展，减少环境影响，保护生态环境</p>
              </div>
            </div>

            <div class="commitment-item">
              <div class="commitment-icon">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                  <path d="M17 21V19C17 17.9391 16.5786 16.9217 15.8284 16.1716C15.0783 15.4214 14.0609 15 13 15H5C3.93913 15 2.92172 15.4214 2.17157 16.1716C1.42143 16.9217 1 17.9391 1 19V21" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  <circle cx="9" cy="7" r="4" stroke="currentColor" stroke-width="2"/>
                  <path d="M23 21V19C23 18.1645 22.7275 17.3518 22.2235 16.6796C21.7195 16.0074 20.0133 15.4983 19 15.1" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  <path d="M16 3.13C17.0144 3.52774 18.7205 4.03687 19.2244 4.70913C19.7284 5.38139 20.001 6.19409 20.001 7.02963C20.001 7.86518 19.7284 8.67787 19.2244 9.35013C18.7205 10.0224 17.0144 10.5315 16 10.9292" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <div class="commitment-text">
                <h4 class="commitment-title">员工关怀</h4>
                <p class="commitment-desc">创造安全、健康、包容的工作环境，关注员工发展</p>
              </div>
            </div>

            <div class="commitment-item">
              <div class="commitment-icon">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                  <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
                  <path d="M8 14S9.5 16 12 16S16 14 16 14" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  <path d="M9 9H9.01" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  <path d="M15 9H15.01" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <div class="commitment-text">
                <h4 class="commitment-title">社区贡献</h4>
                <p class="commitment-desc">积极参与社区建设，支持教育和公益事业发展</p>
              </div>
            </div>

            <div class="commitment-item">
              <div class="commitment-icon">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                  <path d="M9 11H15" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  <path d="M9 15H15" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  <path d="M16 3L21 8V20C21 20.5304 20.7893 21.0391 20.4142 21.4142C20.0391 21.7893 19.5304 22 19 22H5C4.46957 22 3.96086 21.7893 3.58579 21.4142C3.21071 21.0391 3 20.5304 3 20V4C3 3.46957 3.21071 2.96086 3.58579 2.58579C3.96086 2.21071 4.46957 2 5 2H16L21 8Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  <path d="M16 3V8H21" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <div class="commitment-text">
                <h4 class="commitment-title">透明经营</h4>
                <p class="commitment-desc">坚持诚信经营，建立透明的商业运作体系</p>
              </div>
            </div>
          </div>

          <div class="responsibility-actions">
            <router-link
              v-if="responsibility.button_link"
              :to="responsibility.button_link"
              class="btn btn-primary"
            >
              {{ responsibility.button_text }}
            </router-link>
            <router-link
              v-else
              to="/about"
              class="btn btn-primary"
            >
              {{ responsibility.button_text }}
            </router-link>
          </div>
        </div>

        <!-- 图片内容（右侧） -->
        <div class="responsibility-media">
          <div class="media-wrapper">
            <img
              v-if="responsibility.image"
              :src="responsibility.image"
              :alt="responsibility.title"
              class="responsibility-image"
            />
            <div v-else class="image-placeholder">
              <svg width="120" height="120" viewBox="0 0 120 120" fill="none">
                <circle cx="60" cy="60" r="50" stroke="currentColor" stroke-width="2"/>
                <path d="M40 60L50 70L80 40" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
          </div>

          <!-- SDG目标卡片 -->
          <div class="sdg-goals">
            <div class="sdg-header">
              <h4 class="sdg-title">联合国可持续发展目标</h4>
              <p class="sdg-subtitle">我们积极响应并践行以下目标</p>
            </div>
            <div class="sdg-grid">
              <div class="sdg-item">
                <div class="sdg-icon">3</div>
                <span class="sdg-label">良好健康与福祉</span>
              </div>
              <div class="sdg-item">
                <div class="sdg-icon">6</div>
                <span class="sdg-label">清洁饮水和卫生设施</span>
              </div>
              <div class="sdg-item">
                <div class="sdg-icon">8</div>
                <span class="sdg-label">体面工作和经济增长</span>
              </div>
              <div class="sdg-item">
                <div class="sdg-icon">12</div>
                <span class="sdg-label">负责任消费和生产</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import type { ResponsibilitySection } from '@/types'

interface Props {
  responsibility: ResponsibilitySection
}

const props = defineProps<Props>()
</script>

<style scoped>
.responsibility-section {
  padding: 120px 0;
  background: var(--section-bg);
}

/* 主要布局 - 左文右图 */
.responsibility-layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 80px;
  align-items: center;
}

/* 文字内容 */
.responsibility-content {
  max-width: 500px;
}

.section-title {
  font-size: 48px;
  font-weight: 300;
  color: var(--text-primary);
  margin-bottom: 32px;
  line-height: 1.2;
}

.responsibility-text {
  margin-bottom: 40px;
}

.responsibility-description {
  font-size: 18px;
  color: var(--text-secondary);
  line-height: 1.6;
  margin-bottom: 24px;
}

/* 责任承诺列表 */
.commitments-list {
  margin-bottom: 40px;
}

.commitment-item {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  margin-bottom: 24px;
  padding: 20px;
  background: var(--gray-bg);
  border-radius: 8px;
  transition: all 0.3s ease;
}

.commitment-item:hover {
  background: white;
  box-shadow: var(--shadow-sm);
  transform: translateX(8px);
}

.commitment-icon {
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

.commitment-text {
  flex: 1;
}

.commitment-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 8px;
}

.commitment-desc {
  font-size: 14px;
  color: var(--text-secondary);
  line-height: 1.5;
  margin: 0;
}

.responsibility-actions .btn {
  padding: 16px 32px;
  font-size: 16px;
  font-weight: 500;
}

/* 图片内容 */
.responsibility-media {
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

.responsibility-image {
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
  color: var(--primary-color);
}

/* SDG目标卡片 */
.sdg-goals {
  background: white;
  padding: 32px;
  border-radius: 12px;
  box-shadow: var(--shadow-sm);
}

.sdg-header {
  margin-bottom: 24px;
  text-align: center;
}

.sdg-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 8px;
}

.sdg-subtitle {
  font-size: 14px;
  color: var(--text-secondary);
  margin: 0;
}

.sdg-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.sdg-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 16px;
  border-radius: 8px;
  background: var(--gray-bg);
  transition: all 0.3s ease;
}

.sdg-item:hover {
  background: var(--primary-color);
  color: white;
  transform: translateY(-2px);
}

.sdg-icon {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: var(--primary-color);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  font-weight: 600;
}

.sdg-item:hover .sdg-icon {
  background: white;
  color: var(--primary-color);
}

.sdg-label {
  font-size: 12px;
  text-align: center;
  line-height: 1.3;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .responsibility-section {
    padding: 100px 0;
  }

  .responsibility-layout {
    gap: 60px;
  }

  .section-title {
    font-size: 40px;
  }

  .responsibility-description {
    font-size: 16px;
  }

  .commitment-item {
    padding: 16px;
  }

  .commitment-icon {
    width: 40px;
    height: 40px;
  }

  .commitment-title {
    font-size: 16px;
  }

  .commitment-desc {
    font-size: 12px;
  }
}

@media (max-width: 768px) {
  .responsibility-section {
    padding: 80px 0;
  }

  .responsibility-layout {
    grid-template-columns: 1fr;
    gap: 40px;
  }

  .responsibility-content {
    max-width: none;
    order: 2;
  }

  .responsibility-media {
    order: 1;
  }

  .section-title {
    font-size: 32px;
  }

  .responsibility-description {
    font-size: 14px;
  }

  .commitment-item {
    padding: 16px;
    margin-bottom: 16px;
  }

  .commitment-icon {
    width: 36px;
    height: 36px;
  }

  .commitment-title {
    font-size: 14px;
  }

  .commitment-desc {
    font-size: 12px;
  }

  .sdg-goals {
    padding: 24px;
  }

  .sdg-title {
    font-size: 16px;
  }

  .sdg-subtitle {
    font-size: 12px;
  }
}

@media (max-width: 480px) {
  .responsibility-section {
    padding: 60px 0;
  }

  .responsibility-layout {
    gap: 32px;
  }

  .section-title {
    font-size: 28px;
  }

  .commitment-item {
    padding: 12px;
  }

  .sdg-grid {
    grid-template-columns: 1fr;
    gap: 12px;
  }

  .sdg-item {
    padding: 12px;
  }

  .sdg-icon {
    width: 32px;
    height: 32px;
    font-size: 14px;
  }

  .sdg-label {
    font-size: 11px;
  }
}
</style>
