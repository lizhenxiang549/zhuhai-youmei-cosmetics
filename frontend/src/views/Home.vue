<template>
  <div class="home-page">
    <!-- 导航栏 -->
    <AppHeader />

    <!-- Hero区域 - 完全仿照Guerlain蜂蜜金黄色风格 -->
    <section class="hero-section">
      <div class="hero-container">
        <div class="hero-content">
          <!-- 黄金蜂蜜背景图片区域 -->
          <div class="hero-visual">
            <div class="golden-background">
              <div class="honey-texture"></div>
              <div class="hero-overlay">
                <div class="hero-text">
                  <div class="brand-highlight">
                    <div class="highlight-icons">
                      <div class="icon-item">
                        <div class="icon-circle">
                          <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                            <path d="M12 2L3 7V17L12 22L21 17V7L12 2Z" stroke="currentColor" stroke-width="1.5"/>
                          </svg>
                        </div>
                        <p>专业代工</p>
                      </div>
                      <div class="icon-item">
                        <div class="icon-circle">
                          <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                            <path d="M12 2L3 7L12 12L21 7L12 2Z" stroke="currentColor" stroke-width="1.5"/>
                            <path d="M3 17L12 22L21 17" stroke="currentColor" stroke-width="1.5"/>
                            <path d="M3 12L12 17L21 12" stroke="currentColor" stroke-width="1.5"/>
                          </svg>
                        </div>
                        <p>全程定制</p>
                      </div>
                      <div class="icon-item">
                        <div class="icon-circle">
                          <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                            <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/>
                            <path d="M8 12L11 15L16 9" stroke="currentColor" stroke-width="1.5"/>
                          </svg>
                        </div>
                        <p>品质保证</p>
                      </div>
                      <div class="icon-item">
                        <div class="icon-circle">
                          <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                            <path d="M21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12Z" stroke="currentColor" stroke-width="1.5"/>
                          </svg>
                        </div>
                        <p>对外出口</p>
                      </div>
                    </div>
                  </div>

                  <h1 class="hero-title">慕心沉礼. 蜜爱永系</h1>
                  <p class="hero-subtitle">珠海优美现蜜意</p>

                  <button class="explore-btn">探索</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 畅销经典 - Guerlain产品展示区 -->
    <section class="bestsellers-section scroll-fade-in">
      <div class="container">
        <div class="section-header scroll-fade-in">
          <h2 class="section-title">畅销经典</h2>
        </div>

        <div class="products-grid">
          <div class="product-card" v-for="i in 6" :key="i">
            <div class="product-image">
              <div class="image-placeholder">
                <div class="product-initial">{{ ['美', '妆', '代', '工', '厂', '品'][i-1] }}</div>
              </div>
            </div>
            <div class="product-info">
              <h3 class="product-brand">珠海优美</h3>
              <h4 class="product-name">{{ ['蜜颜奢养美肌精华', '璀璨金辉护肤乳液', '雪兰莳金芯面霜', '皇室蜂蜜修护精油', '黄金蜜缘美容液', '宫廷蜜语护肤套装'][i-1] }}</h4>
              <p class="product-price">¥ {{ [2380, 1580, 3280, 1980, 2680, 4580][i-1] }}</p>
              <button class="quick-buy-btn">快速购买</button>
            </div>
          </div>
        </div>

        <div class="view-more">
          <button class="view-more-btn">探索</button>
        </div>
      </div>
    </section>

    <!-- 当季新品 -->
    <section class="new-arrivals-section scroll-fade-in">
      <div class="container">
        <div class="section-header scroll-fade-in">
          <h2 class="section-title">当季新品</h2>
        </div>

        <div class="new-products-showcase">
          <div class="featured-product">
            <div class="product-visual">
              <div class="image-placeholder large">
                <div class="luxury-initial">新</div>
              </div>
            </div>
            <div class="product-content">
              <h3 class="featured-title">珠海优美臻纯蜂蜜香水</h3>
              <p class="featured-desc">
                运用独家蜂蜜萃取工艺，融合天然蜂蜜精华，
                为您提供最奢华的美妆代工服务。
              </p>
              <button class="featured-btn">探索</button>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 分类展示 - Guerlain风格 -->
    <section class="categories-section scroll-fade-in">
      <div class="container">
        <div class="categories-grid scroll-fade-in">
          <div class="category-item">
            <h3 class="category-title">护肤</h3>
            <p class="category-subtitle">对于肌肤美容的无限</p>
            <button class="category-btn">探索</button>
          </div>

          <div class="category-item">
            <h3 class="category-title">彩妆</h3>
            <p class="category-subtitle">永恒闪耀的色彩</p>
            <button class="category-btn">探索</button>
          </div>

          <div class="category-item">
            <h3 class="category-title">面部</h3>
            <p class="category-subtitle">质感层理新定义</p>
            <button class="category-btn">探索</button>
          </div>

          <div class="category-item">
            <h3 class="category-title">香水</h3>
            <p class="category-subtitle">私人蜜缘专属</p>
            <button class="category-btn">探索</button>
          </div>
        </div>
      </div>
    </section>

    <!-- 探索好兰 -->
    <section class="explore-section scroll-fade-in">
      <div class="container">
        <div class="explore-content scroll-fade-in">
          <h2 class="explore-title">探索好兰</h2>
          <p class="explore-subtitle">
            欧洲的高端品牌直接认识其保护与品质标识标准。
            法国精选优品，顶级制造，高端美妆代工服务专业致力于品质的保证和美容。
            为顶级品牌提供美妆产品代工，领导细节关注。
          </p>
          <button class="explore-btn-large">了解我们</button>
        </div>
      </div>
    </section>

    <!-- 我们承诺 -->
    <section class="promise-section scroll-fade-in">
      <div class="container">
        <div class="promise-content scroll-fade-in">
          <h2 class="promise-title">我们承诺</h2>
          <div class="promise-grid">
            <div class="promise-item">
              <div class="promise-icon">
                <svg width="40" height="40" viewBox="0 0 40 40" fill="none">
                  <circle cx="20" cy="20" r="18" stroke="currentColor" stroke-width="2"/>
                  <path d="M14 20L18 24L26 16" stroke="currentColor" stroke-width="2"/>
                </svg>
              </div>
              <h3>免费辟谣</h3>
              <p>所有产品配方经专业实验室认证</p>
            </div>

            <div class="promise-item">
              <div class="promise-icon">
                <svg width="40" height="40" viewBox="0 0 40 40" fill="none">
                  <path d="M20 2L6 10V20C6 28 20 38 20 38C20 38 34 28 34 20V10L20 2Z" stroke="currentColor" stroke-width="2"/>
                </svg>
              </div>
              <h3>产品深度</h3>
              <p>提供3个月的发现期，及时将产品质量缺陷反馈给我们，
              我们承担重要成分质量责任</p>
            </div>

            <div class="promise-item">
              <div class="promise-icon">
                <svg width="40" height="40" viewBox="0 0 40 40" fill="none">
                  <circle cx="20" cy="20" r="18" stroke="currentColor" stroke-width="2"/>
                  <path d="M20 8V20L28 28" stroke="currentColor" stroke-width="2"/>
                </svg>
              </div>
              <h3>首护老化</h3>
              <p>所有制造业务经合作方成果运输选择</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 查阅门店 -->
    <section class="stores-section">
      <div class="container">
        <div class="stores-content">
          <h2 class="stores-title">查阅门店</h2>
          <button class="stores-btn">探索</button>
        </div>
      </div>
    </section>

    <!-- 线上优购 -->
    <section class="online-section">
      <div class="container">
        <div class="online-grid">
          <div class="online-item">
            <div class="online-icon">
              <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                <circle cx="16" cy="16" r="14" stroke="currentColor" stroke-width="2"/>
              </svg>
            </div>
            <h3>免费辟谣</h3>
            <p>所有产品在开启、无法达到时间内皮尤其内获得价值适配</p>
          </div>

          <div class="online-item">
            <div class="online-icon">
              <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                <rect x="4" y="8" width="24" height="16" rx="2" stroke="currentColor" stroke-width="2"/>
                <path d="M8 12H24" stroke="currentColor" stroke-width="2"/>
              </svg>
            </div>
            <h3>产品深度</h3>
            <p>每天3个多样的计划标注，及内提供特殊专业时配合
            和您享受专属关注</p>
          </div>

          <div class="online-item">
            <div class="online-icon">
              <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                <path d="M16 6V16L22 22" stroke="currentColor" stroke-width="2"/>
                <circle cx="16" cy="16" r="12" stroke="currentColor" stroke-width="2"/>
              </svg>
            </div>
            <h3>美丽是永恒自然</h3>
            <p>所有专业问题线成分面向发布</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 页脚 -->
    <AppFooter />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import AppHeader from '@/components/AppHeader.vue'
import AppFooter from '@/components/AppFooter.vue'

// 简化版本，专注于视觉呈现
const featuredProducts = ref([])

// 滚动动画相关
const scrollY = ref(0)
const isScrolling = ref(false)

// 处理滚动事件
const handleScroll = () => {
  scrollY.value = window.scrollY

  if (!isScrolling.value) {
    isScrolling.value = true
    requestAnimationFrame(() => {
      updateScrollElements()
      isScrolling.value = false
    })
  }
}

// 更新滚动元素
const updateScrollElements = () => {
  const elements = document.querySelectorAll('.scroll-fade-in')
  elements.forEach((element) => {
    const rect = element.getBoundingClientRect()
    const isVisible = rect.top < window.innerHeight && rect.bottom > 0

    if (isVisible) {
      element.classList.add('visible')
    }
  })

  // 视差滚动效果
  const heroSection = document.querySelector('.hero-section')
  if (heroSection) {
    const offset = scrollY.value * 0.5
    heroSection.style.transform = `translateY(${offset}px)`
  }
}

onMounted(() => {
  // 可以在这里加载实际的产品数据
  window.addEventListener('scroll', handleScroll, { passive: true })

  // 初始检查可见元素
  setTimeout(() => {
    updateScrollElements()
  }, 100)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
.home-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

/* Hero区域 - 完全仿照Guerlain蜂蜜金黄色风格 */
.hero-section {
  margin-top: 120px;
  min-height: 80vh;
  position: relative;
}

.hero-container {
  width: 100%;
  height: 100%;
}

.hero-content {
  width: 100%;
  height: 100%;
}

.hero-visual {
  width: 100%;
  height: 100%;
  position: relative;
}

.golden-background {
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #000000 0%, #1a1a1a 25%, #2a2a2a 50%, #1a1a1a 75%, #000000 100%);
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 80vh;
}

.honey-texture {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background:
    radial-gradient(circle at 20% 30%, rgba(255,255,255,0.1) 1%, transparent 2%),
    radial-gradient(circle at 80% 70%, rgba(255,255,255,0.05) 1%, transparent 2%),
    radial-gradient(circle at 60% 20%, rgba(255,255,255,0.03) 2%, transparent 3%);
  background-size: 80px 80px, 120px 120px, 60px 60px;
}

.hero-overlay {
  position: relative;
  z-index: 2;
  text-align: center;
  color: white;
  max-width: 600px;
  margin: 0 auto;
  padding: 40px;
}

.brand-highlight {
  margin-bottom: 40px;
}

.highlight-icons {
  display: flex;
  justify-content: center;
  gap: 30px;
  margin-bottom: 40px;
}

.icon-item {
  text-align: center;
}

.icon-circle {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: rgba(255,255,255,0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 12px;
  color: white;
}

.icon-item p {
  font-size: 12px;
  color: white;
  margin: 0;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.hero-title {
  font-size: 48px;
  font-weight: 300;
  margin-bottom: 16px;
  color: white;
  letter-spacing: 2px;
}

.hero-subtitle {
  font-size: 20px;
  margin-bottom: 40px;
  color: rgba(255,255,255,0.9);
  font-weight: 300;
}

.explore-btn {
  background: #000;
  color: white;
  border: none;
  padding: 16px 32px;
  font-size: 14px;
  text-transform: uppercase;
  letter-spacing: 1px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.explore-btn:hover {
  background: #333;
}

/* 畅销经典 - 产品展示区 */
.bestsellers-section {
  padding: 80px 0;
  background: #fff;
}

.section-header {
  text-align: center;
  margin-bottom: 60px;
}

.section-title {
  font-size: 32px;
  font-weight: 300;
  color: #000;
  margin-bottom: 20px;
  text-transform: uppercase;
  letter-spacing: 2px;
}

.products-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 40px;
  margin-bottom: 60px;
}

.product-card {
  text-align: center;
  background: #fff;
  transition: transform 0.3s ease;
}

.product-card:hover {
  transform: translateY(-4px);
}

.product-image {
  width: 100%;
  height: 250px;
  margin-bottom: 20px;
  position: relative;
}

.image-placeholder {
  width: 100%;
  height: 100%;
  background: #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid #e0e0e0;
}

.product-initial {
  font-size: 48px;
  color: #666666;
  font-weight: 300;
}

.product-info {
  padding: 0 10px;
}

.product-brand {
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 1px;
  color: #666;
  margin-bottom: 8px;
}

.product-name {
  font-size: 16px;
  color: #000;
  margin-bottom: 12px;
  font-weight: normal;
}

.product-price {
  font-size: 14px;
  color: #000;
  margin-bottom: 16px;
  font-weight: 500;
}

.quick-buy-btn {
  background: #000;
  color: white;
  border: none;
  padding: 10px 20px;
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 1px;
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 20px;
}

.quick-buy-btn:hover {
  background: #333;
}

.view-more {
  text-align: center;
}

.view-more-btn {
  background: #000;
  color: white;
  border: none;
  padding: 16px 32px;
  font-size: 14px;
  text-transform: uppercase;
  letter-spacing: 1px;
  cursor: pointer;
}

/* 当季新品 */
.new-arrivals-section {
  padding: 80px 0;
  background: #fbfaf7;
}

.new-products-showcase {
  max-width: 800px;
  margin: 0 auto;
}

.featured-product {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 60px;
  align-items: center;
}

.image-placeholder.large {
  height: 400px;
}

.luxury-initial {
  font-size: 64px;
  color: #666666;
  font-weight: 300;
}

.product-content {
  padding: 40px;
}

.featured-title {
  font-size: 28px;
  font-weight: 300;
  color: #000;
  margin-bottom: 20px;
}

.featured-desc {
  font-size: 16px;
  color: #666;
  line-height: 1.6;
  margin-bottom: 30px;
}

.featured-btn {
  background: #000;
  color: white;
  border: none;
  padding: 16px 32px;
  font-size: 14px;
  text-transform: uppercase;
  letter-spacing: 1px;
  cursor: pointer;
}

/* 分类展示 */
.categories-section {
  padding: 80px 0;
  background: #fff;
}

.categories-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 40px;
}

.category-item {
  text-align: center;
  padding: 40px 20px;
}

.category-title {
  font-size: 24px;
  font-weight: 300;
  color: #000;
  margin-bottom: 12px;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.category-subtitle {
  font-size: 14px;
  color: #666;
  margin-bottom: 24px;
}

.category-btn {
  background: #000;
  color: white;
  border: none;
  padding: 12px 24px;
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 1px;
  cursor: pointer;
}

/* 其他区域 */
.explore-section, .promise-section, .stores-section, .online-section {
  padding: 80px 0;
  background: #fff;
  text-align: center;
}

.explore-section {
  background: #000;
  color: white;
}

.explore-title, .promise-title, .stores-title {
  font-size: 32px;
  font-weight: 300;
  margin-bottom: 24px;
  text-transform: uppercase;
  letter-spacing: 2px;
}

.explore-subtitle {
  font-size: 16px;
  line-height: 1.6;
  max-width: 600px;
  margin: 0 auto 40px;
  color: rgba(255,255,255,0.8);
}

.explore-btn-large {
  background: white;
  color: #000;
  border: none;
  padding: 16px 32px;
  font-size: 14px;
  text-transform: uppercase;
  letter-spacing: 1px;
  cursor: pointer;
}

.promise-grid, .online-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 40px;
  margin-top: 60px;
}

.promise-item, .online-item {
  text-align: center;
  padding: 20px;
}

.promise-icon, .online-icon {
  color: #666666;
  margin-bottom: 20px;
}

.stores-btn {
  background: #000;
  color: white;
  border: none;
  padding: 16px 32px;
  font-size: 14px;
  text-transform: uppercase;
  letter-spacing: 1px;
  cursor: pointer;
}

/* 滚动动画 */
.scroll-fade-in {
  opacity: 0;
  transform: translateY(30px);
  transition: all 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.scroll-fade-in.visible {
  opacity: 1;
  transform: translateY(0);
}

/* 不同延迟效果 */
.scroll-fade-in:nth-child(1) { transition-delay: 0.1s; }
.scroll-fade-in:nth-child(2) { transition-delay: 0.2s; }
.scroll-fade-in:nth-child(3) { transition-delay: 0.3s; }
.scroll-fade-in:nth-child(4) { transition-delay: 0.4s; }
.scroll-fade-in:nth-child(5) { transition-delay: 0.5s; }
.scroll-fade-in:nth-child(6) { transition-delay: 0.6s; }

/* 产品卡片逐个显示 */
.product-card {
  opacity: 0;
  transform: translateY(20px) scale(0.95);
  transition: all 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.bestsellers-section.visible .product-card {
  opacity: 1;
  transform: translateY(0) scale(1);
}

.bestsellers-section.visible .product-card:nth-child(1) { transition-delay: 0.1s; }
.bestsellers-section.visible .product-card:nth-child(2) { transition-delay: 0.2s; }
.bestsellers-section.visible .product-card:nth-child(3) { transition-delay: 0.3s; }
.bestsellers-section.visible .product-card:nth-child(4) { transition-delay: 0.4s; }
.bestsellers-section.visible .product-card:nth-child(5) { transition-delay: 0.5s; }
.bestsellers-section.visible .product-card:nth-child(6) { transition-delay: 0.6s; }

/* 分类项逐个显示 */
.category-item {
  opacity: 0;
  transform: translateY(20px);
  transition: all 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.categories-section.visible .category-item {
  opacity: 1;
  transform: translateY(0);
}

.categories-section.visible .category-item:nth-child(1) { transition-delay: 0.1s; }
.categories-section.visible .category-item:nth-child(2) { transition-delay: 0.2s; }
.categories-section.visible .category-item:nth-child(3) { transition-delay: 0.3s; }
.categories-section.visible .category-item:nth-child(4) { transition-delay: 0.4s; }

/* 承诺项逐个显示 */
.promise-item {
  opacity: 0;
  transform: translateY(20px);
  transition: all 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.promise-section.visible .promise-item {
  opacity: 1;
  transform: translateY(0);
}

.promise-section.visible .promise-item:nth-child(1) { transition-delay: 0.1s; }
.promise-section.visible .promise-item:nth-child(2) { transition-delay: 0.2s; }
.promise-section.visible .promise-item:nth-child(3) { transition-delay: 0.3s; }

/* 响应式设计 */
@media (max-width: 1024px) {
  .products-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .categories-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .featured-product {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .products-grid {
    grid-template-columns: 1fr;
  }

  .categories-grid {
    grid-template-columns: 1fr;
  }

  .promise-grid,
  .online-grid {
    grid-template-columns: 1fr;
  }

  .hero-title {
    font-size: 32px;
  }

  .highlight-icons {
    flex-wrap: wrap;
    gap: 20px;
  }
}
</style>
