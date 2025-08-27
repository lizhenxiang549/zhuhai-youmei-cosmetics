<template>
  <header :class="['guerlain-header', { 'header-hidden': !isHeaderVisible }]">
    <!-- 顶部工具栏 -->
    <div class="top-bar">
      <div class="container">
        <div class="top-bar-content">
          <!-- 左侧图标 -->
          <div class="top-left">
            <!-- 语言选择器 -->
            <div class="language-selector">
              <button
                class="lang-btn"
                :class="{ active: languageStore.isChineseMode }"
                @click="switchLanguage('zh')"
              >
                中文
              </button>
              <span class="lang-divider">|</span>
              <button
                class="lang-btn"
                :class="{ active: languageStore.isEnglishMode }"
                @click="switchLanguage('en')"
              >
                English
              </button>
            </div>
            <button class="icon-btn" @click="toggleSearch">
              <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                <path d="M9 17C13.4183 17 17 13.4183 17 9C17 4.58172 13.4183 1 9 1C4.58172 1 1 4.58172 1 9C1 13.4183 4.58172 17 9 17Z" stroke="currentColor" stroke-width="1.5"/>
                <path d="m19 19-4.35-4.35" stroke="currentColor" stroke-width="1.5"/>
              </svg>
            </button>
          </div>

          <!-- 右侧图标 -->
          <div class="top-right">
            <button class="icon-btn">
              <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                <path d="M10 9C12.7614 9 15 6.76142 15 4C15 1.23858 12.7614-1 10-1C7.23858-1 5 1.23858 5 4C5 6.76142 7.23858 9 10 9Z" stroke="currentColor" stroke-width="1.5"/>
                <path d="M1 19V17C1 13.134 4.13401 10 8 10H12C15.866 10 19 13.134 19 17V19" stroke="currentColor" stroke-width="1.5"/>
              </svg>
            </button>
            <button class="icon-btn">
              <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                <path d="M6 1L3 5V19C3 19.5304 3.21071 20.0391 3.58579 20.4142C3.96086 20.7893 4.46957 21 5 21H15C15.5304 21 16.0391 20.7893 16.4142 20.4142C16.7893 20.0391 17 19.5304 17 19V5L14 1H6Z" stroke="currentColor" stroke-width="1.5"/>
                <path d="M3 5H17" stroke="currentColor" stroke-width="1.5"/>
                <path d="M13 9C13 10.1046 12.1046 11 11 11C9.89543 11 9 10.1046 9 9" stroke="currentColor" stroke-width="1.5"/>
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 主Logo区域 -->
    <div class="logo-section">
      <div class="container">
        <router-link to="/" class="main-logo">
          珠海优美
        </router-link>
      </div>
    </div>

    <!-- 主导航菜单 -->
    <nav class="main-nav">
      <div class="container">
        <ul class="nav-menu">
          <li class="nav-item">
            <a
              href="javascript:void(0)"
              :class="['nav-link', { 'active': isActiveNavLink('/products', '香水') }]"
              @click="navigateToCategory('香水')"
            >
              香水
            </a>
          </li>
          <li class="nav-item">
            <a
              href="javascript:void(0)"
              :class="['nav-link', { 'active': isActiveNavLink('/products', '彩妆') }]"
              @click="navigateToCategory('彩妆')"
            >
              彩妆
            </a>
          </li>
          <li class="nav-item">
            <a
              href="javascript:void(0)"
              :class="['nav-link', { 'active': isActiveNavLink('/products', '护肤') }]"
              @click="navigateToCategory('护肤')"
            >
              护肤
            </a>
          </li>
          <li class="nav-item">
            <router-link
              to="/services"
              :class="['nav-link', { 'active': isActiveNavLink('/services') }]"
            >
              服务
            </router-link>
          </li>
          <li class="nav-item">
            <router-link
              to="/about"
              :class="['nav-link', { 'active': isActiveNavLink('/about') }]"
            >
              关于我们
            </router-link>
          </li>
          <li class="nav-item">
            <router-link
              to="/contact"
              :class="['nav-link', { 'active': isActiveNavLink('/contact') }]"
            >
              联系我们
            </router-link>
          </li>
        </ul>
      </div>
    </nav>

    <!-- 搜索框 -->
    <transition name="fade">
      <div v-if="showSearch" class="search-overlay" @click="closeSearch">
        <div class="search-content" @click.stop>
          <div class="search-box">
            <input
              ref="searchInput"
              v-model="searchQuery"
              type="text"
              placeholder="搜索产品..."
              class="search-input"
              @keyup.enter="handleSearch"
            />
            <button class="search-btn" @click="handleSearch">
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                <path d="M7 13C10.866 13 14 9.866 14 6C14 2.134 10.866-1 7-1C3.134-1 0 2.134 0 6C0 9.866 3.134 13 7 13Z" stroke="currentColor" stroke-width="1.5"/>
                <path d="m15 15-3.5-3.5" stroke="currentColor" stroke-width="1.5"/>
              </svg>
            </button>
          </div>
        </div>
      </div>
    </transition>

    <!-- 移动端菜单 -->
    <transition name="slide-down">
      <div v-if="showMenu" class="mobile-menu">
        <div class="mobile-menu-content">
          <ul class="mobile-nav-list">
            <li>
              <router-link
                to="/"
                :class="{ 'active': isActiveNavLink('/') }"
                @click="closeMenu"
              >
                首页
              </router-link>
            </li>
            <li>
              <a
                href="javascript:void(0)"
                :class="{ 'active': isActiveNavLink('/products', '香水') }"
                @click="navigateToCategory('香水')"
              >
                香水
              </a>
            </li>
            <li>
              <a
                href="javascript:void(0)"
                :class="{ 'active': isActiveNavLink('/products', '彩妆') }"
                @click="navigateToCategory('彩妆')"
              >
                彩妆
              </a>
            </li>
            <li>
              <a
                href="javascript:void(0)"
                :class="{ 'active': isActiveNavLink('/products', '护肤') }"
                @click="navigateToCategory('护肤')"
              >
                护肤
              </a>
            </li>
            <li>
              <router-link
                to="/services"
                :class="{ 'active': isActiveNavLink('/services') }"
                @click="closeMenu"
              >
                服务
              </router-link>
            </li>
            <li>
              <router-link
                to="/about"
                :class="{ 'active': isActiveNavLink('/about') }"
                @click="closeMenu"
              >
                关于我们
              </router-link>
            </li>
            <li>
              <router-link
                to="/contact"
                :class="{ 'active': isActiveNavLink('/contact') }"
                @click="closeMenu"
              >
                联系我们
              </router-link>
            </li>
          </ul>
        </div>
      </div>
    </transition>
  </header>
</template>

<script setup lang="ts">
import { ref, nextTick, onMounted, onUnmounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useLanguageStore } from '@/stores'

const router = useRouter()
const route = useRoute()
const languageStore = useLanguageStore()

// 响应式状态
const showSearch = ref(false)
const showMenu = ref(false)
const searchQuery = ref('')
const searchInput = ref<HTMLInputElement>()
const isHeaderVisible = ref(true)

// 滚动相关状态
let lastScrollY = 0
let ticking = false

// 计算当前活跃的导航项
const isActiveNavLink = (path: string, category?: string) => {
  if (path === '/products' && category) {
    return route.path === '/products' && route.query.category === category
  }
  return route.path === path
}

// 搜索功能
const toggleSearch = async () => {
  showSearch.value = !showSearch.value
  showMenu.value = false

  if (showSearch.value) {
    await nextTick()
    searchInput.value?.focus()
  }
}

const closeSearch = () => {
  showSearch.value = false
}

const handleSearch = () => {
  if (searchQuery.value.trim()) {
    router.push({
      name: 'Products',
      query: { search: searchQuery.value.trim() }
    })
    closeAll()
  }
}

// 语言切换功能
const switchLanguage = (lang: 'zh' | 'en') => {
  languageStore.setLanguage(lang)
  // 这里可以添加多语言切换的其他逻辑，比如重新加载页面内容
}

// 导航到产品分类
const navigateToCategory = (category: string) => {
  router.push({
    path: '/products',
    query: { category }
  })
  closeAll()
}

// 菜单功能
const toggleMenu = () => {
  showMenu.value = !showMenu.value
  showSearch.value = false
}

const closeMenu = () => {
  showMenu.value = false
}

const closeAll = () => {
  showSearch.value = false
  showMenu.value = false
}

// 滚动事件处理 - 页面滚动时自动关闭菜单并处理导航栏显隐
const handleScroll = () => {
  if (showMenu.value || showSearch.value) {
    closeAll()
  }

  if (!ticking) {
    requestAnimationFrame(updateHeaderVisibility)
    ticking = true
  }
}

// 更新导航栏可见性
const updateHeaderVisibility = () => {
  const currentScrollY = window.scrollY

  // 如果滚动距离小于100px，总是显示导航栏
  if (currentScrollY < 100) {
    isHeaderVisible.value = true
  } else {
    // 向下滚动隐藏，向上滚动显示
    if (currentScrollY > lastScrollY && currentScrollY > 200) {
      // 向下滚动，隐藏导航栏
      isHeaderVisible.value = false
    } else if (currentScrollY < lastScrollY) {
      // 向上滚动，显示导航栏
      isHeaderVisible.value = true
    }
  }

  lastScrollY = currentScrollY
  ticking = false
}

// 键盘事件监听
const handleKeydown = (event: KeyboardEvent) => {
  if (event.key === 'Escape') {
    closeAll()
  }
}

onMounted(() => {
  document.addEventListener('keydown', handleKeydown)
  window.addEventListener('scroll', handleScroll, { passive: true })
  // 初始化语言设置
  languageStore.initializeLanguage()
})

onUnmounted(() => {
  document.removeEventListener('keydown', handleKeydown)
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
/* Guerlain官网风格的头部 */
.guerlain-header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  background: var(--background-color);
  border-bottom: 1px solid var(--border-light);
  z-index: 1000;
  font-family: var(--font-family);
  transition: transform 0.3s ease-in-out;
  transform: translateY(0);
}

/* 隐藏状态 */
.guerlain-header.header-hidden {
  transform: translateY(-100%);
}

/* 顶部工具栏 */
.top-bar {
  background: var(--background-color);
  padding: 6px 0;
}

.top-bar-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.top-left,
.top-right {
  display: flex;
  gap: 12px;
}

.icon-btn {
  background: none;
  border: none;
  padding: 8px;
  cursor: pointer;
  color: var(--text-primary);
  transition: color 0.2s ease;
}

.icon-btn:hover {
  color: var(--primary-color);
}

/* 语言选择器样式 */
.language-selector {
  display: flex;
  align-items: center;
  gap: 4px;
  margin-right: 8px;
}

.lang-btn {
  background: none;
  border: none;
  padding: 6px 8px;
  cursor: pointer;
  color: var(--text-muted);
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  transition: color 0.2s ease;
}

.lang-btn:hover {
  color: var(--text-primary);
}

.lang-btn.active {
  color: var(--primary-color);
  font-weight: 500;
}

.lang-divider {
  color: var(--border-light);
  font-size: 12px;
}

/* 主Logo区域 - 模仿娇兰的大logo */
.logo-section {
  padding: 12px 0;
  text-align: center;
  background: var(--background-color);
}

.main-logo {
  font-size: 32px;
  font-weight: 300;
  letter-spacing: 8px;
  color: var(--text-primary);
  text-decoration: none;
  text-transform: uppercase;
  transition: color 0.3s ease;
  display: inline-block;
}

.main-logo:hover {
  color: var(--primary-color);
}

/* 主导航菜单 - 居中布局 */
.main-nav {
  background: var(--background-color);
  border-top: 1px solid var(--border-light);
  border-bottom: 1px solid var(--border-light);
  padding: 0;
}

.nav-menu {
  display: flex;
  justify-content: center;
  align-items: center;
  list-style: none;
  margin: 0;
  padding: 0;
  gap: 40px;
}

.nav-item {
  margin: 0;
}

.nav-link {
  display: block;
  padding: 12px 0;
  color: var(--text-primary);
  text-decoration: none;
  font-size: 14px;
  font-weight: 400;
  letter-spacing: 1px;
  text-transform: uppercase;
  transition: color 0.3s ease;
  position: relative;
}

/* 移除文字颜色变化，保持原色 */
.nav-link:hover,
.nav-link.active {
  color: var(--text-primary);
}

/* 黑色下滑线效果 - 从左到右 */
.nav-link::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 0;
  height: 2px;
  background: var(--primary-color);
  transition: width 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.nav-link:hover::after,
.nav-link.active::after {
  width: 100%;
}

/* 搜索覆盖层 */
.search-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.3);
  display: flex;
  align-items: flex-start;
  justify-content: center;
  padding-top: 120px;
  z-index: 2000;
}

.search-content {
  background: var(--background-color);
  border-radius: 0;
  padding: 24px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 500px;
}

.search-box {
  display: flex;
  align-items: center;
  border: 1px solid var(--border-light);
  background: var(--background-color);
}

.search-input {
  flex: 1;
  padding: 12px 16px;
  border: none;
  outline: none;
  font-size: 16px;
  background: transparent;
  color: var(--text-primary);
}

.search-input::placeholder {
  color: var(--text-muted);
}

.search-btn {
  padding: 12px 16px;
  background: none;
  border: none;
  cursor: pointer;
  color: var(--text-primary);
  transition: color 0.2s ease;
}

.search-btn:hover {
  color: var(--primary-color);
}

/* 移动端菜单 */
.mobile-menu {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background: var(--background-color);
  border-bottom: 1px solid var(--border-light);
  z-index: 1500;
}

.mobile-menu-content {
  padding: 20px;
}

.mobile-nav-list {
  list-style: none;
  margin: 0;
  padding: 0;
}

.mobile-nav-list li {
  margin-bottom: 12px;
}

.mobile-nav-list a {
  display: block;
  padding: 12px 0;
  color: var(--text-primary);
  text-decoration: none;
  font-size: 16px;
  letter-spacing: 1px;
  transition: color 0.3s ease;
}

.mobile-nav-list a:hover,
.mobile-nav-list a.active {
  color: var(--text-primary);
  position: relative;
}

/* 为移动端菜单添加下滑线效果 */
.mobile-nav-list a {
  position: relative;
}

.mobile-nav-list a::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 0;
  height: 2px;
  background: var(--primary-color);
  transition: width 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.mobile-nav-list a:hover::after,
.mobile-nav-list a.active::after {
  width: 100%;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .main-nav {
    display: none;
  }

  .nav-menu {
    gap: 20px;
  }

  .main-logo {
    font-size: 24px;
    letter-spacing: 4px;
  }

  .logo-section {
    padding: 10px 0;
  }
}

@media (max-width: 480px) {
  .main-logo {
    font-size: 20px;
    letter-spacing: 3px;
  }
}

/* 过渡动画 */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.slide-down-enter-active,
.slide-down-leave-active {
  transition: all 0.3s ease;
}

.slide-down-enter-from,
.slide-down-leave-to {
  transform: translateY(-100%);
  opacity: 0;
}
</style>
