<template>
  <section class="vision-section">
    <div class="container">
      <div class="vision-content">
        <!-- 愿景主要内容 -->
        <div class="vision-main">
          <h2 class="section-title">{{ vision.title }}</h2>
          <div class="vision-text">
            <p class="vision-description">{{ vision.content }}</p>
          </div>
        </div>

        <!-- 价值观列表 - 类似MSD的价值观展示 -->
        <div class="values-section">
          <div class="values-grid">
            <div class="value-column">
              <h3 class="value-subtitle">{{ vision.subtitle_1 }}</h3>
            </div>
            <div class="value-column">
              <h3 class="value-subtitle">{{ vision.subtitle_2 }}</h3>
            </div>
            <div class="value-column">
              <h3 class="value-subtitle">{{ vision.subtitle_3 }}</h3>
            </div>
          </div>

          <!-- 价值观详细列表 -->
          <div class="values-list" v-if="values.length">
            <div
              v-for="(value, index) in values"
              :key="value.id"
              :class="['value-item', { active: activeValueIndex === index }]"
              @click="setActiveValue(index)"
            >
              <div class="value-header">
                <h4 class="value-title">{{ value.title }}</h4>
                <div class="value-toggle">
                  <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                    <path d="M5 7.5L10 12.5L15 7.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </div>
              </div>
              <transition name="value-expand">
                <div v-if="activeValueIndex === index" class="value-content">
                  <p class="value-description">{{ value.description }}</p>
                </div>
              </transition>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { VisionSection, ValueItem } from '@/types'

interface Props {
  vision: VisionSection
  values: ValueItem[]
}

const props = defineProps<Props>()

// 响应式状态
const activeValueIndex = ref(0)

// 设置活跃的价值观项目
const setActiveValue = (index: number) => {
  activeValueIndex.value = activeValueIndex.value === index ? -1 : index
}
</script>

<style scoped>
.vision-section {
  padding: 120px 0;
  background: var(--section-bg);
}

.vision-content {
  max-width: 1000px;
  margin: 0 auto;
}

/* 愿景主要内容 */
.vision-main {
  text-align: center;
  margin-bottom: 80px;
}

.section-title {
  font-size: 48px;
  font-weight: 300;
  color: var(--text-primary);
  margin-bottom: 32px;
  line-height: 1.2;
}

.vision-text {
  max-width: 800px;
  margin: 0 auto;
}

.vision-description {
  font-size: 20px;
  line-height: 1.6;
  color: var(--text-secondary);
  margin-bottom: 24px;
}

/* 价值观区域 */
.values-section {
  margin-top: 80px;
}

.values-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 40px;
  margin-bottom: 60px;
  text-align: center;
}

.value-column {
  padding: 40px 20px;
  background: var(--gray-bg);
  border-radius: 8px;
  transition: all 0.3s ease;
}

.value-column:hover {
  background: var(--primary-color);
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
}

.value-column:hover .value-subtitle {
  color: white;
}

.value-subtitle {
  font-size: 24px;
  font-weight: 500;
  color: var(--text-primary);
  margin: 0;
  transition: color 0.3s ease;
}

/* 价值观详细列表 */
.values-list {
  background: white;
  border-radius: 12px;
  box-shadow: var(--shadow-md);
  overflow: hidden;
}

.value-item {
  border-bottom: 1px solid var(--border-color);
  transition: all 0.3s ease;
  cursor: pointer;
}

.value-item:last-child {
  border-bottom: none;
}

.value-item:hover {
  background: var(--gray-bg);
}

.value-item.active {
  background: var(--primary-color);
  color: white;
}

.value-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24px 32px;
}

.value-title {
  font-size: 20px;
  font-weight: 500;
  margin: 0;
  transition: color 0.3s ease;
}

.value-item.active .value-title {
  color: white;
}

.value-toggle {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: var(--gray-bg);
  transition: all 0.3s ease;
}

.value-item.active .value-toggle {
  background: rgba(255, 255, 255, 0.2);
  transform: rotate(180deg);
}

.value-item.active .value-toggle svg {
  color: white;
}

.value-content {
  padding: 0 32px 32px 32px;
}

.value-description {
  font-size: 16px;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.9);
  margin: 0;
}

/* 展开动画 */
.value-expand-enter-active,
.value-expand-leave-active {
  transition: all 0.3s ease;
}

.value-expand-enter-from,
.value-expand-leave-to {
  opacity: 0;
  max-height: 0;
  transform: translateY(-20px);
}

.value-expand-enter-to,
.value-expand-leave-from {
  opacity: 1;
  max-height: 200px;
  transform: translateY(0);
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .vision-section {
    padding: 100px 0;
  }

  .section-title {
    font-size: 40px;
  }

  .vision-description {
    font-size: 18px;
  }

  .values-grid {
    gap: 30px;
    margin-bottom: 50px;
  }

  .value-subtitle {
    font-size: 20px;
  }
}

@media (max-width: 768px) {
  .vision-section {
    padding: 80px 0;
  }

  .vision-main {
    margin-bottom: 60px;
  }

  .section-title {
    font-size: 32px;
  }

  .vision-description {
    font-size: 16px;
  }

  .values-section {
    margin-top: 60px;
  }

  .values-grid {
    grid-template-columns: 1fr;
    gap: 20px;
    margin-bottom: 40px;
  }

  .value-column {
    padding: 30px 20px;
  }

  .value-subtitle {
    font-size: 18px;
  }

  .value-header {
    padding: 20px 24px;
  }

  .value-title {
    font-size: 18px;
  }

  .value-content {
    padding: 0 24px 24px 24px;
  }

  .value-description {
    font-size: 14px;
  }
}

@media (max-width: 480px) {
  .vision-section {
    padding: 60px 0;
  }

  .section-title {
    font-size: 28px;
  }

  .vision-description {
    font-size: 14px;
  }

  .value-column {
    padding: 24px 16px;
  }

  .value-subtitle {
    font-size: 16px;
  }

  .value-header {
    padding: 16px 20px;
  }

  .value-title {
    font-size: 16px;
  }

  .value-content {
    padding: 0 20px 20px 20px;
  }
}
</style>
