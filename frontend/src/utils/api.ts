import axios, { AxiosInstance, AxiosResponse } from 'axios'
import type {
  ApiResponse,
  PaginatedResponse,
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
  ContactMessage,
  NewsListItem,
  NewsArticle,
  SearchParams,
} from '@/types'

// 创建axios实例
const api: AxiosInstance = axios.create({
  baseURL: '/api',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
})

// 请求拦截器
api.interceptors.request.use(
  (config) => {
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// 响应拦截器
api.interceptors.response.use(
  (response: AxiosResponse) => {
    return response
  },
  (error) => {
    console.error('API Error:', error)
    return Promise.reject(error)
  }
)

// API服务类
class ApiService {
  // 通用请求方法
  async get<T>(url: string, params?: any): Promise<T> {
    const response = await api.get<T>(url, { params })
    return response.data
  }

  async post<T>(url: string, data?: any): Promise<T> {
    const response = await api.post<T>(url, data)
    return response.data
  }

  async put<T>(url: string, data?: any): Promise<T> {
    const response = await api.put<T>(url, data)
    return response.data
  }

  async delete<T>(url: string): Promise<T> {
    const response = await api.delete<T>(url)
    return response.data
  }

  // 首页数据聚合接口
  async getHomepageData(): Promise<HomePageData> {
    return this.get<HomePageData>('/homepage/')
  }

  // 英雄区域相关API
  async getHeroSections(): Promise<HeroSection[]> {
    return this.get<HeroSection[]>('/hero-sections/')
  }

  async getHeroSectionById(id: number): Promise<HeroSection> {
    return this.get<HeroSection>(`/hero-sections/${id}/`)
  }

  // 愿景区域相关API
  async getVisionSections(): Promise<VisionSection[]> {
    return this.get<VisionSection[]>('/vision-sections/')
  }

  // 价值观项目相关API
  async getValueItems(): Promise<ValueItem[]> {
    return this.get<ValueItem[]>('/value-items/')
  }

  // 产品分类相关API
  async getProductCategories(): Promise<ProductCategory[]> {
    return this.get<ProductCategory[]>('/product-categories/')
  }

  async getProductCategoryById(id: number): Promise<ProductCategory> {
    return this.get<ProductCategory>(`/product-categories/${id}/`)
  }

  async getCategoryProducts(id: number, params?: SearchParams): Promise<PaginatedResponse<ProductListItem>> {
    return this.get<PaginatedResponse<ProductListItem>>(`/product-categories/${id}/products/`, params)
  }

  // 产品相关API
  async getProducts(params?: SearchParams): Promise<PaginatedResponse<ProductListItem>> {
    return this.get<PaginatedResponse<ProductListItem>>('/products/', params)
  }

  async getProductById(id: number): Promise<Product> {
    return this.get<Product>(`/products/${id}/`)
  }

  async getFeaturedProducts(): Promise<ProductListItem[]> {
    return this.get<ProductListItem[]>('/products/featured/')
  }

  async getProductsByCategory(categoryId: number, params?: SearchParams): Promise<PaginatedResponse<ProductListItem>> {
    return this.get<PaginatedResponse<ProductListItem>>('/products/by_category/', {
      ...params,
      category_id: categoryId
    })
  }

  // 关于我们区域相关API
  async getAboutSections(): Promise<AboutSection[]> {
    return this.get<AboutSection[]>('/about-sections/')
  }

  // 研发区域相关API
  async getResearchSections(): Promise<ResearchSection[]> {
    return this.get<ResearchSection[]>('/research-sections/')
  }

  // 社会责任区域相关API
  async getResponsibilitySections(): Promise<ResponsibilitySection[]> {
    return this.get<ResponsibilitySection[]>('/responsibility-sections/')
  }

  // 服务项目相关API
  async getServiceSections(): Promise<ServiceSection[]> {
    return this.get<ServiceSection[]>('/service-sections/')
  }

  async getServiceSectionById(id: number): Promise<ServiceSection> {
    return this.get<ServiceSection>(`/service-sections/${id}/`)
  }

  // 公司信息相关API
  async getCompanyInfo(): Promise<CompanyInfo> {
    return this.get<CompanyInfo>('/company-info/basic/')
  }

  // 联系消息相关API
  async submitContactMessage(data: ContactMessage): Promise<ApiResponse<ContactMessage>> {
    return this.post<ApiResponse<ContactMessage>>('/contact-messages/', data)
  }

  // 新闻相关API
  async getNews(params?: SearchParams): Promise<PaginatedResponse<NewsListItem>> {
    return this.get<PaginatedResponse<NewsListItem>>('/news/', params)
  }

  async getNewsById(id: number): Promise<NewsArticle> {
    return this.get<NewsArticle>(`/news/${id}/`)
  }

  async getFeaturedNews(): Promise<NewsListItem[]> {
    return this.get<NewsListItem[]>('/news/featured/')
  }

  async getLatestNews(): Promise<NewsListItem[]> {
    return this.get<NewsListItem[]>('/news/latest/')
  }

  async getNewsByType(type: string, params?: SearchParams): Promise<PaginatedResponse<NewsListItem>> {
    return this.get<PaginatedResponse<NewsListItem>>('/news/by_type/', {
      ...params,
      type
    })
  }
}

// 创建并导出API服务实例
export const apiService = new ApiService()
export default api
