<template>
  <div class="news-page">
    <!-- 导航栏 -->
    <AppHeader />

    <!-- 页面标题区域 -->
    <section class="page-hero">
      <div class="container">
        <div class="hero-content">
          <h1 class="page-title">新闻资讯</h1>
          <p class="page-subtitle">
            了解最新的公司动态、行业资讯和技术分享
          </p>
        </div>
      </div>
    </section>

    <!-- 新闻内容区域 -->
    <section class="news-content">
      <div class="container">
        <!-- 筛选和搜索 -->
        <div class="news-filters">
          <div class="filter-tabs">
            <button
              v-for="(label, type) in newsTypes"
              :key="type"
              @click="setActiveType(type)"
              :class="['filter-tab', { active: activeType === type }]"
            >
              {{ label }}
            </button>
          </div>

          <div class="search-section">
            <div class="search-wrapper">
              <input
                v-model="searchQuery"
                @keyup.enter="onSearch"
                type="text"
                placeholder="搜索新闻..."
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

        <!-- 推荐新闻 -->
        <div v-if="featuredNews.length && activeType === ''" class="featured-news">
          <h2 class="featured-title">推荐新闻</h2>
          <div class="featured-grid">
            <div
              v-for="article in featuredNews.slice(0, 3)"
              :key="article.id"
              class="featured-card"
              @click="viewNews(article)"
            >
              <div class="featured-image">
                <img
                  v-if="article.featured_image"
                  :src="article.featured_image"
                  :alt="article.title"
                  class="featured-img"
                />
                <div v-else class="image-placeholder">
                  <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
                    <rect x="6" y="6" width="36" height="36" rx="6" stroke="currentColor" stroke-width="2"/>
                    <circle cx="18" cy="18" r="3" fill="currentColor"/>
                    <path d="M6 30L12 24L18 30L30 18L42 30V42H6V30Z" fill="currentColor"/>
                  </svg>
                </div>
                <div class="featured-badge">推荐</div>
              </div>

              <div class="featured-content">
                <div class="featured-meta">
                  <span class="news-type">{{ newsTypes[article.news_type] }}</span>
                  <span class="news-date">{{ formatDate(article.publish_date) }}</span>
                </div>
                <h3 class="featured-news-title">{{ article.title }}</h3>
                <p class="featured-summary">{{ article.summary }}</p>
                <div class="featured-footer">
                  <span class="news-author">{{ article.author_name }}</span>
                  <span class="news-read-count">{{ article.read_count }} 阅读</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 新闻列表 -->
        <div class="news-list-section">
          <div v-if="loading" class="loading-state">
            <div class="loading-spinner"></div>
            <p>加载中...</p>
          </div>

          <div v-else-if="error" class="error-state">
            <p>{{ error }}</p>
            <button @click="loadNews" class="btn btn-primary">重试</button>
          </div>

          <div v-else-if="news.length === 0" class="empty-state">
            <svg width="80" height="80" viewBox="0 0 80 80" fill="none">
              <circle cx="40" cy="40" r="30" stroke="currentColor" stroke-width="2"/>
              <path d="M55 25L25 55" stroke="currentColor" stroke-width="2"/>
              <path d="M25 25L55 55" stroke="currentColor" stroke-width="2"/>
            </svg>
            <h3>暂无新闻</h3>
            <p>请稍后查看或尝试其他筛选条件</p>
          </div>

          <div v-else class="news-grid">
            <article
              v-for="article in news"
              :key="article.id"
              class="news-card"
              @click="viewNews(article)"
            >
              <div class="news-image">
                <img
                  v-if="article.featured_image"
                  :src="article.featured_image"
                  :alt="article.title"
                  class="news-img"
                />
                <div v-else class="image-placeholder">
                  <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                    <rect x="4" y="4" width="24" height="24" rx="4" stroke="currentColor" stroke-width="2"/>
                    <circle cx="12" cy="12" r="2" fill="currentColor"/>
                    <path d="M4 20L8 16L12 20L20 12L28 20V28H4V20Z" fill="currentColor"/>
                  </svg>
                </div>
                <div v-if="article.is_featured" class="news-featured-badge">推荐</div>
              </div>

              <div class="news-card-content">
                <div class="news-meta">
                  <span class="news-type">{{ newsTypes[article.news_type] }}</span>
                  <span class="news-date">{{ formatDate(article.publish_date) }}</span>
                </div>

                <h3 class="news-title">{{ article.title }}</h3>
                <p class="news-summary">{{ truncateText(article.summary, 120) }}</p>

                <div class="news-footer">
                  <div class="news-author">
                    <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                      <circle cx="8" cy="4" r="2" stroke="currentColor" stroke-width="1.5"/>
                      <path d="M2 14C2 11.2386 4.68629 9 8 9C11.3137 9 14 11.2386 14 14" stroke="currentColor" stroke-width="1.5"/>
                    </svg>
                    {{ article.author_name }}
                  </div>
                  <div class="news-stats">
                    <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                      <circle cx="8" cy="8" r="6" stroke="currentColor" stroke-width="1.5"/>
                      <circle cx="8" cy="8" r="2" fill="currentColor"/>
                    </svg>
                    {{ article.read_count }}
                  </div>
                </div>
              </div>
            </article>
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
      </div>
    </section>

    <!-- 页脚 -->
    <AppFooter />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useNewsStore } from '@/stores'
import { storeToRefs } from 'pinia'
import { NEWS_TYPE_LABELS } from '@/types'

// 组件导入
import AppHeader from '@/components/AppHeader.vue'
import AppFooter from '@/components/AppFooter.vue'

// 状态管理
const newsStore = useNewsStore()
const { news, featuredNews, newsTotal, loading, error } = storeToRefs(newsStore)

const route = useRoute()
const router = useRouter()

// 响应式状态
const searchQuery = ref('')
const activeType = ref('')
const currentPage = ref(1)
const pageSize = 12

// 新闻类型
const newsTypes = {
  '': '全部',
  ...NEWS_TYPE_LABELS
}

// 计算属性
const totalPages = computed(() => Math.ceil(newsTotal.value / pageSize))

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
const loadNews = async () => {
  const params = {
    page: currentPage.value,
    page_size: pageSize,
    search: searchQuery.value || undefined,
    ordering: '-publish_date',
  }

  if (activeType.value) {
    await newsStore.getNewsByType(activeType.value, params)
  } else {
    await newsStore.getNews(params)
  }
}

const setActiveType = (type: string) => {
  activeType.value = type
  currentPage.value = 1
  loadNews()

  // 更新URL参数
  router.push({
    query: {
      ...route.query,
      type: type || undefined,
      page: undefined
    }
  })
}

const onSearch = () => {
  currentPage.value = 1
  loadNews()

  // 更新URL参数
  router.push({
    query: {
      ...route.query,
      search: searchQuery.value || undefined,
      page: undefined
    }
  })
}

const goToPage = (page: number) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
    loadNews()
  }
}

const viewNews = (article: any) => {
  router.push({
    name: 'NewsDetail',
    params: { id: article.id }
  })
}

const formatDate = (dateString: string): string => {
  if (!dateString) return ''
  try {
    const date = new Date(dateString)
    return date.toLocaleDateString('zh-CN')
  } catch {
    return ''
  }
}

const truncateText = (text: string, length: number): string => {
  if (text.length <= length) return text
  return text.slice(0, length) + '...'
}

// 初始化
onMounted(async () => {
  // 从URL参数初始化状态
  searchQuery.value = (route.query.search as string) || ''
  activeType.value = (route.query.type as string) || ''
  currentPage.value = Number(route.query.page) || 1

  // 加载数据
  await newsStore.getFeaturedNews()
  await loadNews()
})

// 监听路由变化
watch(
  () => route.query,
  (newQuery) => {
    searchQuery.value = (newQuery.search as string) || ''
    activeType.value = (newQuery.type as string) || ''
    currentPage.value = Number(newQuery.page) || 1
    loadNews()
  }
)
</script>

<style scoped>
.news-page {
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
  text-align: center;
  position: relative;
  z-index: 1;
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

/* 新闻内容区域 */
.news-content {
  flex: 1;
  padding: 80px 0 120px;
  background: var(--gray-bg);
}

/* 筛选和搜索 */
.news-filters {
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

.filter-tabs {
  display: flex;
  gap: 8px;
}

.filter-tab {
  padding: 12px 24px;
  border: 2px solid var(--border-color);
  background: white;
  color: var(--text-secondary);
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.filter-tab:hover {
  border-color: var(--primary-color);
  color: var(--primary-color);
}

.filter-tab.active {
  background: var(--primary-color);
  border-color: var(--primary-color);
  color: white;
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

/* 推荐新闻 */
.featured-news {
  margin-bottom: 60px;
}

.featured-title {
  font-size: 32px;
  font-weight: 400;
  color: var(--text-primary);
  margin-bottom: 32px;
}

.featured-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  gap: 32px;
}

.featured-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: var(--shadow-sm);
  transition: all 0.3s ease;
  cursor: pointer;
}

.featured-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
}

.featured-image {
  position: relative;
  width: 100%;
  height: 200px;
  background: var(--gray-bg);
  display: flex;
  align-items: center;
  justify-content: center;
}

.featured-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.image-placeholder {
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

.featured-content {
  padding: 24px;
}

.featured-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.news-type {
  font-size: 12px;
  color: var(--primary-color);
  font-weight: 500;
  background: rgba(100, 183, 178, 0.1);
  padding: 4px 8px;
  border-radius: 4px;
}

.news-date {
  font-size: 12px;
  color: var(--text-muted);
}

.featured-news-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 12px;
  line-height: 1.4;
}

.featured-summary {
  font-size: 14px;
  color: var(--text-secondary);
  line-height: 1.5;
  margin-bottom: 16px;
}

.featured-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 12px;
  color: var(--text-muted);
}

.news-author,
.news-read-count {
  font-weight: 500;
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

/* 新闻网格 */
.news-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 32px;
}

.news-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: var(--shadow-sm);
  transition: all 0.3s ease;
  cursor: pointer;
}

.news-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
}

.news-image {
  position: relative;
  width: 100%;
  height: 180px;
  background: var(--gray-bg);
  display: flex;
  align-items: center;
  justify-content: center;
}

.news-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.news-featured-badge {
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

.news-card-content {
  padding: 20px;
}

.news-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.news-title {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 12px;
  line-height: 1.4;
}

.news-summary {
  font-size: 14px;
  color: var(--text-secondary);
  line-height: 1.5;
  margin-bottom: 16px;
}

.news-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 12px;
  color: var(--text-muted);
}

.news-footer .news-author,
.news-footer .news-stats {
  display: flex;
  align-items: center;
  gap: 4px;
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

  .news-filters {
    flex-direction: column;
    gap: 24px;
    align-items: stretch;
  }

  .filter-tabs {
    justify-content: center;
  }

  .search-section {
    align-self: center;
  }

  .featured-grid {
    grid-template-columns: 1fr;
  }

  .news-grid {
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

  .news-content {
    padding: 60px 0 80px;
  }

  .news-filters {
    padding: 24px;
  }

  .filter-tabs {
    flex-wrap: wrap;
  }

  .filter-tab {
    padding: 10px 16px;
    font-size: 12px;
  }

  .search-input {
    width: 100%;
  }

  .featured-title {
    font-size: 28px;
  }

  .news-grid {
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 20px;
  }

  .news-card-content {
    padding: 16px;
  }
}

@media (max-width: 480px) {
  .page-title {
    font-size: 28px;
  }

  .news-grid {
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
