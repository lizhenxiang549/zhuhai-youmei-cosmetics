<template>
  <div class="news-detail-page">
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
        <router-link to="/news" class="btn btn-primary">返回新闻列表</router-link>
      </div>
    </div>

    <div v-else-if="article" class="news-detail-content">
      <!-- 面包屑导航 -->
      <section class="breadcrumb-section">
        <div class="container">
          <nav class="breadcrumb">
            <router-link to="/" class="breadcrumb-link">首页</router-link>
            <span class="breadcrumb-separator">/</span>
            <router-link to="/news" class="breadcrumb-link">新闻资讯</router-link>
            <span class="breadcrumb-separator">/</span>
            <span class="breadcrumb-current">{{ article.title }}</span>
          </nav>
        </div>
      </section>

      <!-- 新闻内容 -->
      <article class="news-article">
        <div class="container">
          <div class="article-layout">
            <!-- 主要内容 -->
            <div class="article-main">
              <!-- 文章头部 -->
              <header class="article-header">
                <div class="article-meta">
                  <span class="news-type">{{ newsTypes[article.news_type] }}</span>
                  <time class="news-date">{{ formatDate(article.publish_date) }}</time>
                  <div v-if="article.is_featured" class="featured-badge">推荐</div>
                </div>

                <h1 class="article-title">{{ article.title }}</h1>

                <div class="article-stats">
                  <div class="stat-item">
                    <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                      <circle cx="8" cy="4" r="2" stroke="currentColor" stroke-width="1.5"/>
                      <path d="M2 14C2 11.2386 4.68629 9 8 9C11.3137 9 14 11.2386 14 14" stroke="currentColor" stroke-width="1.5"/>
                    </svg>
                    <span>{{ article.author_name }}</span>
                  </div>
                  <div class="stat-item">
                    <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                      <circle cx="8" cy="8" r="6" stroke="currentColor" stroke-width="1.5"/>
                      <circle cx="8" cy="8" r="2" fill="currentColor"/>
                    </svg>
                    <span>{{ article.read_count }} 阅读</span>
                  </div>
                </div>
              </header>

              <!-- 特色图片 -->
              <div v-if="article.featured_image" class="article-image">
                <img
                  :src="article.featured_image"
                  :alt="article.title"
                  class="featured-img"
                />
              </div>

              <!-- 摘要 -->
              <div v-if="article.summary" class="article-summary">
                <p>{{ article.summary }}</p>
              </div>

              <!-- 正文内容 -->
              <div class="article-content">
                <div class="content-text" v-html="formatContent(article.content)"></div>
              </div>

              <!-- 标签 -->
              <div v-if="article.tags?.length" class="article-tags">
                <div class="tags-label">标签：</div>
                <div class="tags-list">
                  <span
                    v-for="tag in article.tags"
                    :key="tag"
                    class="tag-item"
                  >
                    {{ tag }}
                  </span>
                </div>
              </div>

              <!-- 分享和操作 -->
              <div class="article-actions">
                <div class="share-section">
                  <span class="share-label">分享：</span>
                  <div class="share-buttons">
                    <button @click="shareToWeibo" class="share-btn weibo">
                      微博
                    </button>
                    <button @click="shareToWechat" class="share-btn wechat">
                      微信
                    </button>
                    <button @click="copyLink" class="share-btn copy">
                      复制链接
                    </button>
                  </div>
                </div>

                <div class="action-buttons">
                  <router-link to="/news" class="btn btn-outline">
                    返回列表
                  </router-link>
                  <router-link to="/contact" class="btn btn-primary">
                    联系我们
                  </router-link>
                </div>
              </div>
            </div>

            <!-- 侧边栏 -->
            <aside class="article-sidebar">
              <!-- 相关新闻 -->
              <div class="sidebar-section">
                <h3 class="sidebar-title">相关新闻</h3>
                <div class="related-news">
                  <div
                    v-for="relatedArticle in relatedNews"
                    :key="relatedArticle.id"
                    class="related-item"
                    @click="viewNews(relatedArticle)"
                  >
                    <div class="related-image">
                      <img
                        v-if="relatedArticle.featured_image"
                        :src="relatedArticle.featured_image"
                        :alt="relatedArticle.title"
                        class="related-img"
                      />
                      <div v-else class="image-placeholder">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                          <rect x="3" y="3" width="18" height="18" rx="3" stroke="currentColor" stroke-width="1.5"/>
                          <circle cx="9" cy="9" r="1.5" fill="currentColor"/>
                          <path d="M3 15L6 12L9 15L15 9L21 15V21H3V15Z" fill="currentColor"/>
                        </svg>
                      </div>
                    </div>
                    <div class="related-content">
                      <h4 class="related-title">{{ relatedArticle.title }}</h4>
                      <div class="related-meta">
                        <span class="related-date">{{ formatDate(relatedArticle.publish_date) }}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- 联系信息 -->
              <div class="sidebar-section contact-info">
                <h3 class="sidebar-title">联系我们</h3>
                <div class="contact-content">
                  <p class="contact-desc">
                    如果您对我们的产品或服务感兴趣，欢迎随时联系我们
                  </p>
                  <div class="contact-items">
                    <div class="contact-item">
                      <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                        <path d="M2 3L7 8L14 1" stroke="currentColor" stroke-width="1.5"/>
                      </svg>
                      <span>400-888-9999</span>
                    </div>
                    <div class="contact-item">
                      <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                        <path d="M2 3L7 8L14 1" stroke="currentColor" stroke-width="1.5"/>
                      </svg>
                      <span>info@cosmetics-msd.com</span>
                    </div>
                  </div>
                  <router-link to="/contact" class="btn btn-primary btn-small">
                    立即咨询
                  </router-link>
                </div>
              </div>
            </aside>
          </div>
        </div>
      </article>
    </div>

    <!-- 页脚 -->
    <AppFooter />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useNewsStore } from '@/stores'
import { storeToRefs } from 'pinia'
import { NEWS_TYPE_LABELS } from '@/types'

// 组件导入
import AppHeader from '@/components/AppHeader.vue'
import AppFooter from '@/components/AppFooter.vue'

// 状态管理
const newsStore = useNewsStore()
const { currentNews: article, loading, error } = storeToRefs(newsStore)

const route = useRoute()
const router = useRouter()

// 响应式状态
const relatedNews = ref([])

// 新闻类型
const newsTypes = NEWS_TYPE_LABELS

// 方法
const formatDate = (dateString: string): string => {
  if (!dateString) return ''
  try {
    const date = new Date(dateString)
    return date.toLocaleDateString('zh-CN', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    })
  } catch {
    return ''
  }
}

const formatContent = (content: string): string => {
  // 将换行符转换为 <br> 标签
  return content.replace(/\n/g, '<br>')
}

const viewNews = (newsArticle: any) => {
  router.push({
    name: 'NewsDetail',
    params: { id: newsArticle.id }
  })
}

const shareToWeibo = () => {
  const url = encodeURIComponent(window.location.href)
  const title = encodeURIComponent(article.value?.title || '')
  const shareUrl = `https://service.weibo.com/share/share.php?url=${url}&title=${title}`
  window.open(shareUrl, '_blank')
}

const shareToWechat = () => {
  // 微信分享通常需要微信SDK，这里只是示例
  alert('请复制链接后在微信中分享')
}

const copyLink = async () => {
  try {
    await navigator.clipboard.writeText(window.location.href)
    alert('链接已复制到剪贴板')
  } catch (err) {
    // 降级方案
    const textArea = document.createElement('textarea')
    textArea.value = window.location.href
    document.body.appendChild(textArea)
    textArea.select()
    document.execCommand('copy')
    document.body.removeChild(textArea)
    alert('链接已复制到剪贴板')
  }
}

const loadRelatedNews = async () => {
  try {
    if (article.value) {
      // 获取相同类型的其他新闻
      const response = await newsStore.getNewsByType(article.value.news_type, {
        page_size: 4
      })
      relatedNews.value = response.results.filter(
        (item: any) => item.id !== article.value?.id
      ).slice(0, 3)
    }
  } catch (err) {
    console.error('Load related news error:', err)
  }
}

// 初始化
onMounted(async () => {
  const newsId = Number(route.params.id)
  if (newsId) {
    await newsStore.getNewsById(newsId)
    await loadRelatedNews()
  }
})
</script>

<style scoped>
.news-detail-page {
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

/* 新闻详情内容 */
.news-detail-content {
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
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 200px;
}

/* 新闻文章 */
.news-article {
  padding: 60px 0 120px;
  background: var(--section-bg);
}

.article-layout {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 60px;
  align-items: flex-start;
}

/* 主要内容 */
.article-main {
  background: white;
  border-radius: 12px;
  padding: 48px;
  box-shadow: var(--shadow-sm);
}

/* 文章头部 */
.article-header {
  margin-bottom: 32px;
}

.article-meta {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 16px;
  position: relative;
}

.news-type {
  font-size: 12px;
  color: var(--primary-color);
  font-weight: 500;
  background: rgba(100, 183, 178, 0.1);
  padding: 4px 12px;
  border-radius: 12px;
}

.news-date {
  font-size: 14px;
  color: var(--text-muted);
}

.featured-badge {
  position: absolute;
  right: 0;
  background: var(--primary-color);
  color: white;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.article-title {
  font-size: 36px;
  font-weight: 400;
  color: var(--text-primary);
  line-height: 1.3;
  margin-bottom: 24px;
}

.article-stats {
  display: flex;
  gap: 24px;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: var(--text-secondary);
}

.stat-item svg {
  color: var(--text-muted);
}

/* 特色图片 */
.article-image {
  margin-bottom: 32px;
  border-radius: 8px;
  overflow: hidden;
}

.featured-img {
  width: 100%;
  height: auto;
  display: block;
}

/* 摘要 */
.article-summary {
  background: var(--gray-bg);
  padding: 24px;
  border-radius: 8px;
  margin-bottom: 32px;
  border-left: 4px solid var(--primary-color);
}

.article-summary p {
  font-size: 18px;
  color: var(--text-secondary);
  line-height: 1.6;
  margin: 0;
  font-style: italic;
}

/* 正文内容 */
.article-content {
  margin-bottom: 40px;
}

.content-text {
  font-size: 16px;
  color: var(--text-secondary);
  line-height: 1.8;
}

.content-text :deep(br) {
  margin-bottom: 16px;
}

/* 标签 */
.article-tags {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 40px;
  padding-top: 24px;
  border-top: 1px solid var(--border-color);
}

.tags-label {
  font-size: 14px;
  color: var(--text-secondary);
  font-weight: 500;
}

.tags-list {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.tag-item {
  font-size: 12px;
  color: var(--primary-color);
  background: rgba(100, 183, 178, 0.1);
  padding: 4px 12px;
  border-radius: 12px;
}

/* 文章操作 */
.article-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 32px;
  border-top: 1px solid var(--border-color);
}

.share-section {
  display: flex;
  align-items: center;
  gap: 16px;
}

.share-label {
  font-size: 14px;
  color: var(--text-secondary);
  font-weight: 500;
}

.share-buttons {
  display: flex;
  gap: 8px;
}

.share-btn {
  padding: 8px 16px;
  border: 1px solid var(--border-color);
  background: white;
  color: var(--text-secondary);
  border-radius: 20px;
  font-size: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.share-btn:hover {
  border-color: var(--primary-color);
  color: var(--primary-color);
}

.action-buttons {
  display: flex;
  gap: 16px;
}

.action-buttons .btn {
  padding: 12px 24px;
  font-size: 14px;
}

/* 侧边栏 */
.article-sidebar {
  display: flex;
  flex-direction: column;
  gap: 32px;
}

.sidebar-section {
  background: white;
  border-radius: 12px;
  padding: 32px;
  box-shadow: var(--shadow-sm);
}

.sidebar-title {
  font-size: 20px;
  font-weight: 500;
  color: var(--text-primary);
  margin-bottom: 24px;
}

/* 相关新闻 */
.related-news {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.related-item {
  display: flex;
  gap: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
  padding: 12px;
  border-radius: 8px;
}

.related-item:hover {
  background: var(--gray-bg);
}

.related-image {
  flex-shrink: 0;
  width: 60px;
  height: 60px;
  border-radius: 6px;
  overflow: hidden;
  background: var(--gray-bg);
  display: flex;
  align-items: center;
  justify-content: center;
}

.related-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.image-placeholder {
  color: var(--text-muted);
}

.related-content {
  flex: 1;
  min-width: 0;
}

.related-title {
  font-size: 14px;
  font-weight: 500;
  color: var(--text-primary);
  line-height: 1.4;
  margin-bottom: 8px;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.related-meta {
  font-size: 12px;
  color: var(--text-muted);
}

/* 联系信息 */
.contact-info {
  background: var(--gray-bg);
  border: 2px solid var(--primary-color);
}

.contact-desc {
  font-size: 14px;
  color: var(--text-secondary);
  line-height: 1.5;
  margin-bottom: 20px;
}

.contact-items {
  margin-bottom: 24px;
}

.contact-item {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
  font-size: 14px;
  color: var(--text-primary);
}

.contact-item svg {
  color: var(--primary-color);
}

.btn-small {
  padding: 10px 20px;
  font-size: 14px;
  width: 100%;
  text-align: center;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .article-layout {
    gap: 40px;
  }

  .article-main {
    padding: 40px;
  }

  .article-title {
    font-size: 32px;
  }
}

@media (max-width: 768px) {
  .news-article {
    padding: 40px 0 80px;
  }

  .article-layout {
    grid-template-columns: 1fr;
    gap: 32px;
  }

  .article-main {
    padding: 32px;
  }

  .article-title {
    font-size: 28px;
  }

  .article-actions {
    flex-direction: column;
    gap: 20px;
    align-items: stretch;
  }

  .share-section {
    justify-content: center;
  }

  .action-buttons {
    justify-content: center;
  }

  .breadcrumb-current {
    max-width: 150px;
  }
}

@media (max-width: 480px) {
  .article-main {
    padding: 24px;
  }

  .article-title {
    font-size: 24px;
  }

  .article-meta {
    flex-wrap: wrap;
  }

  .featured-badge {
    position: static;
    margin-top: 8px;
  }

  .sidebar-section {
    padding: 24px;
  }

  .action-buttons {
    flex-direction: column;
  }

  .action-buttons .btn {
    width: 100%;
  }
}
</style>
