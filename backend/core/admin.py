from django.contrib import admin
from .models import (
    HeroSection, VisionSection, ValueItem, ProductCategory, Product,
    AboutSection, ResearchSection, ResponsibilitySection, ServiceSection,
    CompanyInfo, ContactMessage, NewsArticle
)


@admin.register(HeroSection)
class HeroSectionAdmin(admin.ModelAdmin):
    list_display = ['title', 'sort_order', 'is_active', 'created_at']
    list_filter = ['is_active', 'created_at']
    search_fields = ['title', 'subtitle']
    ordering = ['sort_order', '-created_at']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(VisionSection)
class VisionSectionAdmin(admin.ModelAdmin):
    list_display = ['title', 'is_active', 'created_at']
    list_filter = ['is_active', 'created_at']
    search_fields = ['title', 'content']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(ValueItem)
class ValueItemAdmin(admin.ModelAdmin):
    list_display = ['title', 'sort_order', 'is_active', 'created_at']
    list_filter = ['is_active', 'created_at']
    search_fields = ['title', 'description']
    ordering = ['sort_order', 'title']


@admin.register(ProductCategory)
class ProductCategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'sort_order', 'is_active', 'product_count', 'image_preview', 'created_at']
    list_filter = ['is_active', 'created_at']
    search_fields = ['name', 'description']
    ordering = ['sort_order', 'name']
    readonly_fields = ['created_at', 'updated_at', 'image_preview', 'product_count']
    list_editable = ['sort_order']

    def image_preview(self, obj):
        if obj.image:
            return f'<img src="{obj.image.url}" style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px;" />'
        return '无图片'
    image_preview.short_description = '图片预览'
    image_preview.allow_tags = True

    def product_count(self, obj):
        return obj.product_set.count()
    product_count.short_description = '产品数量'

    fieldsets = (
        ('基本信息', {
            'fields': ('name', 'slug', 'description'),
            'description': '分类名称需要与前端导航菜单对应（香水、彩妆、护肤等）'
        }),
        ('显示设置', {
            'fields': ('image', 'image_preview', 'icon', 'sort_order', 'is_active'),
            'description': '分类图片和图标用于前端展示'
        }),
        ('统计信息', {
            'fields': ('product_count',),
            'description': '此分类下的产品数量'
        }),
        ('系统信息', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ['title', 'category', 'is_featured', 'is_active', 'sort_order', 'image_preview', 'created_at']
    list_filter = ['category', 'is_featured', 'is_active', 'skin_type', 'created_at']
    search_fields = ['title', 'description', 'ingredients']
    ordering = ['-is_featured', 'sort_order', '-created_at']
    readonly_fields = ['created_at', 'updated_at', 'image_preview']
    list_editable = ['is_featured', 'sort_order']

    def image_preview(self, obj):
        if obj.main_image:
            return f'<img src="{obj.main_image.url}" style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px;" />'
        return '无图片'
    image_preview.short_description = '图片预览'
    image_preview.allow_tags = True

    fieldsets = (
        ('基本信息', {
            'fields': ('title', 'slug', 'category', 'description')
        }),
        ('产品图片', {
            'fields': ('main_image', 'image_preview', 'gallery_images'),
            'description': '主图将显示在产品列表和详情页面顶部'
        }),
        ('产品详情', {
            'fields': ('features', 'specifications', 'ingredients', 'skin_type', 'usage_method'),
            'description': '详细的产品信息，帮助客户了解产品特性'
        }),
        ('业务信息', {
            'fields': ('min_order_quantity', 'production_time', 'customization_options'),
            'description': 'ODM/OEM相关的业务信息'
        }),
        ('质量认证', {
            'fields': ('certifications', 'quality_standards'),
            'description': '产品质量认证和标准（JSON格式）'
        }),
        ('标签和分类', {
            'fields': ('tags',),
            'description': '为产品添加标签，便于搜索和分类'
        }),
        ('显示设置', {
            'fields': ('is_featured', 'is_active', 'sort_order'),
            'description': '推荐产品会在首页显示，排序数字越小越靠前'
        }),
        ('系统信息', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )

    class Media:
        css = {
            'all': ('admin/css/custom_admin.css',)
        }


@admin.register(AboutSection)
class AboutSectionAdmin(admin.ModelAdmin):
    list_display = ['title', 'is_active', 'created_at']
    list_filter = ['is_active', 'created_at']
    search_fields = ['title', 'subtitle', 'content']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(ResearchSection)
class ResearchSectionAdmin(admin.ModelAdmin):
    list_display = ['title', 'is_active', 'created_at']
    list_filter = ['is_active', 'created_at']
    search_fields = ['title', 'content']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(ResponsibilitySection)
class ResponsibilitySectionAdmin(admin.ModelAdmin):
    list_display = ['title', 'is_active', 'created_at']
    list_filter = ['is_active', 'created_at']
    search_fields = ['title', 'content']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(ServiceSection)
class ServiceSectionAdmin(admin.ModelAdmin):
    list_display = ['title', 'sort_order', 'is_active', 'created_at']
    list_filter = ['is_active', 'created_at']
    search_fields = ['title', 'description']
    ordering = ['sort_order', 'title']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(CompanyInfo)
class CompanyInfoAdmin(admin.ModelAdmin):
    list_display = ['name', 'phone', 'email', 'established_year', 'updated_at']
    search_fields = ['name', 'address', 'phone', 'email']
    readonly_fields = ['created_at', 'updated_at']

    fieldsets = (
        ('基本信息', {
            'fields': ('name', 'logo')
        }),
        ('联系信息', {
            'fields': ('address', 'phone', 'email', 'website')
        }),
        ('法律信息', {
            'fields': ('copyright_text', 'icp_number', 'business_license')
        }),
        ('统计数据', {
            'fields': ('established_year', 'employee_count', 'factory_area', 'annual_capacity')
        }),
        ('系统信息', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )


@admin.register(ContactMessage)
class ContactMessageAdmin(admin.ModelAdmin):
    list_display = ['name', 'email', 'company', 'inquiry_type', 'subject', 'is_read', 'is_replied', 'created_at']
    list_filter = ['inquiry_type', 'is_read', 'is_replied', 'created_at']
    search_fields = ['name', 'email', 'company', 'subject', 'message']
    ordering = ['-created_at']
    readonly_fields = ['created_at']

    actions = ['mark_as_read', 'mark_as_replied']

    def mark_as_read(self, request, queryset):
        queryset.update(is_read=True)
        self.message_user(request, f"已标记 {queryset.count()} 条消息为已读")
    mark_as_read.short_description = "标记为已读"

    def mark_as_replied(self, request, queryset):
        queryset.update(is_replied=True)
        self.message_user(request, f"已标记 {queryset.count()} 条消息为已回复")
    mark_as_replied.short_description = "标记为已回复"

    fieldsets = (
        ('联系人信息', {
            'fields': ('name', 'email', 'phone', 'company', 'position')
        }),
        ('咨询内容', {
            'fields': ('inquiry_type', 'subject', 'message', 'product_interest', 'order_quantity')
        }),
        ('处理状态', {
            'fields': ('is_read', 'is_replied', 'reply_content', 'reply_date')
        }),
        ('系统信息', {
            'fields': ('created_at',),
            'classes': ('collapse',)
        }),
    )


@admin.register(NewsArticle)
class NewsArticleAdmin(admin.ModelAdmin):
    list_display = ['title', 'news_type', 'author', 'is_published', 'is_featured', 'publish_date', 'read_count']
    list_filter = ['news_type', 'is_published', 'is_featured', 'publish_date', 'created_at']
    search_fields = ['title', 'summary', 'content', 'tags']
    ordering = ['-publish_date', '-created_at']
    readonly_fields = ['created_at', 'updated_at', 'read_count']

    def save_model(self, request, obj, form, change):
        if not obj.author_id:
            obj.author = request.user
        super().save_model(request, obj, form, change)

    fieldsets = (
        ('基本信息', {
            'fields': ('title', 'summary', 'content', 'featured_image')
        }),
        ('分类和标签', {
            'fields': ('news_type', 'tags', 'author')
        }),
        ('发布设置', {
            'fields': ('is_published', 'is_featured', 'publish_date')
        }),
        ('统计信息', {
            'fields': ('read_count', 'created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )


# 自定义Admin站点标题
admin.site.site_header = '美妆代工厂管理后台'
admin.site.site_title = '美妆代工厂'
admin.site.index_title = '内容管理系统'
