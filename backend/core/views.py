from rest_framework import viewsets, status
from rest_framework.decorators import action, api_view
from rest_framework.response import Response
from rest_framework.filters import SearchFilter, OrderingFilter
from django_filters.rest_framework import DjangoFilterBackend
from django.shortcuts import get_object_or_404
from django.db.models import Q, Count
from django.utils import timezone

from .models import (
    HeroSection, VisionSection, ValueItem, Tag, ProductCategory, Product,
    UserStory, StaticPage, SearchLog, AboutSection, ResearchSection,
    ResponsibilitySection, ServiceSection, CompanyInfo, ContactMessage, NewsArticle
)
from .serializers import (
    HeroSectionSerializer, VisionSectionSerializer, ValueItemSerializer,
    TagSerializer, ProductCategorySerializer, ProductListSerializer, ProductDetailSerializer,
    UserStoryListSerializer, UserStoryDetailSerializer, StaticPageSerializer, SearchLogSerializer,
    AboutSectionSerializer, ResearchSectionSerializer, ResponsibilitySectionSerializer,
    ServiceSectionListSerializer, ServiceSectionDetailSerializer, CompanyInfoSerializer,
    ContactMessageSerializer, NewsArticleListSerializer, NewsArticleDetailSerializer,
    SearchResultSerializer, SitemapSerializer, HomePageDataSerializer
)


def get_client_ip(request):
    """获取客户端IP地址"""
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        ip = x_forwarded_for.split(',')[0]
    else:
        ip = request.META.get('REMOTE_ADDR')
    return ip


@api_view(['GET'])
def homepage_data(request):
    """
    首页数据聚合接口 - 一次性返回首页所需的所有数据
    类似MSD网站的首页数据结构
    """
    try:
        # 获取各个区域的数据
        hero_sections = HeroSection.objects.filter(is_active=True).order_by('sort_order')[:3]
        vision_section = VisionSection.objects.filter(is_active=True).first()
        value_items = ValueItem.objects.filter(is_active=True).order_by('sort_order')[:4]
        product_categories = ProductCategory.objects.filter(is_active=True).order_by('sort_order')[:4]
        featured_products = Product.objects.filter(is_featured=True, is_active=True)[:6]
        about_section = AboutSection.objects.filter(is_active=True).first()
        research_section = ResearchSection.objects.filter(is_active=True).first()
        responsibility_section = ResponsibilitySection.objects.filter(is_active=True).first()
        service_sections = ServiceSection.objects.filter(is_active=True).order_by('sort_order')[:4]
        latest_news = NewsArticle.objects.filter(is_published=True).order_by('-publish_date')[:3]
        featured_user_stories = UserStory.objects.filter(is_featured=True, is_published=True).order_by('-publish_date')[:3]
        company_info = CompanyInfo.objects.first()

        # 序列化数据
        data = {
            'hero_sections': HeroSectionSerializer(hero_sections, many=True, context={'request': request}).data,
            'vision_section': VisionSectionSerializer(vision_section, context={'request': request}).data if vision_section else None,
            'value_items': ValueItemSerializer(value_items, many=True, context={'request': request}).data,
            'product_categories': ProductCategorySerializer(product_categories, many=True, context={'request': request}).data,
            'featured_products': ProductListSerializer(featured_products, many=True, context={'request': request}).data,
            'about_section': AboutSectionSerializer(about_section, context={'request': request}).data if about_section else None,
            'research_section': ResearchSectionSerializer(research_section, context={'request': request}).data if research_section else None,
            'responsibility_section': ResponsibilitySectionSerializer(responsibility_section, context={'request': request}).data if responsibility_section else None,
            'service_sections': ServiceSectionListSerializer(service_sections, many=True, context={'request': request}).data,
            'latest_news': NewsArticleListSerializer(latest_news, many=True, context={'request': request}).data,
            'featured_user_stories': UserStoryListSerializer(featured_user_stories, many=True, context={'request': request}).data,
            'company_info': CompanyInfoSerializer(company_info, context={'request': request}).data if company_info else None,
        }

        return Response(data)
    except Exception as e:
        return Response({
            'error': '获取首页数据失败',
            'detail': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['GET'])
def search_view(request):
    """
    全站搜索接口
    """
    query = request.GET.get('q', '').strip()
    if not query:
        return Response({
            'results': [],
            'total': 0,
            'query': ''
        })

    # 记录搜索日志
    try:
        results = []

        # 搜索产品
        products = Product.objects.filter(
            Q(title__icontains=query) |
            Q(description__icontains=query) |
            Q(ingredients__icontains=query) |
            Q(tags__name__icontains=query),
            is_active=True
        ).distinct()[:10]

        for product in products:
            results.append({
                'type': 'product',
                'id': product.id,
                'title': product.title,
                'slug': product.slug,
                'description': product.description[:150],
                'image': product.main_image.url if product.main_image else '',
                'url': f'/products/{product.id}',
                'relevance': 1.0
            })

        # 搜索新闻
        news = NewsArticle.objects.filter(
            Q(title__icontains=query) |
            Q(content__icontains=query) |
            Q(summary__icontains=query) |
            Q(tags__name__icontains=query),
            is_published=True
        ).distinct()[:10]

        for article in news:
            results.append({
                'type': 'news',
                'id': article.id,
                'title': article.title,
                'slug': article.slug,
                'description': article.summary or article.content[:150],
                'image': article.featured_image.url if article.featured_image else '',
                'url': f'/news/{article.id}',
                'relevance': 0.8
            })

        # 搜索服务
        services = ServiceSection.objects.filter(
            Q(title__icontains=query) |
            Q(description__icontains=query) |
            Q(detailed_description__icontains=query) |
            Q(tags__name__icontains=query),
            is_active=True
        ).distinct()[:5]

        for service in services:
            results.append({
                'type': 'service',
                'id': service.id,
                'title': service.title,
                'slug': service.slug,
                'description': service.description[:150],
                'image': service.image.url if service.image else '',
                'url': f'/services/{service.id}',
                'relevance': 0.7
            })

        # 搜索用户故事
        user_stories = UserStory.objects.filter(
            Q(title__icontains=query) |
            Q(content__icontains=query) |
            Q(summary__icontains=query) |
            Q(company_name__icontains=query) |
            Q(industry__icontains=query) |
            Q(tags__name__icontains=query),
            is_published=True
        ).distinct()[:5]

        for story in user_stories:
            results.append({
                'type': 'user_story',
                'id': story.id,
                'title': story.title,
                'slug': story.slug,
                'description': story.summary[:150],
                'image': story.featured_image.url if story.featured_image else '',
                'url': f'/user-stories/{story.id}',
                'relevance': 0.6
            })

        # 按相关性排序
        results.sort(key=lambda x: x['relevance'], reverse=True)

        # 记录搜索日志
        SearchLog.objects.create(
            query=query,
            results_count=len(results),
            ip_address=get_client_ip(request),
            user_agent=request.META.get('HTTP_USER_AGENT', '')
        )

        return Response({
            'results': results,
            'total': len(results),
            'query': query
        })

    except Exception as e:
        return Response({
            'error': '搜索失败',
            'detail': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['GET'])
def sitemap_view(request):
    """站点地图接口"""
    try:
        sitemap = [
            {
                'title': '首页',
                'url': '/',
                'type': 'page'
            },
            {
                'title': '产品中心',
                'url': '/products',
                'type': 'page',
                'children': [
                    {
                        'title': category.name,
                        'url': f'/products?category={category.id}',
                        'type': 'category'
                    } for category in ProductCategory.objects.filter(is_active=True)
                ]
            },
            {
                'title': '服务范围',
                'url': '/services',
                'type': 'page',
                'children': [
                    {
                        'title': service.title,
                        'url': f'/services/{service.slug}',
                        'type': 'service'
                    } for service in ServiceSection.objects.filter(is_active=True)
                ]
            },
            {
                'title': '用户故事',
                'url': '/user-stories',
                'type': 'page'
            },
            {
                'title': '新闻资讯',
                'url': '/news',
                'type': 'page'
            },
            {
                'title': '关于我们',
                'url': '/about',
                'type': 'page'
            },
            {
                'title': '联系我们',
                'url': '/contact',
                'type': 'page'
            }
        ]

        # 添加静态页面
        static_pages = StaticPage.objects.filter(is_active=True, show_in_sitemap=True)
        for page in static_pages:
            sitemap.append({
                'title': page.title,
                'url': f'/pages/{page.slug}',
                'type': 'static_page'
            })

        return Response(sitemap)

    except Exception as e:
        return Response({
            'error': '获取站点地图失败',
            'detail': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class TagViewSet(viewsets.ReadOnlyModelViewSet):
    """标签视图集"""
    queryset = Tag.objects.filter(is_active=True)
    serializer_class = TagSerializer
    lookup_field = 'slug'
    filter_backends = [SearchFilter, OrderingFilter]
    search_fields = ['name', 'description']
    ordering = ['name']

    @action(detail=True, methods=['get'])
    def related_content(self, request, slug=None):
        """获取标签关联的内容"""
        tag = self.get_object()

        # 获取关联的产品、新闻、服务、用户故事
        products = Product.objects.filter(tags=tag, is_active=True)[:10]
        news = NewsArticle.objects.filter(tags=tag, is_published=True)[:10]
        services = ServiceSection.objects.filter(tags=tag, is_active=True)[:5]
        user_stories = UserStory.objects.filter(tags=tag, is_published=True)[:5]

        return Response({
            'tag': TagSerializer(tag, context={'request': request}).data,
            'products': ProductListSerializer(products, many=True, context={'request': request}).data,
            'news': NewsArticleListSerializer(news, many=True, context={'request': request}).data,
            'services': ServiceSectionListSerializer(services, many=True, context={'request': request}).data,
            'user_stories': UserStoryListSerializer(user_stories, many=True, context={'request': request}).data,
        })


class UserStoryViewSet(viewsets.ReadOnlyModelViewSet):
    """用户故事视图集"""
    queryset = UserStory.objects.filter(is_published=True)
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['story_type', 'industry', 'is_featured']
    search_fields = ['title', 'summary', 'content', 'customer_name', 'company_name', 'industry']
    ordering_fields = ['publish_date', 'created_at', 'sort_order']
    ordering = ['-is_featured', 'sort_order', '-publish_date']
    lookup_field = 'slug'

    def get_serializer_class(self):
        if self.action == 'retrieve':
            return UserStoryDetailSerializer
        return UserStoryListSerializer

    @action(detail=False, methods=['get'])
    def featured(self, request):
        """获取推荐用户故事"""
        featured_stories = self.queryset.filter(is_featured=True)[:6]
        serializer = UserStoryListSerializer(featured_stories, many=True, context={'request': request})
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def by_type(self, request):
        """按类型获取用户故事"""
        story_type = request.query_params.get('type')
        if not story_type:
            return Response({'error': '缺少type参数'}, status=status.HTTP_400_BAD_REQUEST)

        stories = self.queryset.filter(story_type=story_type)
        page = self.paginate_queryset(stories)
        if page is not None:
            serializer = UserStoryListSerializer(page, many=True, context={'request': request})
            return self.get_paginated_response(serializer.data)

        serializer = UserStoryListSerializer(stories, many=True, context={'request': request})
        return Response(serializer.data)


class StaticPageViewSet(viewsets.ReadOnlyModelViewSet):
    """静态页面视图集"""
    queryset = StaticPage.objects.filter(is_active=True)
    serializer_class = StaticPageSerializer
    lookup_field = 'slug'
    filter_backends = [DjangoFilterBackend, SearchFilter]
    filterset_fields = ['page_type']
    search_fields = ['title', 'content']

    @action(detail=False, methods=['get'])
    def footer_pages(self, request):
        """获取在页脚显示的页面"""
        pages = self.queryset.filter(show_in_footer=True).order_by('sort_order')
        serializer = self.get_serializer(pages, many=True)
        return Response(serializer.data)


class HeroSectionViewSet(viewsets.ReadOnlyModelViewSet):
    """首页英雄区域视图集"""
    queryset = HeroSection.objects.filter(is_active=True)
    serializer_class = HeroSectionSerializer
    ordering = ['sort_order', '-created_at']


class VisionSectionViewSet(viewsets.ReadOnlyModelViewSet):
    """愿景区域视图集"""
    queryset = VisionSection.objects.filter(is_active=True)
    serializer_class = VisionSectionSerializer


class ValueItemViewSet(viewsets.ReadOnlyModelViewSet):
    """价值观项目视图集"""
    queryset = ValueItem.objects.filter(is_active=True)
    serializer_class = ValueItemSerializer
    ordering = ['sort_order', 'title']


class ProductCategoryViewSet(viewsets.ReadOnlyModelViewSet):
    """产品分类视图集"""
    queryset = ProductCategory.objects.filter(is_active=True)
    serializer_class = ProductCategorySerializer
    lookup_field = 'slug'
    ordering = ['sort_order', 'name']

    @action(detail=True, methods=['get'])
    def products(self, request, slug=None):
        """获取分类下的产品列表"""
        category = self.get_object()
        products = Product.objects.filter(category=category, is_active=True).order_by('sort_order', '-created_at')

        # 分页
        page = self.paginate_queryset(products)
        if page is not None:
            serializer = ProductListSerializer(page, many=True, context={'request': request})
            return self.get_paginated_response(serializer.data)

        serializer = ProductListSerializer(products, many=True, context={'request': request})
        return Response(serializer.data)


class ProductViewSet(viewsets.ReadOnlyModelViewSet):
    """产品视图集"""
    queryset = Product.objects.filter(is_active=True)
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['category', 'is_featured', 'tags']
    search_fields = ['title', 'description', 'ingredients', 'skin_type']
    ordering_fields = ['created_at', 'sort_order', 'title']
    ordering = ['-is_featured', 'sort_order', '-created_at']
    lookup_field = 'slug'

    def get_serializer_class(self):
        if self.action == 'retrieve':
            return ProductDetailSerializer
        return ProductListSerializer

    @action(detail=False, methods=['get'])
    def featured(self, request):
        """获取推荐产品"""
        featured_products = self.queryset.filter(is_featured=True)[:6]
        serializer = ProductListSerializer(featured_products, many=True, context={'request': request})
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def by_category(self, request):
        """按分类获取产品"""
        category_id = request.query_params.get('category_id')
        if not category_id:
            return Response({'error': '缺少category_id参数'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            category = ProductCategory.objects.get(id=category_id, is_active=True)
        except ProductCategory.DoesNotExist:
            return Response({'error': '分类不存在'}, status=status.HTTP_404_NOT_FOUND)

        products = self.queryset.filter(category=category)
        page = self.paginate_queryset(products)
        if page is not None:
            serializer = ProductListSerializer(page, many=True, context={'request': request})
            return self.get_paginated_response(serializer.data)

        serializer = ProductListSerializer(products, many=True, context={'request': request})
        return Response(serializer.data)


class AboutSectionViewSet(viewsets.ReadOnlyModelViewSet):
    """关于我们区域视图集"""
    queryset = AboutSection.objects.filter(is_active=True)
    serializer_class = AboutSectionSerializer


class ResearchSectionViewSet(viewsets.ReadOnlyModelViewSet):
    """研发区域视图集"""
    queryset = ResearchSection.objects.filter(is_active=True)
    serializer_class = ResearchSectionSerializer


class ResponsibilitySectionViewSet(viewsets.ReadOnlyModelViewSet):
    """社会责任区域视图集"""
    queryset = ResponsibilitySection.objects.filter(is_active=True)
    serializer_class = ResponsibilitySectionSerializer


class ServiceSectionViewSet(viewsets.ReadOnlyModelViewSet):
    """服务项目视图集"""
    queryset = ServiceSection.objects.filter(is_active=True)
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['tags']
    search_fields = ['title', 'description', 'detailed_description']
    ordering_fields = ['created_at', 'sort_order', 'title']
    ordering = ['sort_order', 'title']
    lookup_field = 'slug'

    def get_serializer_class(self):
        if self.action == 'retrieve':
            return ServiceSectionDetailSerializer
        return ServiceSectionListSerializer


class CompanyInfoViewSet(viewsets.ReadOnlyModelViewSet):
    """公司信息视图集"""
    queryset = CompanyInfo.objects.all()
    serializer_class = CompanyInfoSerializer

    @action(detail=False, methods=['get'])
    def basic(self, request):
        """获取基本公司信息"""
        try:
            company = CompanyInfo.objects.first()
            if company:
                serializer = self.get_serializer(company)
                return Response(serializer.data)
            else:
                return Response({'message': '公司信息未设置'}, status=status.HTTP_404_NOT_FOUND)
        except CompanyInfo.DoesNotExist:
            return Response({'message': '公司信息未找到'}, status=status.HTTP_404_NOT_FOUND)


class ContactMessageViewSet(viewsets.ModelViewSet):
    """联系消息视图集"""
    queryset = ContactMessage.objects.all()
    serializer_class = ContactMessageSerializer
    http_method_names = ['post', 'get']  # 只允许POST创建和GET查看

    def create(self, request, *args, **kwargs):
        """创建联系消息"""
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)

        return Response({
            'success': True,
            'message': '消息发送成功，我们会尽快联系您！',
            'data': serializer.data
        }, status=status.HTTP_201_CREATED)

    def get_queryset(self):
        """管理员可以查看所有消息，普通用户不能查看"""
        if self.request.user.is_staff:
            return ContactMessage.objects.all()
        return ContactMessage.objects.none()


class NewsArticleViewSet(viewsets.ReadOnlyModelViewSet):
    """新闻文章视图集"""
    queryset = NewsArticle.objects.filter(is_published=True)
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['news_type', 'is_featured', 'tags']
    search_fields = ['title', 'summary', 'content']
    ordering_fields = ['publish_date', 'created_at', 'read_count']
    ordering = ['-publish_date', '-created_at']
    lookup_field = 'slug'

    def get_serializer_class(self):
        if self.action == 'retrieve':
            return NewsArticleDetailSerializer
        return NewsArticleListSerializer

    def retrieve(self, request, *args, **kwargs):
        """获取新闻详情时增加阅读次数"""
        instance = self.get_object()
        instance.read_count += 1
        instance.save(update_fields=['read_count'])
        serializer = self.get_serializer(instance)
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def featured(self, request):
        """获取推荐新闻"""
        featured_news = self.queryset.filter(is_featured=True)[:4]
        serializer = NewsArticleListSerializer(featured_news, many=True, context={'request': request})
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def latest(self, request):
        """获取最新新闻"""
        latest_news = self.queryset[:6]
        serializer = NewsArticleListSerializer(latest_news, many=True, context={'request': request})
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def by_type(self, request):
        """按类型获取新闻"""
        news_type = request.query_params.get('type')
        if not news_type:
            return Response({'error': '缺少type参数'}, status=status.HTTP_400_BAD_REQUEST)

        news = self.queryset.filter(news_type=news_type)
        page = self.paginate_queryset(news)
        if page is not None:
            serializer = NewsArticleListSerializer(page, many=True, context={'request': request})
            return self.get_paginated_response(serializer.data)

        serializer = NewsArticleListSerializer(news, many=True, context={'request': request})
        return Response(serializer.data)
