<template>
  <section class="product-section">
    <div class="container">
      <!-- 产品分类标题 -->
      <div class="section-header">
        <h2 class="section-title">产品与解决方案</h2>
        <p class="section-subtitle">
          我们专注于科研创新、探索、开发并提供能让全球数百万人受益的美妆产品和解决方案。
        </p>
      </div>

      <!-- 产品分类网格 -->
      <div class="categories-grid">
        <div
          v-for="category in categories"
          :key="category.id"
          class="category-card"
          @click="viewCategory(category)"
        >
          <div class="category-image">
            <img
              v-if="category.image"
              :src="category.image"
              :alt="category.name"
              class="category-img"
            />
            <div v-else class="category-placeholder">
              <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
                <circle cx="24" cy="24" r="20" stroke="currentColor" stroke-width="2"/>
                <path d="M16 24L20 28L32 16" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
          </div>

          <div class="category-content">
            <h3 class="category-title">{{ category.name }}</h3>
            <p class="category-description">{{ category.description }}</p>
            <div class="category-meta">
              <span class="product-count">{{ category.product_count }} 个产品</span>
            </div>
          </div>

          <div class="category-arrow">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
              <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
        </div>
      </div>

      <!-- 推荐产品区域 -->
      <div v-if="featuredProducts.length" class="featured-products">
        <div class="featured-header">
          <h3 class="featured-title">推荐产品</h3>
          <router-link to="/products" class="view-all-link">
            查看全部产品
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
              <path d="M3.333 8H12.667" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
              <path d="M8 3.333L12.667 8L8 12.667" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </router-link>
        </div>

        <div class="products-grid">
          <div
            v-for="product in featuredProducts.slice(0, 6)"
            :key="product.id"
            class="product-card"
            @click="viewProduct(product)"
          >
            <div class="product-image">
              <img
                v-if="product.main_image"
                :src="product.main_image"
                :alt="product.title"
                class="product-img"
              />
              <div v-else class="product-placeholder">
                <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                  <rect x="4" y="4" width="24" height="24" rx="4" stroke="currentColor" stroke-width="2"/>
                  <circle cx="10" cy="12" r="2" fill="currentColor"/>
                  <path d="M4 20L8 16L12 20L20 12L28 20V28H4V20Z" fill="currentColor"/>
                </svg>
              </div>
              <div v-if="product.is_featured" class="featured-badge">推荐</div>
            </div>

            <div class="product-content">
              <h4 class="product-title">{{ product.title }}</h4>
              <p class="product-category">{{ product.category_name }}</p>
              <p class="product-description">{{ truncateText(product.description, 80) }}</p>

              <div class="product-meta">
                <div class="meta-item">
                  <span class="meta-label">起订量:</span>
                  <span class="meta-value">{{ product.min_order_quantity || '询价' }}</span>
                </div>
                <div class="meta-item">
                  <span class="meta-label">交期:</span>
                  <span class="meta-value">{{ product.production_time || '询价' }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'
import type { ProductCategory, ProductListItem } from '@/types'

interface Props {
  categories: ProductCategory[]
  featuredProducts: ProductListItem[]
}

const props = defineProps<Props>()
const router = useRouter()

// 查看分类
const viewCategory = (category: ProductCategory) => {
  router.push({
    name: 'Products',
    query: { category: category.id }
  })
}

// 查看产品详情
const viewProduct = (product: ProductListItem) => {
  router.push({
    name: 'ProductDetail',
    params: { id: product.id }
  })
}

// 截断文本
const truncateText = (text: string, length: number): string => {
  if (text.length <= length) return text
  return text.slice(0, length) + '...'
}
</script>

<style scoped>
.product-section {
  padding: 120px 0;
  background: var(--gray-bg);
}

/* 区域标题 */
.section-header {
  text-align: center;
  margin-bottom: 80px;
}

.section-title {
  font-size: 48px;
  font-weight: 300;
  color: var(--text-primary);
  margin-bottom: 24px;
  line-height: 1.2;
}

.section-subtitle {
  font-size: 20px;
  color: var(--text-secondary);
  line-height: 1.6;
  max-width: 800px;
  margin: 0 auto;
}

/* 产品分类网格 */
.categories-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 32px;
  margin-bottom: 100px;
}

.category-card {
  background: white;
  border-radius: 12px;
  padding: 32px;
  box-shadow: var(--shadow-sm);
  transition: all 0.3s ease;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 24px;
  position: relative;
}

.category-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
}

.category-image {
  flex-shrink: 0;
  width: 80px;
  height: 80px;
  border-radius: 12px;
  overflow: hidden;
  background: var(--gray-bg);
  display: flex;
  align-items: center;
  justify-content: center;
}

.category-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.category-placeholder {
  color: var(--primary-color);
}

.category-content {
  flex: 1;
}

.category-title {
  font-size: 24px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 12px;
}

.category-description {
  font-size: 16px;
  color: var(--text-secondary);
  line-height: 1.5;
  margin-bottom: 16px;
}

.category-meta {
  display: flex;
  align-items: center;
  gap: 16px;
}

.product-count {
  font-size: 14px;
  color: var(--primary-color);
  font-weight: 500;
}

.category-arrow {
  flex-shrink: 0;
  color: var(--text-muted);
  transition: color 0.3s ease;
}

.category-card:hover .category-arrow {
  color: var(--primary-color);
}

/* 推荐产品 */
.featured-products {
  margin-top: 80px;
}

.featured-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 48px;
}

.featured-title {
  font-size: 36px;
  font-weight: 400;
  color: var(--text-primary);
  margin: 0;
}

.view-all-link {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
  color: var(--primary-color);
  text-decoration: none;
  font-weight: 500;
  transition: color 0.3s ease;
}

.view-all-link:hover {
  color: var(--primary-dark);
}

.products-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 32px;
}

.product-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: var(--shadow-sm);
  transition: all 0.3s ease;
  cursor: pointer;
}

.product-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
}

.product-image {
  position: relative;
  width: 100%;
  height: 200px;
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

.product-placeholder {
  color: var(--text-muted);
}

.featured-badge {
  position: absolute;
  top: 12px;
  right: 12px;
  background: var(--primary-color);
  color: white;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.product-content {
  padding: 24px;
}

.product-title {
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 8px;
  line-height: 1.3;
}

.product-category {
  font-size: 14px;
  color: var(--primary-color);
  margin-bottom: 12px;
  font-weight: 500;
}

.product-description {
  font-size: 14px;
  color: var(--text-secondary);
  line-height: 1.5;
  margin-bottom: 16px;
}

.product-meta {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.meta-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.meta-label {
  font-size: 12px;
  color: var(--text-muted);
}

.meta-value {
  font-size: 12px;
  color: var(--text-primary);
  font-weight: 500;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .product-section {
    padding: 100px 0;
  }

  .section-title {
    font-size: 40px;
  }

  .section-subtitle {
    font-size: 18px;
  }

  .section-header {
    margin-bottom: 60px;
  }

  .categories-grid {
    gap: 24px;
    margin-bottom: 80px;
  }

  .featured-title {
    font-size: 32px;
  }
}

@media (max-width: 768px) {
  .product-section {
    padding: 80px 0;
  }

  .section-title {
    font-size: 32px;
  }

  .section-subtitle {
    font-size: 16px;
  }

  .section-header {
    margin-bottom: 48px;
  }

  .categories-grid {
    grid-template-columns: 1fr;
    gap: 20px;
    margin-bottom: 60px;
  }

  .category-card {
    padding: 24px;
    flex-direction: column;
    text-align: center;
  }

  .category-image {
    width: 60px;
    height: 60px;
  }

  .featured-header {
    flex-direction: column;
    gap: 16px;
    text-align: center;
    margin-bottom: 32px;
  }

  .featured-title {
    font-size: 28px;
  }

  .products-grid {
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 24px;
  }
}

@media (max-width: 480px) {
  .product-section {
    padding: 60px 0;
  }

  .section-title {
    font-size: 28px;
  }

  .section-subtitle {
    font-size: 14px;
  }

  .category-card {
    padding: 20px;
  }

  .category-title {
    font-size: 20px;
  }

  .category-description {
    font-size: 14px;
  }

  .featured-title {
    font-size: 24px;
  }

  .products-grid {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  .product-content {
    padding: 20px;
  }
}
</style>
