<template>
  <footer class="app-footer">
    <!-- 装饰性顶部分隔线 -->
    <div class="footer-decoration">
      <div class="decoration-line">
        <div class="golden-accent"></div>
      </div>
      <div class="decoration-pattern">
        <div class="pattern-element"></div>
        <div class="pattern-element"></div>
        <div class="pattern-element"></div>
      </div>
    </div>

    <!-- 主要页脚内容 -->
    <div class="footer-main">
      <div class="container">
        <div class="footer-grid">
          <!-- 公司信息区域 -->
          <div class="footer-section company-info">
            <div class="footer-logo">
              <div class="logo">
                <div class="logo-icon">
                  <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                    <circle cx="16" cy="16" r="12" fill="var(--primary-color)" />
                    <path d="M12 16L15 19L20 13" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                  </svg>
                </div>
                <span class="logo-text">珠海优美</span>
              </div>
            </div>
            <p class="company-description">
              珠海优美化妆品有限公司，专业的美妆产品代工制造商，拥有20年行业经验和先进的生产设备，
              为全球美妆品牌提供高质量的ODM/OEM服务。
            </p>
            <div class="contact-info" v-if="companyInfo">
              <div class="contact-item">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                  <path d="M3 1.5L8 6L13 1.5V13.5C13 14.3284 12.3284 15 11.5 15H4.5C3.67157 15 3 14.3284 3 13.5V1.5Z" stroke="currentColor" stroke-width="1.5"/>
                  <path d="M3 1.5L8 6L13 1.5" stroke="currentColor" stroke-width="1.5"/>
                </svg>
                <span>{{ companyInfo.email }}</span>
              </div>
              <div class="contact-item">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                  <path d="M2 3L7 8L14 1" stroke="currentColor" stroke-width="1.5"/>
                  <path d="M14 1V5L7 12L2 7V3L14 1Z" stroke="currentColor" stroke-width="1.5"/>
                </svg>
                <span>{{ companyInfo.phone }}</span>
              </div>
            </div>
          </div>

          <!-- 快速链接 -->
          <div class="footer-section">
            <h3 class="footer-title">快速链接</h3>
            <div class="title-underline"></div>
            <ul class="footer-links">
              <li><router-link to="/about">关于我们</router-link></li>
              <li><router-link to="/products">产品中心</router-link></li>
              <li><router-link to="/services">服务范围</router-link></li>
              <li><router-link to="/news">新闻资讯</router-link></li>
              <li><router-link to="/contact">联系我们</router-link></li>
            </ul>
          </div>

          <!-- 产品分类 -->
          <div class="footer-section">
            <h3 class="footer-title">产品分类</h3>
            <div class="title-underline"></div>
            <ul class="footer-links">
              <li><a href="/products?category=护肤品">护肤品</a></li>
              <li><a href="/products?category=彩妆">彩妆产品</a></li>
              <li><a href="/products?category=个人护理">个人护理</a></li>
              <li><a href="/products?category=功能性美容">功能性美容</a></li>
            </ul>
          </div>

          <!-- 服务支持 -->
          <div class="footer-section">
            <h3 class="footer-title">服务支持</h3>
            <div class="title-underline"></div>
            <ul class="footer-links">
              <li><a href="/services#odm">ODM定制</a></li>
              <li><a href="/services#oem">OEM代工</a></li>
              <li><a href="/services#research">配方研发</a></li>
              <li><a href="/services#design">包装设计</a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <!-- 优雅的中间装饰分隔线 -->
    <div class="footer-divider">
      <div class="container">
        <div class="divider-line">
          <div class="divider-ornament">
            <div class="ornament-diamond"></div>
            <div class="ornament-line"></div>
            <div class="ornament-diamond"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- 版权信息 -->
    <div class="footer-bottom">
      <div class="container">
        <div class="footer-bottom-content">
          <div class="copyright">
            <p v-if="companyInfo">{{ companyInfo.copyright_text }}</p>
            <p v-else>© 2024 美妆代工厂. 保留所有权利.</p>
          </div>
          <div class="legal-links" v-if="companyInfo">
            <span v-if="companyInfo.icp_number">{{ companyInfo.icp_number }}</span>
            <span v-if="companyInfo.business_license">{{ companyInfo.business_license }}</span>
          </div>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useCompanyStore } from '@/stores'
import { storeToRefs } from 'pinia'

// 状态管理
const companyStore = useCompanyStore()
const { companyInfo } = storeToRefs(companyStore)

onMounted(async () => {
  // 加载公司信息
  if (!companyInfo.value) {
    await companyStore.getCompanyInfo()
  }
})
</script>

<style scoped>
.app-footer {
  background: #1a1a1a; /* 备用背景色 */
  background: var(--footer-bg);
  color: white;
  margin-top: auto;
}

/* 主要页脚内容 */
.footer-main {
  padding: 60px 0 40px;
}

.footer-grid {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr 1fr;
  gap: 60px;
}

/* 公司信息区域 */
.company-info {
  max-width: 400px;
}

.footer-logo {
  margin-bottom: 24px;
}

.logo {
  display: flex;
  align-items: center;
  gap: 12px;
}

.logo-text {
  font-size: 18px;
  font-weight: 400;
  color: white;
  letter-spacing: 2px;
  text-transform: uppercase;
}

.company-description {
  font-size: 14px;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 32px;
}

.contact-info {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.contact-item {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.8);
}

/* 页脚分组 */
.footer-section {
  display: flex;
  flex-direction: column;
}

.footer-title {
  font-size: 14px;
  font-weight: 500;
  color: white;
  margin-bottom: 24px;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.footer-links {
  list-style: none;
  padding: 0;
  margin: 0;
}

.footer-links li {
  margin-bottom: 12px;
}

.footer-links a {
  color: rgba(255, 255, 255, 0.8);
  text-decoration: none;
  font-size: 13px;
  transition: color 0.2s ease;
}

.footer-links a:hover {
  color: white;
}

/* 装饰性顶部区域 */
.footer-decoration {
  position: relative;
  padding: 0;
  background: #1a1a1a; /* 备用背景色 */
  background: linear-gradient(135deg, #1a1a1a 0%, #2a2a2a 50%, #1a1a1a 100%);
  overflow: hidden;
}

.decoration-line {
  position: relative;
  height: 3px;
  background: linear-gradient(90deg, transparent 0%, #666666 20%, #999999 50%, #666666 80%, transparent 100%);
  opacity: 0.8;
}

.golden-accent {
  position: absolute;
  top: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 200px;
  height: 3px;
  background: linear-gradient(90deg, transparent 0%, #ffd700 50%, transparent 100%);
  animation: shimmer 3s ease-in-out infinite;
}

.decoration-pattern {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 16px 0;
  gap: 24px;
}

.pattern-element {
  width: 8px;
  height: 8px;
  background: linear-gradient(45deg, #666666, #999999);
  border-radius: 50%;
  opacity: 0.6;
  animation: pulse 2s ease-in-out infinite;
}

.pattern-element:nth-child(2) {
  width: 12px;
  height: 12px;
  animation-delay: 0.5s;
}

.pattern-element:nth-child(3) {
  animation-delay: 1s;
}

/* 标题下划线装饰 */
.title-underline {
  width: 30px;
  height: 2px;
  background: linear-gradient(90deg, #666666, #999999);
  margin: 8px 0 16px 0;
  border-radius: 1px;
  opacity: 0.8;
}

/* 中间装饰分隔线 */
.footer-divider {
  padding: 32px 0;
  background: #1a1a1a; /* 备用背景色 */
  background: linear-gradient(135deg, #1a1a1a 0%, #1f1f1f 50%, #1a1a1a 100%);
}

.divider-line {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
}

.divider-ornament {
  display: flex;
  align-items: center;
  gap: 16px;
}

.ornament-diamond {
  width: 10px;
  height: 10px;
  background: linear-gradient(45deg, #666666, #999999);
  transform: rotate(45deg);
  border-radius: 2px;
  opacity: 0.8;
  box-shadow: 0 0 8px rgba(212, 175, 55, 0.3);
}

.ornament-line {
  width: 120px;
  height: 1px;
  background: linear-gradient(90deg, transparent 0%, rgba(212, 175, 55, 0.5) 20%, rgba(244, 228, 166, 0.8) 50%, rgba(212, 175, 55, 0.5) 80%, transparent 100%);
}

/* 动画效果 */
@keyframes shimmer {
  0%, 100% {
    opacity: 0.6;
    transform: translateX(-50%) scaleX(0.8);
  }
  50% {
    opacity: 1;
    transform: translateX(-50%) scaleX(1.2);
  }
}

@keyframes pulse {
  0%, 100% {
    transform: scale(1);
    opacity: 0.6;
  }
  50% {
    transform: scale(1.2);
    opacity: 1;
  }
}

/* 版权信息 */
.footer-bottom {
  border-top: 1px solid rgba(212, 175, 55, 0.2);
  padding: 24px 0;
  background: #0d0d0d; /* 这个已经有明确的深色背景 */
  position: relative;
}

.footer-bottom::before {
  content: '';
  position: absolute;
  top: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 100px;
  height: 1px;
  background: linear-gradient(90deg, transparent 0%, #666666 50%, transparent 100%);
  opacity: 0.6;
}

.footer-bottom-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
}

.legal-links {
  display: flex;
  gap: 24px;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .footer-grid {
    grid-template-columns: 1fr 1fr;
    gap: 40px;
  }

  .company-info {
    grid-column: 1 / -1;
    max-width: none;
  }

  .decoration-pattern {
    padding: 12px 0;
    gap: 16px;
  }

  .ornament-line {
    width: 80px;
  }
}

@media (max-width: 768px) {
  .footer-main {
    padding: 60px 0 40px;
  }

  .footer-grid {
    grid-template-columns: 1fr;
    gap: 40px;
  }

  .footer-bottom-content {
    flex-direction: column;
    gap: 16px;
    text-align: center;
  }

  .legal-links {
    flex-direction: column;
    gap: 8px;
  }

  .decoration-pattern {
    padding: 10px 0;
    gap: 12px;
  }

  .pattern-element {
    width: 6px;
    height: 6px;
  }

  .pattern-element:nth-child(2) {
    width: 8px;
    height: 8px;
  }

  .footer-divider {
    padding: 24px 0;
  }

  .ornament-line {
    width: 60px;
  }

  .ornament-diamond {
    width: 8px;
    height: 8px;
  }
}

@media (max-width: 480px) {
  .footer-main {
    padding: 40px 0 32px;
  }

  .footer-grid {
    gap: 32px;
  }

  .footer-title {
    font-size: 16px;
    margin-bottom: 16px;
  }

  .company-description {
    font-size: 14px;
    margin-bottom: 24px;
  }

  .decoration-pattern {
    padding: 8px 0;
    gap: 8px;
  }

  .golden-accent {
    width: 120px;
  }

  .footer-divider {
    padding: 16px 0;
  }

  .ornament-line {
    width: 40px;
  }

  .divider-ornament {
    gap: 8px;
  }

  .title-underline {
    width: 20px;
    margin: 6px 0 12px 0;
  }
}
</style>
