# 珠海优美化妆品官网 🌟

一个采用Vue 3 + TypeScript + Vite构建的现代化企业官网，展示珠海优美化妆品有限公司的产品和服务。

## ✨ 项目特色

- 🎨 **娇兰风格设计** - 采用黑白主题的奢华品牌风格
- ⚡ **现代化技术栈** - Vue 3 + TypeScript + Vite + Pinia
- 📱 **响应式设计** - 完美适配桌面端、平板和移动设备
- 🚀 **高性能** - Vite构建工具，快速开发和部署
- 🔍 **SEO优化** - Vue Router + Meta标签优化

## 🛠️ 技术栈

- **前端框架**: Vue 3.5.18
- **开发语言**: TypeScript 5.9.2
- **构建工具**: Vite 5.4.19
- **状态管理**: Pinia 2.3.1
- **路由管理**: Vue Router 4.5.1
- **HTTP客户端**: Axios 1.11.0
- **包管理器**: Bun 1.2.17

## 📦 项目结构

```
msd-style-cosmetics/frontend/
├── public/                 # 静态资源
├── src/
│   ├── assets/            # 样式和图片资源
│   │   └── styles/        # 全局样式
│   ├── components/        # 可复用组件
│   │   ├── AppHeader.vue  # 导航栏组件
│   │   └── AppFooter.vue  # 页脚组件
│   ├── stores/            # Pinia状态管理
│   ├── views/             # 页面组件
│   │   ├── Home.vue       # 首页
│   │   ├── Products.vue   # 产品中心
│   │   ├── About.vue      # 关于我们
│   │   ├── Contact.vue    # 联系我们
│   │   ├── Services.vue   # 服务范围
│   │   └── News.vue       # 新闻资讯
│   ├── router/            # 路由配置
│   ├── App.vue           # 根组件
│   └── main.ts           # 应用入口
├── index.html            # HTML模板
├── package.json          # 项目配置
├── vite.config.ts        # Vite配置
└── tsconfig.json         # TypeScript配置
```

## 🚀 快速开始

### 环境要求

- Node.js 18+
- Bun 1.0+ (推荐) 或 npm/yarn

### 安装依赖

```bash
# 使用Bun (推荐)
bun install

# 或使用npm
npm install
```

### 本地开发

```bash
# 启动开发服务器
bun run dev

# 浏览器访问 http://localhost:3000
```

### 构建生产版本

```bash
# 构建项目
bun run build

# 预览构建结果
bun run preview
```

## 🎨 设计特色

### 娇兰风格黑白主题
- **优雅配色**: 纯黑白配色方案，去除所有金色元素
- **精致交互**: 导航栏黑色下滑线效果
- **奢华视觉**: 高端品牌风格的布局和动画

### 响应式设计
- **桌面端**: 1200px+ 完整功能展示
- **平板端**: 768px-1024px 优化布局
- **移动端**: <768px 紧凑式设计

## 📱 功能模块

- **首页**: 品牌展示、产品亮点、企业介绍
- **产品中心**: 分类浏览、搜索筛选、产品详情
- **关于我们**: 企业文化、发展历程、团队介绍
- **服务范围**: ODM/OEM服务介绍
- **新闻资讯**: 行业动态、企业新闻
- **联系我们**: 联系方式、在线咨询

## 🔧 开发指南

### 代码规范
- 使用TypeScript严格模式
- 遵循Vue 3 Composition API最佳实践
- CSS使用Scoped样式避免冲突

### Git工作流
```bash
# 创建功能分支
git checkout -b feature/新功能名称

# 提交代码
git add .
git commit -m "feat: 添加新功能描述"

# 推送到远程仓库
git push origin feature/新功能名称
```

## 🚀 部署指南

### Netlify部署 (推荐)
```bash
# 构建命令
bun run build

# 输出目录
dist
```

### 阿里云部署
详细的阿里云Ubuntu 22.04部署指南请参考：`.same/阿里云部署指南.md`

## 📞 联系信息

**珠海优美化妆品有限公司**
- 📱 电话: 13727893557
- 📧 邮箱: 785981881@qq.com
- 🏢 地址: 广东省珠海市高新区科技三路1号
- 🌐 官网: https://same-f4dqy73vop0-latest.netlify.app

## 📄 开源协议

本项目采用 [MIT License](LICENSE)

---

**🎉 感谢使用珠海优美化妆品官网！**
