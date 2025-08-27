<template>
  <section class="hero-section">
    <div class="hero-container">
      <!-- 轮播指示器 -->
      <div class="hero-indicators" v-if="heroes.length > 1">
        <button
          v-for="(hero, index) in heroes"
          :key="hero.id"
          :class="['indicator', { active: currentIndex === index }]"
          @click="goToSlide(index)"
        >
          <span class="sr-only">第{{ index + 1 }}张幻灯片</span>
        </button>
      </div>

      <!-- 轮播内容 -->
      <div class="hero-slider">
        <transition-group name="hero-slide" tag="div" class="slider-wrapper">
          <div
            v-for="(hero, index) in heroes"
            :key="hero.id"
            v-show="currentIndex === index"
            class="hero-slide"
            :style="{ backgroundImage: hero.image ? `url(${hero.image})` : 'none' }"
          >
            <div class="hero-overlay"></div>
            <div class="container">
              <div class="hero-content">
                <div class="hero-text">
                  <h1 class="hero-title">{{ hero.title }}</h1>
                  <p class="hero-subtitle">{{ hero.subtitle }}</p>
                  <p v-if="hero.description" class="hero-description">{{ hero.description }}</p>

                  <div class="hero-actions">
                    <router-link
                      v-if="hero.button_link"
                      :to="hero.button_link"
                      class="btn btn-primary hero-btn"
                    >
                      {{ hero.button_text }}
                      <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                        <path d="M4.167 10H15.833" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                        <path d="M10 4.167L15.833 10L10 15.833" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>
                    </router-link>
                    <button
                      v-else
                      class="btn btn-primary hero-btn"
                      @click="scrollToNext"
                    >
                      {{ hero.button_text }}
                      <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                        <path d="M4.167 10H15.833" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                        <path d="M10 4.167L15.833 10L10 15.833" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </transition-group>
      </div>

      <!-- 导航箭头 -->
      <div class="hero-navigation" v-if="heroes.length > 1">
        <button class="nav-btn prev-btn" @click="prevSlide">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
            <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          <span class="sr-only">上一张</span>
        </button>
        <button class="nav-btn next-btn" @click="nextSlide">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
            <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          <span class="sr-only">下一张</span>
        </button>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import type { HeroSection } from '@/types'

interface Props {
  heroes: HeroSection[]
}

const props = defineProps<Props>()

// 响应式状态
const currentIndex = ref(0)
let autoplayTimer: number | null = null

// 轮播控制
const goToSlide = (index: number) => {
  currentIndex.value = index
  resetAutoplay()
}

const nextSlide = () => {
  currentIndex.value = (currentIndex.value + 1) % props.heroes.length
  resetAutoplay()
}

const prevSlide = () => {
  currentIndex.value = currentIndex.value === 0
    ? props.heroes.length - 1
    : currentIndex.value - 1
  resetAutoplay()
}

// 自动播放
const startAutoplay = () => {
  if (props.heroes.length <= 1) return

  autoplayTimer = window.setInterval(() => {
    nextSlide()
  }, 5000) // 5秒切换一次
}

const stopAutoplay = () => {
  if (autoplayTimer) {
    clearInterval(autoplayTimer)
    autoplayTimer = null
  }
}

const resetAutoplay = () => {
  stopAutoplay()
  startAutoplay()
}

// 滚动到下一个区域
const scrollToNext = () => {
  const heroSection = document.querySelector('.hero-section')
  const nextSection = heroSection?.nextElementSibling
  if (nextSection) {
    nextSection.scrollIntoView({ behavior: 'smooth' })
  }
}

// 生命周期
onMounted(() => {
  startAutoplay()
})

onUnmounted(() => {
  stopAutoplay()
})
</script>

<style scoped>
.hero-section {
  position: relative;
  height: 100vh;
  min-height: 600px;
  overflow: hidden;
}

.hero-container {
  position: relative;
  width: 100%;
  height: 100%;
}

/* 轮播内容 */
.hero-slider {
  position: relative;
  width: 100%;
  height: 100%;
}

.slider-wrapper {
  position: relative;
  width: 100%;
  height: 100%;
}

.hero-slide {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  background-color: var(--gray-bg);
  display: flex;
  align-items: center;
}

.hero-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    135deg,
    rgba(55, 70, 65, 0.8) 0%,
    rgba(100, 183, 178, 0.6) 50%,
    rgba(55, 70, 65, 0.8) 100%
  );
}

.hero-content {
  position: relative;
  z-index: 2;
  width: 100%;
  padding: 120px 0 80px;
}

.hero-text {
  max-width: 600px;
}

/* 文字样式 */
.hero-title {
  font-size: 64px;
  font-weight: 300;
  color: white;
  line-height: 1.2;
  margin-bottom: 24px;
  letter-spacing: -0.02em;
}

.hero-subtitle {
  font-size: 24px;
  font-weight: 400;
  color: rgba(255, 255, 255, 0.9);
  line-height: 1.4;
  margin-bottom: 20px;
}

.hero-description {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.8);
  line-height: 1.6;
  margin-bottom: 40px;
}

/* 按钮样式 */
.hero-actions {
  display: flex;
  gap: 24px;
  align-items: center;
}

.hero-btn {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  padding: 16px 32px;
  font-size: 16px;
  font-weight: 500;
  background: var(--primary-color);
  color: white;
  border: 2px solid var(--primary-color);
  border-radius: 6px;
  text-decoration: none;
  transition: all 0.3s ease;
  cursor: pointer;
}

.hero-btn:hover {
  background: transparent;
  color: var(--primary-color);
  border-color: var(--primary-color);
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(100, 183, 178, 0.3);
}

/* 轮播指示器 */
.hero-indicators {
  position: absolute;
  bottom: 40px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 12px;
  z-index: 10;
}

.indicator {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  border: 2px solid rgba(255, 255, 255, 0.5);
  background: transparent;
  cursor: pointer;
  transition: all 0.3s ease;
}

.indicator.active {
  background: white;
  border-color: white;
}

.indicator:hover {
  border-color: white;
  background: rgba(255, 255, 255, 0.5);
}

/* 导航箭头 */
.hero-navigation {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 100%;
  padding: 0 40px;
  display: flex;
  justify-content: space-between;
  z-index: 10;
  pointer-events: none;
}

.nav-btn {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  border: 2px solid rgba(255, 255, 255, 0.3);
  background: rgba(255, 255, 255, 0.1);
  color: white;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
  pointer-events: auto;
}

.nav-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.6);
  transform: scale(1.1);
}

/* 动画效果 */
.hero-slide-enter-active,
.hero-slide-leave-active {
  transition: all 0.8s ease-in-out;
}

.hero-slide-enter-from {
  opacity: 0;
  transform: translateX(100%);
}

.hero-slide-leave-to {
  opacity: 0;
  transform: translateX(-100%);
}

/* 辅助功能 */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .hero-title {
    font-size: 48px;
  }

  .hero-subtitle {
    font-size: 20px;
  }

  .hero-description {
    font-size: 16px;
  }

  .hero-content {
    padding: 100px 0 60px;
  }
}

@media (max-width: 768px) {
  .hero-section {
    min-height: 500px;
  }

  .hero-title {
    font-size: 36px;
  }

  .hero-subtitle {
    font-size: 18px;
  }

  .hero-description {
    font-size: 14px;
    margin-bottom: 32px;
  }

  .hero-content {
    padding: 80px 0 40px;
  }

  .hero-btn {
    padding: 14px 24px;
    font-size: 14px;
  }

  .hero-navigation {
    padding: 0 20px;
  }

  .nav-btn {
    width: 48px;
    height: 48px;
  }

  .hero-indicators {
    bottom: 20px;
  }
}

@media (max-width: 480px) {
  .hero-title {
    font-size: 28px;
  }

  .hero-subtitle {
    font-size: 16px;
  }

  .hero-actions {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
  }

  .hero-btn {
    width: 100%;
    justify-content: center;
  }
}
</style>
