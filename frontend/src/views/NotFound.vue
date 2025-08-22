<template>
  <div class="not-found-page">
    <!-- 导航栏 -->
    <AppHeader />

    <!-- 404内容 -->
    <section class="not-found-content">
      <div class="container">
        <div class="not-found-layout">
          <!-- 404图标 -->
          <div class="not-found-icon">
            <svg width="200" height="200" viewBox="0 0 200 200" fill="none">
              <!-- 404数字 -->
              <text x="100" y="80" text-anchor="middle" class="error-number">404</text>

              <!-- 装饰元素 -->
              <circle cx="50" cy="140" r="8" class="decoration-circle" />
              <circle cx="150" cy="140" r="6" class="decoration-circle" />
              <circle cx="30" cy="60" r="4" class="decoration-circle" />
              <circle cx="170" cy="50" r="5" class="decoration-circle" />

              <!-- 眼睛表情 -->
              <circle cx="80" cy="120" r="3" fill="currentColor" />
              <circle cx="120" cy="120" r="3" fill="currentColor" />

              <!-- 嘴巴 -->
              <path d="M85 140 Q100 155 115 140" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" />
            </svg>
          </div>

          <!-- 错误信息 -->
          <div class="not-found-text">
            <h1 class="error-title">页面未找到</h1>
            <p class="error-description">
              抱歉，您访问的页面不存在或已被移动。
              <br />
              请检查网址是否正确，或者返回首页继续浏览。
            </p>

            <!-- 可能的原因 -->
            <div class="error-reasons">
              <h3 class="reasons-title">可能的原因：</h3>
              <ul class="reasons-list">
                <li>您输入的网址有误</li>
                <li>页面已被删除或移动</li>
                <li>您没有访问权限</li>
                <li>服务器暂时无响应</li>
              </ul>
            </div>

            <!-- 操作按钮 -->
            <div class="error-actions">
              <router-link to="/" class="btn btn-primary">
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                  <path d="M3 10L17 10" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                  <path d="M10 3L17 10L10 17" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                返回首页
              </router-link>

              <button @click="goBack" class="btn btn-outline">
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                  <path d="M17 10L3 10" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                  <path d="M10 17L3 10L10 3" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                返回上页
              </button>

              <router-link to="/contact" class="btn btn-secondary">
                联系我们
              </router-link>
            </div>
          </div>
        </div>

        <!-- 快速链接 -->
        <div class="quick-links">
          <h2 class="quick-links-title">您可能在寻找：</h2>
          <div class="links-grid">
            <router-link to="/products" class="quick-link-card">
              <div class="link-icon">
                <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                  <rect x="4" y="6" width="24" height="20" rx="4" stroke="currentColor" stroke-width="2"/>
                  <path d="M8 12H24" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                  <path d="M8 16H20" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                  <path d="M8 20H16" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                </svg>
              </div>
              <h3 class="link-title">产品中心</h3>
              <p class="link-desc">浏览我们的美妆产品系列</p>
            </router-link>

            <router-link to="/services" class="quick-link-card">
              <div class="link-icon">
                <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                  <circle cx="16" cy="16" r="12" stroke="currentColor" stroke-width="2"/>
                  <path d="M12 16L14 18L20 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <h3 class="link-title">服务范围</h3>
              <p class="link-desc">了解我们的专业服务</p>
            </router-link>

            <router-link to="/about" class="quick-link-card">
              <div class="link-icon">
                <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                  <path d="M16 28C22.6274 28 28 22.6274 28 16C28 9.37258 22.6274 4 16 4C9.37258 4 4 9.37258 4 16C4 22.6274 9.37258 28 16 28Z" stroke="currentColor" stroke-width="2"/>
                  <path d="M12 12C12 10.9391 12.4214 9.92172 13.1716 9.17157C13.9217 8.42143 14.9391 8 16 8C17.0609 8 18.0783 8.42143 18.8284 9.17157C19.5786 9.92172 20 10.9391 20 12C20 13.3333 16 14.6667 16 18" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  <circle cx="16" cy="22" r="1" fill="currentColor"/>
                </svg>
              </div>
              <h3 class="link-title">关于我们</h3>
              <p class="link-desc">了解我们的企业文化</p>
            </router-link>

            <router-link to="/news" class="quick-link-card">
              <div class="link-icon">
                <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                  <path d="M8 4H24C25.1046 4 26 4.89543 26 6V26C26 27.1046 25.1046 28 24 28H8C6.89543 28 6 27.1046 6 26V6C6 4.89543 6.89543 4 8 4Z" stroke="currentColor" stroke-width="2"/>
                  <path d="M10 10H22" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                  <path d="M10 14H22" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                  <path d="M10 18H18" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                </svg>
              </div>
              <h3 class="link-title">新闻资讯</h3>
              <p class="link-desc">获取最新行业动态</p>
            </router-link>
          </div>
        </div>
      </div>
    </section>

    <!-- 页脚 -->
    <AppFooter />
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'

// 组件导入
import AppHeader from '@/components/AppHeader.vue'
import AppFooter from '@/components/AppFooter.vue'

const router = useRouter()

// 返回上一页
const goBack = () => {
  if (window.history.length > 1) {
    router.go(-1)
  } else {
    router.push('/')
  }
}
</script>

<style scoped>
.not-found-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  padding-top: 90px;
}

/* 404内容 */
.not-found-content {
  flex: 1;
  padding: 80px 0 120px;
  background: var(--gray-bg);
  display: flex;
  align-items: center;
}

.not-found-layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 80px;
  align-items: center;
  margin-bottom: 80px;
}

/* 404图标 */
.not-found-icon {
  display: flex;
  justify-content: center;
  align-items: center;
  color: var(--primary-color);
}

.not-found-icon svg {
  max-width: 100%;
  height: auto;
}

.error-number {
  font-size: 36px;
  font-weight: 300;
  fill: var(--primary-color);
}

.decoration-circle {
  fill: var(--primary-color);
  opacity: 0.3;
  animation: float 3s ease-in-out infinite;
}

.decoration-circle:nth-child(2) {
  animation-delay: -0.5s;
}

.decoration-circle:nth-child(3) {
  animation-delay: -1s;
}

.decoration-circle:nth-child(4) {
  animation-delay: -1.5s;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0);
    opacity: 0.3;
  }
  50% {
    transform: translateY(-10px);
    opacity: 0.6;
  }
}

/* 错误信息 */
.not-found-text {
  text-align: left;
}

.error-title {
  font-size: 48px;
  font-weight: 300;
  color: var(--text-primary);
  margin-bottom: 24px;
  line-height: 1.2;
}

.error-description {
  font-size: 18px;
  color: var(--text-secondary);
  line-height: 1.6;
  margin-bottom: 32px;
}

/* 可能的原因 */
.error-reasons {
  background: white;
  padding: 24px;
  border-radius: 8px;
  margin-bottom: 40px;
  border-left: 4px solid var(--primary-color);
}

.reasons-title {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 16px;
}

.reasons-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.reasons-list li {
  font-size: 14px;
  color: var(--text-secondary);
  margin-bottom: 8px;
  padding-left: 20px;
  position: relative;
}

.reasons-list li::before {
  content: '•';
  color: var(--primary-color);
  position: absolute;
  left: 0;
  font-weight: bold;
}

/* 操作按钮 */
.error-actions {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
}

.error-actions .btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 14px 28px;
  font-size: 16px;
  font-weight: 500;
  text-decoration: none;
  border-radius: 6px;
  transition: all 0.3s ease;
  cursor: pointer;
  border: 2px solid transparent;
}

.btn-primary {
  background: var(--primary-color);
  color: white;
  border-color: var(--primary-color);
}

.btn-primary:hover {
  background: var(--primary-dark);
  border-color: var(--primary-dark);
  transform: translateY(-2px);
}

.btn-outline {
  background: transparent;
  color: var(--text-primary);
  border-color: var(--border-color);
}

.btn-outline:hover {
  background: var(--primary-color);
  color: white;
  border-color: var(--primary-color);
}

.btn-secondary {
  background: var(--gray-bg);
  color: var(--text-primary);
  border-color: var(--border-color);
}

.btn-secondary:hover {
  background: var(--text-primary);
  color: white;
  border-color: var(--text-primary);
}

/* 快速链接 */
.quick-links {
  text-align: center;
}

.quick-links-title {
  font-size: 32px;
  font-weight: 400;
  color: var(--text-primary);
  margin-bottom: 48px;
}

.links-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 32px;
}

.quick-link-card {
  background: white;
  padding: 32px 24px;
  border-radius: 12px;
  text-decoration: none;
  text-align: center;
  box-shadow: var(--shadow-sm);
  transition: all 0.3s ease;
  border: 2px solid transparent;
}

.quick-link-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
  border-color: var(--primary-color);
}

.link-icon {
  width: 64px;
  height: 64px;
  border-radius: 16px;
  background: var(--primary-color);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 24px;
  transition: all 0.3s ease;
}

.quick-link-card:hover .link-icon {
  background: var(--primary-dark);
  transform: scale(1.1);
}

.link-title {
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 12px;
}

.link-desc {
  font-size: 14px;
  color: var(--text-secondary);
  line-height: 1.5;
  margin: 0;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .not-found-layout {
    gap: 60px;
  }

  .error-title {
    font-size: 40px;
  }

  .quick-links-title {
    font-size: 28px;
  }

  .links-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .not-found-content {
    padding: 60px 0 80px;
  }

  .not-found-layout {
    grid-template-columns: 1fr;
    gap: 40px;
    text-align: center;
  }

  .not-found-text {
    text-align: center;
  }

  .error-title {
    font-size: 36px;
  }

  .error-description {
    font-size: 16px;
  }

  .error-actions {
    justify-content: center;
  }

  .quick-links-title {
    font-size: 24px;
  }

  .links-grid {
    grid-template-columns: 1fr;
    gap: 24px;
  }
}

@media (max-width: 480px) {
  .not-found-content {
    padding: 40px 0 60px;
  }

  .error-title {
    font-size: 32px;
  }

  .error-description {
    font-size: 14px;
  }

  .error-actions {
    flex-direction: column;
    align-items: center;
  }

  .error-actions .btn {
    width: 100%;
    max-width: 280px;
    justify-content: center;
  }

  .error-reasons {
    padding: 20px;
  }

  .quick-link-card {
    padding: 24px 20px;
  }

  .link-icon {
    width: 48px;
    height: 48px;
  }

  .link-title {
    font-size: 18px;
  }

  .link-desc {
    font-size: 12px;
  }
}
</style>
