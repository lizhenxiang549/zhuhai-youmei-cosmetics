# 珠海优美化妆品电商网站 - 完整重建指南

## 🚀 快速开始

### 1. 创建项目目录
```bash
mkdir zhuhai-youmei-cosmetics
cd zhuhai-youmei-cosmetics
```

### 2. 初始化项目
```bash
npm create vue@latest frontend -- --typescript --router --pinia --eslint
cd frontend
```

### 3. 安装依赖
```bash
npm install axios@^1.6.0
npm install
```

## 📁 项目结构
```
frontend/
├── index.html
├── package.json
├── vite.config.ts
├── tsconfig.json
├── tsconfig.node.json
├── netlify.toml
├── src/
│   ├── main.ts
│   ├── App.vue
│   ├── assets/
│   │   ├── main.css
│   │   └── styles/
│   │       └── global.css
│   ├── components/
│   │   ├── AppHeader.vue
│   │   ├── AppFooter.vue
│   │   ├── HeroSection.vue
│   │   ├── ProductSection.vue
│   │   ├── AboutSection.vue
│   │   ├── VisionSection.vue
│   │   ├── ResearchSection.vue
│   │   └── ResponsibilitySection.vue
│   ├── views/
│   │   ├── Home.vue
│   │   ├── Products.vue
│   │   ├── ProductDetail.vue
│   │   ├── Services.vue
│   │   ├── About.vue
│   │   ├── Contact.vue
│   │   ├── News.vue
│   │   ├── NewsDetail.vue
│   │   ├── SearchResults.vue
│   │   └── NotFound.vue
│   ├── router/
│   │   └── index.ts
│   ├── stores/
│   │   └── index.ts
│   ├── types/
│   │   └── index.ts
│   └── utils/
│       └── api.ts
└── public/
```

## 📋 核心配置文件

### package.json
```json
{
  "name": "msd-style-cosmetics-frontend",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite --host 0.0.0.0",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "vue": "^3.4.0",
    "vue-router": "^4.2.0",
    "pinia": "^2.1.0",
    "axios": "^1.6.0"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.0.0",
    "vite": "^5.0.0",
    "typescript": "^5.0.0",
    "vue-tsc": "^2.0.0",
    "@types/node": "^20.0.0"
  }
}
```

### vite.config.ts
```typescript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
    },
  },
  server: {
    host: '0.0.0.0',
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://127.0.0.1:8000',
        changeOrigin: true,
        secure: false,
      },
    },
  },
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    sourcemap: false,
  },
})
```

### netlify.toml
```toml
[build]
  command = "npm run build"
  publish = "dist"

[build.environment]
  NODE_VERSION = "20"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

### src/main.ts
```typescript
import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'
import './assets/styles/global.css'

const app = createApp(App)

app.use(createPinia())
app.use(router)

app.mount('#app')
```

## 🎨 样式文件

### src/assets/styles/global.css
```css
/* 全局样式 */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
  line-height: 1.6;
  color: #333;
  background-color: #fff;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .container {
    padding: 0 15px;
  }
}

/* 按钮样式 */
.btn {
  display: inline-block;
  padding: 12px 24px;
  background-color: #000;
  color: #fff;
  text-decoration: none;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s ease;
  border: none;
  cursor: pointer;
}

.btn:hover {
  background-color: #333;
  transform: translateY(-2px);
}

/* 金色主题 */
.hero-section {
  background: linear-gradient(135deg, #d4af37 0%, #ffd700 100%);
  min-height: 60vh;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  color: white;
  position: relative;
}

.hero-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: radial-gradient(circle at 30% 20%, rgba(255,255,255,0.1) 0%, transparent 30%),
              radial-gradient(circle at 70% 80%, rgba(255,255,255,0.1) 0%, transparent 30%);
}

.hero-content {
  position: relative;
  z-index: 1;
}

.hero-title {
  font-size: 3rem;
  font-weight: 300;
  margin-bottom: 1rem;
  letter-spacing: 2px;
}

.hero-subtitle {
  font-size: 1.2rem;
  margin-bottom: 2rem;
  opacity: 0.9;
}

/* 产品卡片 */
.product-card {
  background: #f8f8f8;
  border-radius: 8px;
  padding: 20px;
  text-align: center;
  transition: transform 0.3s ease;
  height: 100%;
}

.product-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 25px rgba(0,0,0,0.1);
}

.product-icon {
  font-size: 4rem;
  color: #d4af37;
  margin-bottom: 1rem;
}

.product-title {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  color: #333;
}

.product-price {
  font-size: 1.2rem;
  color: #d4af37;
  font-weight: 600;
  margin-bottom: 1rem;
}

/* 导航样式 */
.nav-menu {
  display: flex;
  list-style: none;
  align-items: center;
  gap: 2rem;
}

.nav-item a {
  text-decoration: none;
  color: #333;
  font-weight: 500;
  transition: color 0.3s ease;
}

.nav-item a:hover {
  color: #d4af37;
}

/* 页脚样式 */
.footer {
  background-color: #222;
  color: #fff;
  padding: 3rem 0 1rem;
}

.footer-content {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
  margin-bottom: 2rem;
}

.footer-section h3 {
  margin-bottom: 1rem;
  color: #d4af37;
}

.footer-bottom {
  text-align: center;
  padding-top: 2rem;
  border-top: 1px solid #444;
  color: #999;
}
```

## 📧 获取完整源码

如果您需要完整的组件代码，我可以：

1. **提供 GitHub 仓库链接**（推荐）
2. **逐个提供所有组件的完整代码**
3. **创建一个包含所有文件的ZIP文件**

请告诉我您希望采用哪种方式获取完整源码！

## 🚀 快速部署

```bash
# 构建项目
npm run build

# 部署到 Netlify
npm install -g netlify-cli
netlify deploy --prod --dir=dist
```

---

💡 **提示**: 此项目是一个完整的Vue.js电商网站，包含首页、产品展示、关于我们、联系我们等页面，使用现代化的设计和响应式布局。
