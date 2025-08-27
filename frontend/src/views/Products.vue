<template>
  <div class="products-page">
    <!-- 导航栏 -->
    <AppHeader />

    <!-- 页面标题区域 -->
    <section class="page-hero">
      <div class="container">
        <div class="hero-content">
          <h1 class="page-title">产品中心</h1>
          <p class="page-subtitle">
            探索我们全面的美妆产品解决方案，为您的品牌创造无限可能
          </p>
        </div>
      </div>
    </section>

    <!-- 产品列表区域 -->
    <section class="products-content">
      <div class="container">
        <!-- 筛选和搜索 -->
        <div class="products-filters">
          <div class="filter-section">
            <div class="filter-group">
              <label class="filter-label">分类筛选：</label>
              <select v-model="selectedCategory" @change="onFilterChange" class="filter-select">
                <option value="">全部分类</option>
                <option
                  v-for="category in categories"
                  :key="category.id"
                  :value="category.id"
                >
                  {{ category.name }}
                </option>
              </select>
            </div>

            <div class="filter-group">
              <label class="filter-label">排序方式：</label>
              <select v-model="sortOrder" @change="onFilterChange" class="filter-select">
                <option value="-created_at">最新产品</option>
                <option value="title">名称排序</option>
                <option value="-is_featured">推荐优先</option>
              </select>
            </div>
          </div>

          <div class="search-section">
            <div class="search-wrapper">
              <input
                v-model="searchQuery"
                @keyup.enter="onSearch"
                type="text"
                placeholder="搜索产品..."
                class="search-input"
              />
              <button @click="onSearch" class="search-btn">
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                  <path d="M9 17C13.4183 17 17 13.4183 17 9C17 4.58172 13.4183 1 9 1C4.58172 1 1 4.58172 1 9C1 13.4183 4.58172 17 9 17Z" stroke="currentColor" stroke-width="2"/>
                  <path d="m19 19-4.35-4.35" stroke="currentColor" stroke-width="2"/>
                </svg>
              </button>
            </div>
          </div>
        </div>

        <!-- 产品网格 -->
        <div v-if="loading" class="loading-state">
          <div class="loading-spinner"></div>
          <p>加载中...</p>
        </div>

        <div v-else-if="error" class="error-state">
          <p>{{ error }}</p>
          <button @click="loadProducts" class="btn btn-primary">重试</button>
        </div>

        <div v-else-if="products.length === 0" class="empty-state">
          <svg width="80" height="80" viewBox="0 0 80 80" fill="none">
            <circle cx="40" cy="40" r="30" stroke="currentColor" stroke-width="2"/>
            <path d="M55 25L25 55" stroke="currentColor" stroke-width="2"/>
            <path d="M25 25L55 55" stroke="currentColor" stroke-width="2"/>
          </svg>
          <h3>未找到相关产品</h3>
          <p>请尝试其他搜索条件或浏览全部产品</p>
          <button @click="clearFilters" class="btn btn-outline">清除筛选</button>
        </div>

        <div v-else class="products-grid">
          <div
            v-for="product in products"
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
                <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
                  <rect x="6" y="6" width="36" height="36" rx="6" stroke="currentColor" stroke-width="2"/>
                  <circle cx="18" cy="18" r="3" fill="currentColor"/>
                  <path d="M6 30L12 24L18 30L30 18L42 30V42H6V30Z" fill="currentColor"/>
                </svg>
              </div>
              <div v-if="product.is_featured" class="featured-badge">推荐</div>
            </div>

            <div class="product-content">
              <h3 class="product-title">{{ product.title }}</h3>
              <p class="product-category">{{ product.category_name }}</p>
              <p class="product-description">{{ truncateText(product.description, 100) }}</p>

              <div class="product-meta">
                <div class="meta-row">
                  <span class="meta-label">起订量:</span>
                  <span class="meta-value">{{ product.min_order_quantity || '询价' }}</span>
                </div>
                <div class="meta-row">
                  <span class="meta-label">交期:</span>
                  <span class="meta-value">{{ product.production_time || '询价' }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 分页 -->
        <div v-if="totalPages > 1" class="pagination">
          <button
            @click="goToPage(currentPage - 1)"
            :disabled="currentPage <= 1"
            class="pagination-btn"
          >
            上一页
          </button>

          <div class="pagination-numbers">
            <button
              v-for="page in visiblePages"
              :key="page"
              @click="goToPage(page)"
              :class="['pagination-btn', { active: page === currentPage }]"
            >
              {{ page }}
            </button>
          </div>

          <button
            @click="goToPage(currentPage + 1)"
            :disabled="currentPage >= totalPages"
            class="pagination-btn"
          >
            下一页
          </button>
        </div>
      </div>
    </section>

    <!-- 页脚 -->
    <AppFooter />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useProductStore } from '@/stores'
import { storeToRefs } from 'pinia'

// 组件导入
import AppHeader from '@/components/AppHeader.vue'
import AppFooter from '@/components/AppFooter.vue'

// 状态管理
const productStore = useProductStore()
const { products, categories, productsTotal, loading, error } = storeToRefs(productStore)

const route = useRoute()
const router = useRouter()

// 响应式状态
const searchQuery = ref('')
const selectedCategory = ref('')
const sortOrder = ref('-created_at')
const currentPage = ref(1)
const pageSize = 12

// 计算属性
const totalPages = computed(() => Math.ceil(productsTotal.value / pageSize))

const visiblePages = computed(() => {
  const total = totalPages.value
  const current = currentPage.value
  const pages = []

  let start = Math.max(1, current - 2)
  let end = Math.min(total, current + 2)

  if (end - start < 4) {
    start = Math.max(1, end - 4)
  }

  for (let i = start; i <= end; i++) {
    pages.push(i)
  }

  return pages
})

// 方法
const loadProducts = async () => {
  const params = {
    page: currentPage.value,
    page_size: pageSize,
    search: searchQuery.value || undefined,
    category: selectedCategory.value || undefined,
    ordering: sortOrder.value,
  }

  if (selectedCategory.value) {
    await productStore.getCategoryProducts(Number(selectedCategory.value), params)
  } else {
    await productStore.getProducts(params)
  }
}

const onFilterChange = () => {
  currentPage.value = 1
  loadProducts()
}

const onSearch = () => {
  currentPage.value = 1
  loadProducts()

  // 更新URL参数
  router.push({
    query: {
      ...route.query,
      search: searchQuery.value || undefined,
      category: selectedCategory.value || undefined,
      page: undefined
    }
  })
}

const clearFilters = () => {
  searchQuery.value = ''
  selectedCategory.value = ''
  sortOrder.value = '-created_at'
  currentPage.value = 1
  router.push({ query: {} })
  loadProducts()
}

const goToPage = (page: number) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
    loadProducts()
  }
}

const viewProduct = (product: any) => {
  router.push({
    name: 'ProductDetail',
    params: { id: product.id }
  })
}

const truncateText = (text: string, length: number): string => {
  if (text.length <= length) return text
  return text.slice(0, length) + '...'
}

// 初始化
onMounted(async () => {
  // 从URL参数初始化状态
  searchQuery.value = (route.query.search as string) || ''
  selectedCategory.value = (route.query.category as string) || ''
  currentPage.value = Number(route.query.page) || 1

  // 加载数据
  await productStore.getCategories()
  await loadProducts()
})

// 监听路由变化
watch(
  () => route.query,
  (newQuery) => {
    searchQuery.value = (newQuery.search as string) || ''
    selectedCategory.value = (newQuery.category as string) || ''
    currentPage.value = Number(newQuery.page) || 1
    loadProducts()
  }
)
</script>

<style scoped>
.products-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

/* 页面标题区域 */
.page-hero {
  padding: 120px 0 80px;
  background: linear-gradient(135deg, #000000 0%, #2a2a2a 50%, #000000 100%);
  color: white;
  margin-top: 90px;
  position: relative;
}

.page-hero::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background:
    radial-gradient(circle at 20% 30%, rgba(255,255,255,0.3) 2%, transparent 3%),
    radial-gradient(circle at 80% 70%, rgba(255,255,255,0.2) 1%, transparent 2%),
    radial-gradient(circle at 60% 20%, rgba(255,255,255,0.1) 3%, transparent 4%);
  background-size: 100px 100px, 150px 150px, 80px 80px;
}

.hero-content {
  position: relative;
  z-index: 1;
}

.hero-content {
  text-align: center;
}

.page-title {
  font-size: 48px;
  font-weight: 300;
  margin-bottom: 24px;
  line-height: 1.2;
}

.page-subtitle {
  font-size: 20px;
  opacity: 0.9;
  max-width: 600px;
  margin: 0 auto;
  line-height: 1.5;
}

/* 产品内容区域 */
.products-content {
  flex: 1;
  padding: 80px 0 120px;
  background: var(--gray-bg);
}

/* 筛选和搜索 */
.products-filters {
  background: white;
  border-radius: 12px;
  padding: 32px;
  margin-bottom: 48px;
  box-shadow: var(--shadow-sm);
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 32px;
}

.filter-section {
  display: flex;
  gap: 24px;
  align-items: center;
}

.filter-group {
  display: flex;
  align-items: center;
  gap: 8px;
}

.filter-label {
  font-size: 14px;
  color: var(--text-secondary);
  white-space: nowrap;
}

.filter-select {
  padding: 8px 12px;
  border: 2px solid var(--border-color);
  border-radius: 6px;
  font-size: 14px;
  background: white;
  color: var(--text-primary);
  min-width: 120px;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23666' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right 8px center;
  background-size: 16px;
  padding-right: 32px;
}

.filter-select:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
}

/* 完全自定义下拉选项样式 */
.filter-select option {
  background: white !important;
  color: var(--text-primary) !important;
  padding: 8px 12px !important;
  border: none !important;
  outline: none !important;
  font-size: 14px !important;
  line-height: 1.4 !important;
}

/* 选项悬停和选中状态 - 黑白主题 */
.filter-select option:hover {
  background: #000000 !important;
  background: var(--primary-color) !important;
  color: white !important;
}

.filter-select option:checked,
.filter-select option:focus,
.filter-select option[selected] {
  background: #000000 !important;
  background: var(--primary-color) !important;
  color: white !important;
  font-weight: 500 !important;
}

/* 浏览器兼容性 - 移除默认样式 */
.filter-select::-webkit-scrollbar {
  width: 6px;
}

.filter-select::-webkit-scrollbar-track {
  background: #f1f1f1;
  border: none;
}

.filter-select::-webkit-scrollbar-thumb {
  background: var(--primary-color);
  border-radius: 3px;
}

.filter-select::-webkit-scrollbar-thumb:hover {
  background: var(--primary-dark);
}

/* 针对 WebKit 浏览器的下拉选项样式 */
.filter-select option:not(:checked) {
  background-color: white !important;
  color: var(--text-primary) !important;
}

/* 确保选中项的黑色背景 */
.filter-select option:checked {
  background: linear-gradient(135deg, #000000, #333333) !important;
  color: white !important;
  box-shadow: none !important;
  border: none !important;
}

.search-section {
  flex-shrink: 0;
}

.search-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.search-input {
  padding: 12px 50px 12px 16px;
  border: 2px solid var(--border-color);
  border-radius: 8px;
  font-size: 14px;
  width: 280px;
  background: white;
}

.search-input:focus {
  outline: none;
  border-color: var(--primary-color);
}

.search-btn {
  position: absolute;
  right: 8px;
  background: none;
  border: none;
  color: var(--text-muted);
  cursor: pointer;
  padding: 8px;
  border-radius: 4px;
}

.search-btn:hover {
  color: var(--primary-color);
  background: var(--gray-bg);
}

/* 状态显示 */
.loading-state,
.error-state,
.empty-state {
  text-align: center;
  padding: 80px 20px;
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

.empty-state svg {
  color: var(--text-muted);
  margin-bottom: 24px;
}

.empty-state h3 {
  font-size: 24px;
  color: var(--text-primary);
  margin-bottom: 12px;
}

/* 产品网格 */
.products-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
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
  height: 240px;
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

.meta-row {
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

/* 分页 */
.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
  margin-top: 60px;
}

.pagination-numbers {
  display: flex;
  gap: 8px;
}

.pagination-btn {
  padding: 12px 16px;
  border: 2px solid var(--border-color);
  background: white;
  color: var(--text-primary);
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.pagination-btn:hover:not(:disabled) {
  border-color: var(--primary-color);
  color: var(--primary-color);
}

.pagination-btn.active {
  background: var(--primary-color);
  border-color: var(--primary-color);
  color: white;
}

.pagination-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .page-title {
    font-size: 40px;
  }

  .page-subtitle {
    font-size: 18px;
  }

  .products-filters {
    flex-direction: column;
    gap: 24px;
    align-items: stretch;
  }

  .filter-section {
    justify-content: center;
  }

  .search-section {
    align-self: center;
  }

  .products-grid {
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 24px;
  }
}

@media (max-width: 768px) {
  .page-hero {
    padding: 100px 0 60px;
  }

  .page-title {
    font-size: 32px;
  }

  .page-subtitle {
    font-size: 16px;
  }

  .products-content {
    padding: 60px 0 80px;
  }

  .products-filters {
    padding: 24px;
  }

  .filter-section {
    flex-direction: column;
    gap: 16px;
  }

  .filter-group {
    flex-direction: column;
    align-items: flex-start;
    gap: 4px;
  }

  .filter-select {
    width: 100%;
    min-width: auto;
  }

  .search-input {
    width: 100%;
  }

  .products-grid {
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 20px;
  }

  .product-content {
    padding: 20px;
  }
}

@media (max-width: 480px) {
  .page-title {
    font-size: 28px;
  }

  .products-grid {
    grid-template-columns: 1fr;
  }

  .pagination {
    flex-direction: column;
    gap: 12px;
  }

  .pagination-numbers {
    order: -1;
  }
}
</style>
