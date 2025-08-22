<template>
  <div class="product-detail-page">
    <!-- 导航栏 -->
    <AppHeader />

    <div v-if="loading" class="loading-state">
      <div class="container">
        <div class="loading-spinner"></div>
        <p>加载中...</p>
      </div>
    </div>

    <div v-else-if="error" class="error-state">
      <div class="container">
        <h2>加载失败</h2>
        <p>{{ error }}</p>
        <router-link to="/products" class="btn btn-primary">返回产品列表</router-link>
      </div>
    </div>

    <div v-else-if="product" class="product-detail-content">
      <!-- 面包屑导航 -->
      <section class="breadcrumb-section">
        <div class="container">
          <nav class="breadcrumb">
            <router-link to="/" class="breadcrumb-link">首页</router-link>
            <span class="breadcrumb-separator">/</span>
            <router-link to="/products" class="breadcrumb-link">产品中心</router-link>
            <span class="breadcrumb-separator">/</span>
            <span class="breadcrumb-current">{{ product.title }}</span>
          </nav>
        </div>
      </section>

      <!-- 产品主要信息 -->
      <section class="product-main">
        <div class="container">
          <div class="product-layout">
            <!-- 产品图片 -->
            <div class="product-gallery">
              <div class="main-image">
                <img
                  v-if="currentImage"
                  :src="currentImage"
                  :alt="product.title"
                  class="product-img"
                />
                <div v-else class="image-placeholder">
                  <svg width="200" height="200" viewBox="0 0 200 200" fill="none">
                    <rect x="25" y="25" width="150" height="150" rx="12" stroke="currentColor" stroke-width="2"/>
                    <circle cx="75" cy="75" r="15" fill="currentColor"/>
                    <path d="M25 125L50 100L75 125L125 75L175 125V175H25V125Z" fill="currentColor"/>
                  </svg>
                </div>
              </div>

              <div v-if="product.gallery_images?.length > 1" class="thumbnail-list">
                <button
                  v-for="(image, index) in galleryImages"
                  :key="index"
                  @click="setCurrentImage(image)"
                  :class="['thumbnail', { active: currentImage === image }]"
                >
                  <img :src="image" :alt="`${product.title} - 图片 ${index + 1}`" />
                </button>
              </div>
            </div>

            <!-- 产品信息 -->
            <div class="product-info">
              <div class="product-header">
                <div class="product-category">{{ product.category_name }}</div>
                <h1 class="product-title">{{ product.title }}</h1>
                <div v-if="product.is_featured" class="featured-badge">推荐产品</div>
              </div>

              <div class="product-description">
                <p>{{ product.description }}</p>
              </div>

              <!-- 关键信息 -->
              <div class="product-specs">
                <div class="spec-item">
                  <span class="spec-label">起订量：</span>
                  <span class="spec-value">{{ product.min_order_quantity || '询价' }}</span>
                </div>
                <div class="spec-item">
                  <span class="spec-label">生产周期：</span>
                  <span class="spec-value">{{ product.production_time || '询价' }}</span>
                </div>
                <div v-if="product.skin_type" class="spec-item">
                  <span class="spec-label">适用肌肤：</span>
                  <span class="spec-value">{{ product.skin_type }}</span>
                </div>
              </div>

              <!-- 操作按钮 -->
              <div class="product-actions">
                <router-link to="/contact" class="btn btn-primary btn-large">
                  立即咨询
                </router-link>
                <a href="tel:400-888-9999" class="btn btn-outline btn-large">
                  电话咨询
                </a>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- 产品详情标签页 -->
      <section class="product-details">
        <div class="container">
          <div class="detail-tabs">
            <button
              v-for="(tab, key) in tabs"
              :key="key"
              @click="activeTab = key"
              :class="['tab-btn', { active: activeTab === key }]"
            >
              {{ tab.label }}
            </button>
          </div>

          <div class="tab-content">
            <!-- 产品特点 -->
            <div v-if="activeTab === 'features'" class="tab-panel">
              <h3 class="panel-title">产品特点</h3>
              <div class="content-text">
                <p v-if="product.features">{{ product.features }}</p>
                <p v-else>暂无详细特点介绍</p>
              </div>
            </div>

            <!-- 产品规格 -->
            <div v-if="activeTab === 'specifications'" class="tab-panel">
              <h3 class="panel-title">产品规格</h3>
              <div class="content-text">
                <p v-if="product.specifications">{{ product.specifications }}</p>
                <p v-else>暂无规格信息</p>
              </div>
            </div>

            <!-- 主要成分 -->
            <div v-if="activeTab === 'ingredients'" class="tab-panel">
              <h3 class="panel-title">主要成分</h3>
              <div class="content-text">
                <p v-if="product.ingredients">{{ product.ingredients }}</p>
                <p v-else>暂无成分信息</p>
              </div>
            </div>

            <!-- 使用方法 -->
            <div v-if="activeTab === 'usage'" class="tab-panel">
              <h3 class="panel-title">使用方法</h3>
              <div class="content-text">
                <p v-if="product.usage_method">{{ product.usage_method }}</p>
                <p v-else>暂无使用方法</p>
              </div>
            </div>

            <!-- 定制选项 -->
            <div v-if="activeTab === 'customization'" class="tab-panel">
              <h3 class="panel-title">定制选项</h3>
              <div class="content-text">
                <p v-if="product.customization_options">{{ product.customization_options }}</p>
                <p v-else>暂无定制选项信息</p>
              </div>
            </div>

            <!-- 质量认证 -->
            <div v-if="activeTab === 'certifications'" class="tab-panel">
              <h3 class="panel-title">质量认证</h3>
              <div class="certifications-grid">
                <div
                  v-for="cert in product.certifications"
                  :key="cert"
                  class="cert-item"
                >
                  <div class="cert-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                      <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
                      <path d="M9 12L11 14L15 10" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                  </div>
                  <span class="cert-name">{{ cert }}</span>
                </div>
              </div>

              <div v-if="product.quality_standards?.length" class="quality-standards">
                <h4 class="standards-title">质量标准</h4>
                <ul class="standards-list">
                  <li v-for="standard in product.quality_standards" :key="standard">
                    {{ standard }}
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>

    <!-- 页脚 -->
    <AppFooter />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useProductStore } from '@/stores'
import { storeToRefs } from 'pinia'

// 组件导入
import AppHeader from '@/components/AppHeader.vue'
import AppFooter from '@/components/AppFooter.vue'

// 状态管理
const productStore = useProductStore()
const { currentProduct: product, loading, error } = storeToRefs(productStore)

const route = useRoute()

// 响应式状态
const activeTab = ref('features')
const currentImage = ref('')

// 标签页配置
const tabs = {
  features: { label: '产品特点' },
  specifications: { label: '产品规格' },
  ingredients: { label: '主要成分' },
  usage: { label: '使用方法' },
  customization: { label: '定制选项' },
  certifications: { label: '质量认证' }
}

// 计算属性
const galleryImages = computed(() => {
  if (!product.value) return []
  const images = []
  if (product.value.main_image) {
    images.push(product.value.main_image)
  }
  if (product.value.gallery_images) {
    images.push(...product.value.gallery_images)
  }
  return images
})

// 方法
const setCurrentImage = (image: string) => {
  currentImage.value = image
}

// 初始化
onMounted(async () => {
  const productId = Number(route.params.id)
  if (productId) {
    const productData = await productStore.getProductById(productId)
    if (productData && galleryImages.value.length > 0) {
      currentImage.value = galleryImages.value[0]
    }
  }
})
</script>

<style scoped>
.product-detail-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  padding-top: 90px;
}

/* 状态显示 */
.loading-state,
.error-state {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 120px 0;
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

.error-state h2 {
  color: var(--text-primary);
  margin-bottom: 16px;
}

/* 产品详情内容 */
.product-detail-content {
  flex: 1;
}

/* 面包屑导航 */
.breadcrumb-section {
  padding: 24px 0;
  background: var(--gray-bg);
  border-bottom: 1px solid var(--border-color);
}

.breadcrumb {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
}

.breadcrumb-link {
  color: var(--text-secondary);
  text-decoration: none;
  transition: color 0.3s ease;
}

.breadcrumb-link:hover {
  color: var(--primary-color);
}

.breadcrumb-separator {
  color: var(--text-muted);
}

.breadcrumb-current {
  color: var(--text-primary);
  font-weight: 500;
}

/* 产品主要信息 */
.product-main {
  padding: 60px 0;
  background: var(--section-bg);
}

.product-layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 80px;
  align-items: flex-start;
}

/* 产品图片画廊 */
.product-gallery {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.main-image {
  width: 100%;
  aspect-ratio: 1;
  border-radius: 12px;
  overflow: hidden;
  background: var(--gray-bg);
  display: flex;
  align-items: center;
  justify-content: center;
}

.product-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.image-placeholder {
  color: var(--text-muted);
}

.thumbnail-list {
  display: flex;
  gap: 12px;
  overflow-x: auto;
  padding: 4px;
}

.thumbnail {
  flex-shrink: 0;
  width: 80px;
  height: 80px;
  border: 2px solid transparent;
  border-radius: 8px;
  overflow: hidden;
  background: none;
  cursor: pointer;
  transition: border-color 0.3s ease;
}

.thumbnail:hover {
  border-color: var(--primary-color);
}

.thumbnail.active {
  border-color: var(--primary-color);
}

.thumbnail img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* 产品信息 */
.product-info {
  display: flex;
  flex-direction: column;
  gap: 32px;
}

.product-header {
  position: relative;
}

.product-category {
  font-size: 14px;
  color: var(--primary-color);
  font-weight: 500;
  margin-bottom: 8px;
}

.product-title {
  font-size: 36px;
  font-weight: 400;
  color: var(--text-primary);
  line-height: 1.2;
  margin-bottom: 16px;
}

.featured-badge {
  position: absolute;
  top: 0;
  right: 0;
  background: var(--primary-color);
  color: white;
  padding: 6px 16px;
  border-radius: 16px;
  font-size: 12px;
  font-weight: 500;
}

.product-description {
  font-size: 16px;
  color: var(--text-secondary);
  line-height: 1.6;
}

/* 产品规格 */
.product-specs {
  background: var(--gray-bg);
  padding: 24px;
  border-radius: 8px;
}

.spec-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid var(--border-light);
}

.spec-item:last-child {
  border-bottom: none;
}

.spec-label {
  font-size: 14px;
  color: var(--text-secondary);
  font-weight: 500;
}

.spec-value {
  font-size: 14px;
  color: var(--text-primary);
  font-weight: 600;
}

/* 操作按钮 */
.product-actions {
  display: flex;
  gap: 16px;
}

.btn-large {
  padding: 16px 32px;
  font-size: 16px;
  font-weight: 500;
  flex: 1;
  text-align: center;
}

/* 产品详情标签页 */
.product-details {
  padding: 80px 0;
  background: var(--gray-bg);
}

.detail-tabs {
  display: flex;
  border-bottom: 2px solid var(--border-color);
  margin-bottom: 40px;
  overflow-x: auto;
}

.tab-btn {
  padding: 16px 24px;
  background: none;
  border: none;
  font-size: 16px;
  font-weight: 500;
  color: var(--text-secondary);
  cursor: pointer;
  border-bottom: 2px solid transparent;
  transition: all 0.3s ease;
  white-space: nowrap;
}

.tab-btn:hover {
  color: var(--primary-color);
}

.tab-btn.active {
  color: var(--primary-color);
  border-bottom-color: var(--primary-color);
}

.tab-content {
  background: white;
  border-radius: 12px;
  padding: 40px;
  box-shadow: var(--shadow-sm);
}

.tab-panel {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.panel-title {
  font-size: 24px;
  font-weight: 500;
  color: var(--text-primary);
  margin-bottom: 24px;
}

.content-text {
  font-size: 16px;
  color: var(--text-secondary);
  line-height: 1.6;
}

/* 认证网格 */
.certifications-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
  margin-bottom: 32px;
}

.cert-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px;
  background: var(--gray-bg);
  border-radius: 8px;
}

.cert-icon {
  color: var(--primary-color);
  flex-shrink: 0;
}

.cert-name {
  font-size: 14px;
  color: var(--text-primary);
  font-weight: 500;
}

.quality-standards {
  padding-top: 24px;
  border-top: 1px solid var(--border-color);
}

.standards-title {
  font-size: 18px;
  font-weight: 500;
  color: var(--text-primary);
  margin-bottom: 16px;
}

.standards-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.standards-list li {
  padding: 8px 0;
  font-size: 14px;
  color: var(--text-secondary);
  border-bottom: 1px solid var(--border-light);
}

.standards-list li:last-child {
  border-bottom: none;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .product-layout {
    gap: 60px;
  }

  .product-title {
    font-size: 32px;
  }

  .tab-content {
    padding: 32px;
  }
}

@media (max-width: 768px) {
  .product-main {
    padding: 40px 0;
  }

  .product-layout {
    grid-template-columns: 1fr;
    gap: 40px;
  }

  .product-title {
    font-size: 28px;
  }

  .product-actions {
    flex-direction: column;
  }

  .detail-tabs {
    overflow-x: auto;
  }

  .tab-btn {
    padding: 12px 16px;
    font-size: 14px;
  }

  .tab-content {
    padding: 24px;
  }

  .panel-title {
    font-size: 20px;
  }

  .certifications-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .product-title {
    font-size: 24px;
  }

  .tab-content {
    padding: 20px;
  }

  .thumbnail-list {
    justify-content: center;
  }
}
</style>
