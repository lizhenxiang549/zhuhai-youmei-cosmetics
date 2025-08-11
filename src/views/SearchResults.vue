<template>
  <div class="search-results-page">
    <!-- 导航栏 -->
    <AppHeader />

    <!-- 页面标题区域 -->
    <section class="page-hero">
      <div class="container">
        <div class="hero-content">
          <h1 class="page-title">搜索结果</h1>
          <p class="page-subtitle" v-if="searchQuery">
            关于 "{{ searchQuery }}" 的搜索结果
          </p>
        </div>
      </div>
    </section>

    <!-- 搜索结果内容 -->
    <section class="search-content">
      <div class="container">
        <!-- 搜索统计信息 -->
        <div class="search-stats" v-if="!loading">
          <p class="stats-text">
            找到 <strong>{{ searchResults.total }}</strong> 个相关结果
            <span v-if="searchQuery">关于 "<strong>{{ searchQuery }}</strong>"</span>
          </p>
        </div>

        <!-- 搜索框 -->
        <div class="search-form">
          <div class="search-wrapper">
            <input
              v-model="searchQuery"
              @keyup.enter="performSearch"
              type="text"
              placeholder="输入关键词搜索..."
              class="search-input"
            />
            <button @click="performSearch" class="search-btn">
              <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                <path d="M9 17C13.4183 17 17 13.4183 17 9C17 4.58172 13.4183 1 9 1C4.58172 1 1 4.58172 1 9C1 13.4183 4.58172 17 9 17Z" stroke="currentColor" stroke-width="2"/>
                <path d="m19 19-4.35-4.35" stroke="currentColor" stroke-width="2"/>
              </svg>
              搜索
            </button>
          </div>
        </div>

        <!-- 筛选器 -->
        <div class="search-filters" v-if="searchResults.results?.length">
          <div class="filter-tabs">
            <button
              v-for="(label, type) in resultTypes"
              :key="type"
              @click="setActiveType(type)"
              :class="['filter-tab', { active: activeType === type }]"
            >
              {{ label }} ({{ getTypeCount(type) }})
            </button>
          </div>
        </div>

        <!-- 加载状态 -->
        <div v-if="loading" class="loading-state">
          <div class="loading-spinner"></div>
          <p>搜索中...</p>
        </div>

        <!-- 错误状态 -->
        <div v-else-if="error" class="error-state">
          <svg width="80" height="80" viewBox="0 0 80 80" fill="none">
            <circle cx="40" cy="40" r="30" stroke="currentColor" stroke-width="2"/>
            <path d="M55 25L25 55" stroke="currentColor" stroke-width="2"/>
            <path d="M25 25L55 55" stroke="currentColor" stroke-width="2"/>
          </svg>
          <h3>搜索失败</h3>
          <p>{{ error }}</p>
          <button @click="performSearch" class="btn btn-primary">重试</button>
        </div>

        <!-- 无结果状态 -->
        <div v-else-if="searchResults.total === 0 && searchQuery" class="empty-state">
          <svg width="120" height="120" viewBox="0 0 120 120" fill="none">
            <circle cx="60" cy="60" r="50" stroke="currentColor" stroke-width="2"/>
            <circle cx="60" cy="60" r="20" stroke="currentColor" stroke-width="2"/>
            <path d="M80 80L90 90" stroke="currentColor" stroke-width="2"/>
          </svg>
          <h3>未找到相关结果</h3>
          <p>没有找到与 "{{ searchQuery }}" 相关的内容</p>
          <div class="suggestions">
            <h4>搜索建议：</h4>
            <ul>
              <li>检查关键词拼写是否正确</li>
              <li>尝试使用更通用的关键词</li>
              <li>使用同义词或相关词汇</li>
              <li>减少关键词数量</li>
            </ul>
          </div>
        </div>

        <!-- 搜索结果列表 -->
        <div v-else-if="filteredResults.length" class="search-results">
          <div
            v-for="result in filteredResults"
            :key="`${result.type}-${result.id}`"
            class="result-item"
            @click="goToResult(result)"
          >
            <div class="result-image" v-if="result.image">
              <img :src="result.image" :alt="result.title" />
            </div>
            <div class="result-content">
              <div class="result-meta">
                <span class="result-type">{{ resultTypes[result.type] }}</span>
                <span class="result-relevance">相关度: {{ Math.round(result.relevance * 100) }}%</span>
              </div>
              <h3 class="result-title">{{ result.title }}</h3>
              <p class="result-description">{{ result.description }}</p>
              <div class="result-actions">
                <span class="result-url">{{ result.url }}</span>
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                  <path d="M6 3L11 8L6 13" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
            </div>
          </div>
        </div>

        <!-- 推荐内容 -->
        <div v-if="!loading && searchResults.total === 0" class="recommended-content">
          <h3 class="recommended-title">推荐内容</h3>
          <div class="recommended-grid">
            <router-link to="/products" class="recommended-item">
              <div class="recommended-icon">
                <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                  <rect x="4" y="6" width="24" height="20" rx="4" stroke="currentColor" stroke-width="2"/>
                  <path d="M8 12H24" stroke="currentColor" stroke-width="2"/>
                  <path d="M8 16H20" stroke="currentColor" stroke-width="2"/>
                </svg>
              </div>
              <h4>产品中心</h4>
              <p>浏览我们的美妆产品系列</p>
            </router-link>

            <router-link to="/services" class="recommended-item">
              <div class="recommended-icon">
                <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                  <circle cx="16" cy="16" r="12" stroke="currentColor" stroke-width="2"/>
                  <path d="M12 16L14 18L20 12" stroke="currentColor" stroke-width="2"/>
                </svg>
              </div>
              <h4>服务范围</h4>
              <p>了解我们的专业服务</p>
            </router-link>

            <router-link to="/news" class="recommended-item">
              <div class="recommended-icon">
                <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                  <path d="M8 4H24C25.1046 4 26 4.89543 26 6V26C26 27.1046 25.1046 28 24 28H8C6.89543 28 6 27.1046 6 26V6C6 4.89543 6.89543 4 8 4Z" stroke="currentColor" stroke-width="2"/>
                  <path d="M10 10H22" stroke="currentColor" stroke-width="2"/>
                </svg>
              </div>
              <h4>新闻资讯</h4>
              <p>获取最新行业动态</p>
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
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { apiService } from '@/utils/api'

// 组件导入
import AppHeader from '@/components/AppHeader.vue'
import AppFooter from '@/components/AppFooter.vue'

const route = useRoute()
const router = useRouter()

// 响应式状态
const searchQuery = ref('')
const searchResults = ref<any>({ results: [], total: 0, query: '' })
const loading = ref(false)
const error = ref('')
const activeType = ref('')

// 结果类型
const resultTypes = {
  '': '全部',
  'product': '产品',
  'news': '新闻',
  'service': '服务',
  'user_story': '用户故事'
}

// 计算属性
const filteredResults = computed(() => {
  if (!activeType.value) {
    return searchResults.value.results || []
  }
  return (searchResults.value.results || []).filter((result: any) => result.type === activeType.value)
})

// 方法
const performSearch = async () => {
  if (!searchQuery.value.trim()) {
    return
  }

  loading.value = true
  error.value = ''

  try {
    const response = await apiService.get('/search/', { q: searchQuery.value })
    searchResults.value = response

    // 更新URL
    router.push({
      query: { q: searchQuery.value }
    })
  } catch (err) {
    error.value = '搜索失败，请稍后重试'
    console.error('Search error:', err)
  } finally {
    loading.value = false
  }
}

const setActiveType = (type: string) => {
  activeType.value = type
}

const getTypeCount = (type: string): number => {
  if (!type) return searchResults.value.total || 0
  return (searchResults.value.results || []).filter((result: any) => result.type === type).length
}

const goToResult = (result: any) => {
  router.push(result.url)
}

// 初始化
onMounted(() => {
  const query = route.query.q as string
  if (query) {
    searchQuery.value = query
    performSearch()
  }
})

// 监听路由变化
watch(
  () => route.query.q,
  (newQuery) => {
    if (newQuery) {
      searchQuery.value = newQuery as string
      performSearch()
    }
  }
)
</script>

<style scoped>
.search-results-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

/* 页面标题区域 */
.page-hero {
  padding: 120px 0 80px;
  background: var(--primary-color);
  color: white;
  margin-top: 90px;
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

/* 搜索内容区域 */
.search-content {
  flex: 1;
  padding: 80px 0 120px;
  background: var(--gray-bg);
}

/* 搜索统计 */
.search-stats {
  margin-bottom: 32px;
}

.stats-text {
  font-size: 16px;
  color: var(--text-secondary);
}

/* 搜索表单 */
.search-form {
  margin-bottom: 48px;
}

.search-wrapper {
  position: relative;
  max-width: 600px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  background: white;
  border-radius: 12px;
  box-shadow: var(--shadow-md);
}

.search-input {
  flex: 1;
  padding: 20px 24px;
  border: none;
  border-radius: 12px 0 0 12px;
  font-size: 16px;
  background: transparent;
}

.search-input:focus {
  outline: none;
}

.search-btn {
  padding: 20px 24px;
  background: var(--primary-color);
  color: white;
  border: none;
  border-radius: 0 12px 12px 0;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
  font-weight: 500;
  transition: background 0.3s ease;
}

.search-btn:hover {
  background: var(--primary-dark);
}

/* 筛选器 */
.search-filters {
  margin-bottom: 48px;
}

.filter-tabs {
  display: flex;
  gap: 8px;
  justify-content: center;
  flex-wrap: wrap;
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

.suggestions {
  margin-top: 32px;
  text-align: left;
  max-width: 400px;
  margin-left: auto;
  margin-right: auto;
}

.suggestions h4 {
  font-size: 16px;
  color: var(--text-primary);
  margin-bottom: 12px;
}

.suggestions ul {
  list-style: none;
  padding: 0;
}

.suggestions li {
  padding: 4px 0;
  font-size: 14px;
  color: var(--text-secondary);
  position: relative;
  padding-left: 16px;
}

.suggestions li::before {
  content: '•';
  position: absolute;
  left: 0;
  color: var(--primary-color);
}

/* 搜索结果 */
.search-results {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.result-item {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: var(--shadow-sm);
  transition: all 0.3s ease;
  cursor: pointer;
  display: flex;
  gap: 20px;
}

.result-item:hover {
  box-shadow: var(--shadow-md);
  transform: translateY(-2px);
}

.result-image {
  flex-shrink: 0;
  width: 80px;
  height: 80px;
  border-radius: 8px;
  overflow: hidden;
  background: var(--gray-bg);
}

.result-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.result-content {
  flex: 1;
}

.result-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.result-type {
  font-size: 12px;
  color: var(--primary-color);
  background: rgba(100, 183, 178, 0.1);
  padding: 4px 8px;
  border-radius: 4px;
  font-weight: 500;
}

.result-relevance {
  font-size: 12px;
  color: var(--text-muted);
}

.result-title {
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 8px;
  line-height: 1.3;
}

.result-description {
  font-size: 14px;
  color: var(--text-secondary);
  line-height: 1.5;
  margin-bottom: 12px;
}

.result-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.result-url {
  font-size: 12px;
  color: var(--text-muted);
}

/* 推荐内容 */
.recommended-content {
  margin-top: 60px;
}

.recommended-title {
  font-size: 32px;
  font-weight: 400;
  color: var(--text-primary);
  text-align: center;
  margin-bottom: 48px;
}

.recommended-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 32px;
}

.recommended-item {
  background: white;
  padding: 32px 24px;
  border-radius: 12px;
  text-decoration: none;
  text-align: center;
  box-shadow: var(--shadow-sm);
  transition: all 0.3s ease;
}

.recommended-item:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
}

.recommended-icon {
  width: 64px;
  height: 64px;
  border-radius: 16px;
  background: var(--primary-color);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 24px;
}

.recommended-item h4 {
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 12px;
}

.recommended-item p {
  font-size: 14px;
  color: var(--text-secondary);
  margin: 0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .page-hero {
    padding: 100px 0 60px;
  }

  .page-title {
    font-size: 32px;
  }

  .search-content {
    padding: 60px 0 80px;
  }

  .search-wrapper {
    flex-direction: column;
    border-radius: 12px;
  }

  .search-input {
    border-radius: 12px 12px 0 0;
  }

  .search-btn {
    border-radius: 0 0 12px 12px;
    width: 100%;
    justify-content: center;
  }

  .filter-tabs {
    justify-content: flex-start;
  }

  .result-item {
    flex-direction: column;
    gap: 16px;
  }

  .result-image {
    width: 100%;
    height: 150px;
  }

  .recommended-grid {
    grid-template-columns: 1fr;
  }
}
</style>
