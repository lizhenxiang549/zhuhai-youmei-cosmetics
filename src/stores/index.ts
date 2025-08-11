import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { apiService } from '@/utils/api'
import type {
  HomePageData,
  HeroSection,
  VisionSection,
  ValueItem,
  ProductCategory,
  ProductListItem,
  Product,
  AboutSection,
  ResearchSection,
  ResponsibilitySection,
  ServiceSection,
  CompanyInfo,
  NewsListItem,
  NewsArticle,
  SearchParams,
} from '@/types'

// 主应用状态
export const useAppStore = defineStore('app', () => {
  const loading = ref(false)
  const error = ref<string | null>(null)

  const setLoading = (value: boolean) => {
    loading.value = value
  }

  const setError = (value: string | null) => {
    error.value = value
  }

  const clearError = () => {
    error.value = null
  }

  return {
    loading,
    error,
    setLoading,
    setError,
    clearError,
  }
})

// 首页数据状态
export const useHomeStore = defineStore('home', () => {
  const homeData = ref<HomePageData | null>(null)
  const loading = ref(false)
  const error = ref<string | null>(null)

  const getHomeData = async () => {
    loading.value = true
    error.value = null
    try {
      homeData.value = await apiService.getHomepageData()
    } catch (err) {
      error.value = '获取首页数据失败'
      console.error('Failed to fetch home data:', err)
    } finally {
      loading.value = false
    }
  }

  return {
    homeData,
    loading,
    error,
    getHomeData,
  }
})

// 产品相关状态
export const useProductStore = defineStore('product', () => {
  const categories = ref<ProductCategory[]>([])
  const products = ref<ProductListItem[]>([])
  const featuredProducts = ref<ProductListItem[]>([])
  const currentProduct = ref<Product | null>(null)
  const productsTotal = ref(0)
  const currentPage = ref(1)
  const loading = ref(false)
  const error = ref<string | null>(null)

  const getCategories = async () => {
    try {
      categories.value = await apiService.getProductCategories()
    } catch (err) {
      error.value = '获取产品分类失败'
      console.error('Failed to fetch categories:', err)
    }
  }

  const getProducts = async (params?: SearchParams) => {
    loading.value = true
    error.value = null
    try {
      const response = await apiService.getProducts(params)
      products.value = response.results
      productsTotal.value = response.count
      if (params?.page) {
        currentPage.value = params.page
      }
    } catch (err) {
      error.value = '获取产品列表失败'
      console.error('Failed to fetch products:', err)
    } finally {
      loading.value = false
    }
  }

  const getFeaturedProducts = async () => {
    try {
      featuredProducts.value = await apiService.getFeaturedProducts()
    } catch (err) {
      error.value = '获取推荐产品失败'
      console.error('Failed to fetch featured products:', err)
    }
  }

  const getProductById = async (id: number) => {
    loading.value = true
    error.value = null
    try {
      currentProduct.value = await apiService.getProductById(id)
      return currentProduct.value
    } catch (err) {
      error.value = '获取产品详情失败'
      console.error('Failed to fetch product:', err)
      return null
    } finally {
      loading.value = false
    }
  }

  const getCategoryProducts = async (categoryId: number, params?: SearchParams) => {
    loading.value = true
    error.value = null
    try {
      const response = await apiService.getProductsByCategory(categoryId, params)
      products.value = response.results
      productsTotal.value = response.count
      return response
    } catch (err) {
      error.value = '获取分类产品失败'
      console.error('Failed to fetch category products:', err)
      return { results: [], count: 0, next: null, previous: null }
    } finally {
      loading.value = false
    }
  }

  return {
    categories,
    products,
    featuredProducts,
    currentProduct,
    productsTotal,
    currentPage,
    loading,
    error,
    getCategories,
    getProducts,
    getFeaturedProducts,
    getProductById,
    getCategoryProducts,
  }
})

// 服务相关状态
export const useServiceStore = defineStore('service', () => {
  const services = ref<ServiceSection[]>([])
  const currentService = ref<ServiceSection | null>(null)
  const loading = ref(false)
  const error = ref<string | null>(null)

  const getServices = async () => {
    loading.value = true
    error.value = null
    try {
      services.value = await apiService.getServiceSections()
    } catch (err) {
      error.value = '获取服务信息失败'
      console.error('Failed to fetch services:', err)
    } finally {
      loading.value = false
    }
  }

  const getServiceById = async (id: number) => {
    loading.value = true
    error.value = null
    try {
      currentService.value = await apiService.getServiceSectionById(id)
      return currentService.value
    } catch (err) {
      error.value = '获取服务详情失败'
      console.error('Failed to fetch service:', err)
      return null
    } finally {
      loading.value = false
    }
  }

  return {
    services,
    currentService,
    loading,
    error,
    getServices,
    getServiceById,
  }
})

// 新闻相关状态
export const useNewsStore = defineStore('news', () => {
  const news = ref<NewsListItem[]>([])
  const featuredNews = ref<NewsListItem[]>([])
  const latestNews = ref<NewsListItem[]>([])
  const currentNews = ref<NewsArticle | null>(null)
  const newsTotal = ref(0)
  const currentPage = ref(1)
  const loading = ref(false)
  const error = ref<string | null>(null)

  const getNews = async (params?: SearchParams) => {
    loading.value = true
    error.value = null
    try {
      const response = await apiService.getNews(params)
      news.value = response.results
      newsTotal.value = response.count
      if (params?.page) {
        currentPage.value = params.page
      }
    } catch (err) {
      error.value = '获取新闻列表失败'
      console.error('Failed to fetch news:', err)
    } finally {
      loading.value = false
    }
  }

  const getFeaturedNews = async () => {
    try {
      featuredNews.value = await apiService.getFeaturedNews()
    } catch (err) {
      error.value = '获取推荐新闻失败'
      console.error('Failed to fetch featured news:', err)
    }
  }

  const getLatestNews = async () => {
    try {
      latestNews.value = await apiService.getLatestNews()
    } catch (err) {
      error.value = '获取最新新闻失败'
      console.error('Failed to fetch latest news:', err)
    }
  }

  const getNewsById = async (id: number) => {
    loading.value = true
    error.value = null
    try {
      currentNews.value = await apiService.getNewsById(id)
      return currentNews.value
    } catch (err) {
      error.value = '获取新闻详情失败'
      console.error('Failed to fetch news:', err)
      return null
    } finally {
      loading.value = false
    }
  }

  const getNewsByType = async (type: string, params?: SearchParams) => {
    loading.value = true
    error.value = null
    try {
      const response = await apiService.getNewsByType(type, params)
      news.value = response.results
      newsTotal.value = response.count
      return response
    } catch (err) {
      error.value = '获取新闻分类失败'
      console.error('Failed to fetch news by type:', err)
      return { results: [], count: 0, next: null, previous: null }
    } finally {
      loading.value = false
    }
  }

  return {
    news,
    featuredNews,
    latestNews,
    currentNews,
    newsTotal,
    currentPage,
    loading,
    error,
    getNews,
    getFeaturedNews,
    getLatestNews,
    getNewsById,
    getNewsByType,
  }
})

// 公司信息状态
export const useCompanyStore = defineStore('company', () => {
  const companyInfo = ref<CompanyInfo | null>(null)
  const loading = ref(false)
  const error = ref<string | null>(null)

  const getCompanyInfo = async () => {
    loading.value = true
    error.value = null
    try {
      companyInfo.value = await apiService.getCompanyInfo()
    } catch (err) {
      error.value = '获取公司信息失败'
      console.error('Failed to fetch company info:', err)
    } finally {
      loading.value = false
    }
  }

  return {
    companyInfo,
    loading,
    error,
    getCompanyInfo,
  }
})
