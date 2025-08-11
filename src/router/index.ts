import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/Home.vue'),
    meta: {
      title: '美妆代工厂 - 专业美妆产品ODM/OEM制造商',
      description: '专业的美妆产品代工厂，提供ODM/OEM服务，拥有20年行业经验和先进的生产设备',
      keywords: '美妆代工,化妆品代工,ODM,OEM,化妆品制造,美妆产品',
    },
  },
  {
    path: '/about',
    name: 'About',
    component: () => import('@/views/About.vue'),
    meta: {
      title: '关于我们 - 美妆代工厂',
      description: '了解我们的企业文化、发展历程、生产能力和质量保证体系',
      keywords: '公司简介,企业文化,发展历程,生产能力',
    },
  },
  {
    path: '/products',
    name: 'Products',
    component: () => import('@/views/Products.vue'),
    meta: {
      title: '产品中心 - 美妆代工厂',
      description: '查看我们的美妆产品系列，包括护肤品、彩妆、个护用品等',
      keywords: '美妆产品,护肤品,彩妆,个护用品,产品系列',
    },
  },
  {
    path: '/products/:id',
    name: 'ProductDetail',
    component: () => import('@/views/ProductDetail.vue'),
    meta: {
      title: '产品详情 - 美妆代工厂',
    },
  },
  {
    path: '/services',
    name: 'Services',
    component: () => import('@/views/Services.vue'),
    meta: {
      title: '服务范围 - 美妆代工厂',
      description: '了解我们提供的ODM/OEM服务，从产品开发到生产制造的全方位服务',
      keywords: 'ODM服务,OEM服务,产品开发,生产制造,质量控制',
    },
  },
  {
    path: '/news',
    name: 'News',
    component: () => import('@/views/News.vue'),
    meta: {
      title: '新闻资讯 - 美妆代工厂',
      description: '获取最新的公司动态、行业资讯和技术分享',
      keywords: '公司新闻,行业资讯,技术分享,展会信息',
    },
  },
  {
    path: '/news/:id',
    name: 'NewsDetail',
    component: () => import('@/views/NewsDetail.vue'),
    meta: {
      title: '新闻详情 - 美妆代工厂',
    },
  },
  {
    path: '/contact',
    name: 'Contact',
    component: () => import('@/views/Contact.vue'),
    meta: {
      title: '联系我们 - 美妆代工厂',
      description: '联系我们获取报价和合作咨询，我们将为您提供专业的服务',
      keywords: '联系方式,合作咨询,获取报价,客户服务',
    },
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('@/views/NotFound.vue'),
    meta: {
      title: '页面未找到 - 美妆代工厂',
    },
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { top: 0 }
    }
  },
})

// 路由守卫 - 设置页面标题和meta信息
router.beforeEach((to, from, next) => {
  // 设置页面标题
  if (to.meta.title) {
    document.title = to.meta.title as string
  }

  // 设置meta description
  if (to.meta.description) {
    let metaDescription = document.querySelector('meta[name="description"]')
    if (!metaDescription) {
      metaDescription = document.createElement('meta')
      metaDescription.setAttribute('name', 'description')
      document.head.appendChild(metaDescription)
    }
    metaDescription.setAttribute('content', to.meta.description as string)
  }

  // 设置meta keywords
  if (to.meta.keywords) {
    let metaKeywords = document.querySelector('meta[name="keywords"]')
    if (!metaKeywords) {
      metaKeywords = document.createElement('meta')
      metaKeywords.setAttribute('name', 'keywords')
      document.head.appendChild(metaKeywords)
    }
    metaKeywords.setAttribute('content', to.meta.keywords as string)
  }

  next()
})

export default router
