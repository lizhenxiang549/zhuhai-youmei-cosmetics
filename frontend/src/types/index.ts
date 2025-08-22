// API响应基础类型
export interface ApiResponse<T> {
  success: boolean
  message?: string
  data?: T
}

// 分页响应类型
export interface PaginatedResponse<T> {
  count: number
  next: string | null
  previous: string | null
  results: T[]
}

// 首页英雄区域
export interface HeroSection {
  id: number
  title: string
  subtitle: string
  description: string
  image: string
  button_text: string
  button_link: string
  is_active: boolean
  sort_order: number
  created_at: string
  updated_at: string
}

// 愿景区域
export interface VisionSection {
  id: number
  title: string
  content: string
  subtitle_1: string
  subtitle_2: string
  subtitle_3: string
  is_active: boolean
  created_at: string
  updated_at: string
}

// 价值观项目
export interface ValueItem {
  id: number
  title: string
  description: string
  icon: string
  sort_order: number
  is_active: boolean
  created_at: string
}

// 产品分类
export interface ProductCategory {
  id: number
  name: string
  description: string
  image: string
  icon: string
  sort_order: number
  is_active: boolean
  product_count: number
  created_at: string
  updated_at: string
}

// 产品 - 列表版本
export interface ProductListItem {
  id: number
  title: string
  category_name: string
  description: string
  main_image: string
  min_order_quantity: string
  production_time: string
  is_featured: boolean
  created_at: string
}

// 产品 - 详情版本
export interface Product extends ProductListItem {
  category: number
  features: string
  specifications: string
  gallery_images: string[]
  ingredients: string
  skin_type: string
  usage_method: string
  customization_options: string
  certifications: string[]
  quality_standards: string[]
  is_active: boolean
  sort_order: number
  updated_at: string
  category_info: ProductCategory
}

// 关于我们区域
export interface AboutSection {
  id: number
  title: string
  subtitle: string
  content: string
  image: string
  button_text: string
  button_link: string
  is_active: boolean
  created_at: string
  updated_at: string
}

// 研发区域
export interface ResearchSection {
  id: number
  title: string
  content: string
  image?: string
  button_text: string
  button_link: string
  is_active: boolean
  created_at: string
  updated_at: string
}

// 社会责任区域
export interface ResponsibilitySection {
  id: number
  title: string
  content: string
  image: string
  button_text: string
  button_link: string
  is_active: boolean
  created_at: string
  updated_at: string
}

// 服务项目
export interface ServiceSection {
  id: number
  title: string
  description: string
  features: string[]
  process_steps: string[]
  icon: string
  image?: string
  sort_order: number
  is_active: boolean
  created_at: string
  updated_at: string
}

// 公司信息
export interface CompanyInfo {
  id: number
  name: string
  logo?: string
  address: string
  phone: string
  email: string
  website: string
  copyright_text: string
  icp_number: string
  business_license: string
  established_year?: number
  employee_count?: number
  factory_area: string
  annual_capacity: string
  created_at: string
  updated_at: string
}

// 联系消息
export interface ContactMessage {
  id?: number
  name: string
  email: string
  phone?: string
  company?: string
  position?: string
  inquiry_type: 'general' | 'quotation' | 'odm' | 'oem' | 'partnership' | 'technical'
  subject: string
  message: string
  product_interest?: string
  order_quantity?: string
  is_read?: boolean
  is_replied?: boolean
  reply_content?: string
  reply_date?: string
  created_at?: string
}

// 新闻文章 - 列表版本
export interface NewsListItem {
  id: number
  title: string
  summary: string
  news_type: 'company' | 'industry' | 'technology' | 'exhibition'
  featured_image?: string
  author_name: string
  is_featured: boolean
  publish_date?: string
  read_count: number
  created_at: string
}

// 新闻文章 - 详情版本
export interface NewsArticle extends NewsListItem {
  content: string
  author: number
  is_published: boolean
  tags: string[]
  updated_at: string
}

// 首页数据聚合
export interface HomePageData {
  hero_sections: HeroSection[]
  vision_section: VisionSection | null
  value_items: ValueItem[]
  product_categories: ProductCategory[]
  featured_products: ProductListItem[]
  about_section: AboutSection | null
  research_section: ResearchSection | null
  responsibility_section: ResponsibilitySection | null
  service_sections: ServiceSection[]
  latest_news: NewsListItem[]
  company_info: CompanyInfo | null
}

// 路由元数据
export interface RouteMeta {
  title?: string
  description?: string
  keywords?: string
}

// 搜索参数
export interface SearchParams {
  page?: number
  page_size?: number
  search?: string
  ordering?: string
  [key: string]: any
}

// 新闻类型标签
export const NEWS_TYPE_LABELS = {
  company: '公司新闻',
  industry: '行业资讯',
  technology: '技术创新',
  exhibition: '展会活动'
} as const

// 咨询类型标签
export const INQUIRY_TYPE_LABELS = {
  general: '一般咨询',
  quotation: '产品询价',
  odm: 'ODM定制',
  oem: 'OEM代工',
  partnership: '合作洽谈',
  technical: '技术支持'
} as const
