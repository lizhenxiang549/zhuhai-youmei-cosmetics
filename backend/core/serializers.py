from rest_framework import serializers
from .models import (
    HeroSection, VisionSection, ValueItem, Tag, ProductCategory, Product,
    UserStory, StaticPage, SearchLog, AboutSection, ResearchSection,
    ResponsibilitySection, ServiceSection, CompanyInfo, ContactMessage, NewsArticle
)


class TagSerializer(serializers.ModelSerializer):
    """标签序列化器"""
    class Meta:
        model = Tag
        fields = '__all__'


class HeroSectionSerializer(serializers.ModelSerializer):
    """首页英雄区域序列化器"""
    class Meta:
        model = HeroSection
        fields = '__all__'


class VisionSectionSerializer(serializers.ModelSerializer):
    """愿景区域序列化器"""
    class Meta:
        model = VisionSection
        fields = '__all__'


class ValueItemSerializer(serializers.ModelSerializer):
    """价值观项目序列化器"""
    class Meta:
        model = ValueItem
        fields = '__all__'


class ProductCategorySerializer(serializers.ModelSerializer):
    """产品分类序列化器"""
    product_count = serializers.SerializerMethodField()

    class Meta:
        model = ProductCategory
        fields = '__all__'

    def get_product_count(self, obj):
        return obj.product_set.filter(is_active=True).count()


class ProductListSerializer(serializers.ModelSerializer):
    """产品列表序列化器（简化版）"""
    category_name = serializers.CharField(source='category.name', read_only=True)

    class Meta:
        model = Product
        fields = [
            'id', 'title', 'slug', 'category_name', 'description', 'main_image',
            'min_order_quantity', 'production_time', 'is_featured', 'created_at'
        ]


class ProductDetailSerializer(serializers.ModelSerializer):
    """产品详情序列化器（完整版）"""
    category_name = serializers.CharField(source='category.name', read_only=True)
    category_info = ProductCategorySerializer(source='category', read_only=True)

    class Meta:
        model = Product
        fields = '__all__'


class UserStoryListSerializer(serializers.ModelSerializer):
    """用户故事列表序列化器"""
    related_products_count = serializers.SerializerMethodField()

    class Meta:
        model = UserStory
        fields = [
            'id', 'title', 'slug', 'story_type', 'customer_name', 'company_name',
            'industry', 'summary', 'featured_image', 'is_featured',
            'related_products_count', 'publish_date', 'created_at'
        ]

    def get_related_products_count(self, obj):
        return obj.related_products.count()


class UserStoryDetailSerializer(serializers.ModelSerializer):
    """用户故事详情序列化器"""
    related_products = ProductListSerializer(many=True, read_only=True)

    class Meta:
        model = UserStory
        fields = '__all__'


class StaticPageSerializer(serializers.ModelSerializer):
    """静态页面序列化器"""
    class Meta:
        model = StaticPage
        fields = '__all__'


class SearchLogSerializer(serializers.ModelSerializer):
    """搜索日志序列化器"""
    class Meta:
        model = SearchLog
        fields = '__all__'
        read_only_fields = ('created_at',)


class AboutSectionSerializer(serializers.ModelSerializer):
    """关于我们区域序列化器"""
    class Meta:
        model = AboutSection
        fields = '__all__'


class ResearchSectionSerializer(serializers.ModelSerializer):
    """研发区域序列化器"""
    class Meta:
        model = ResearchSection
        fields = '__all__'


class ResponsibilitySectionSerializer(serializers.ModelSerializer):
    """社会责任区域序列化器"""
    class Meta:
        model = ResponsibilitySection
        fields = '__all__'


class ServiceSectionListSerializer(serializers.ModelSerializer):
    """服务项目列表序列化器"""
    related_products_count = serializers.SerializerMethodField()

    class Meta:
        model = ServiceSection
        fields = [
            'id', 'title', 'slug', 'description', 'features', 'process_steps',
            'icon', 'image', 'related_products_count', 'sort_order', 'created_at'
        ]

    def get_related_products_count(self, obj):
        return obj.related_products.count()


class ServiceSectionDetailSerializer(serializers.ModelSerializer):
    """服务项目详情序列化器"""
    related_products = ProductListSerializer(many=True, read_only=True)

    class Meta:
        model = ServiceSection
        fields = '__all__'


class CompanyInfoSerializer(serializers.ModelSerializer):
    """公司信息序列化器"""
    class Meta:
        model = CompanyInfo
        fields = '__all__'


class ContactMessageSerializer(serializers.ModelSerializer):
    """联系消息序列化器"""
    class Meta:
        model = ContactMessage
        fields = '__all__'
        read_only_fields = ('is_read', 'is_replied', 'reply_content', 'reply_date', 'created_at')


class NewsArticleListSerializer(serializers.ModelSerializer):
    """新闻列表序列化器（简化版）"""
    author_name = serializers.CharField(source='author.username', read_only=True)

    class Meta:
        model = NewsArticle
        fields = [
            'id', 'title', 'slug', 'summary', 'news_type', 'featured_image',
            'author_name', 'is_featured', 'publish_date', 'read_count', 'created_at'
        ]


class NewsArticleDetailSerializer(serializers.ModelSerializer):
    """新闻详情序列化器（完整版）"""
    author_name = serializers.CharField(source='author.username', read_only=True)

    class Meta:
        model = NewsArticle
        fields = '__all__'


class SearchResultSerializer(serializers.Serializer):
    """搜索结果序列化器"""
    type = serializers.CharField()  # 'product', 'news', 'service', 'user_story'
    id = serializers.IntegerField()
    title = serializers.CharField()
    slug = serializers.CharField()
    description = serializers.CharField()
    image = serializers.CharField(required=False)
    url = serializers.CharField()
    relevance = serializers.FloatField(default=1.0)


class SitemapSerializer(serializers.Serializer):
    """站点地图序列化器"""
    title = serializers.CharField()
    url = serializers.CharField()
    type = serializers.CharField()
    children = serializers.ListField(child=serializers.DictField(), required=False)


class HomePageDataSerializer(serializers.Serializer):
    """首页数据聚合序列化器"""
    hero_sections = HeroSectionSerializer(many=True)
    vision_section = VisionSectionSerializer()
    value_items = ValueItemSerializer(many=True)
    product_categories = ProductCategorySerializer(many=True)
    featured_products = ProductListSerializer(many=True)
    about_section = AboutSectionSerializer()
    research_section = ResearchSectionSerializer()
    responsibility_section = ResponsibilitySectionSerializer()
    service_sections = ServiceSectionListSerializer(many=True)
    latest_news = NewsArticleListSerializer(many=True)
    featured_user_stories = UserStoryListSerializer(many=True)
    company_info = CompanyInfoSerializer()
