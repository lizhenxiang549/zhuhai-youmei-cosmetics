from django.urls import path, include
from rest_framework.routers import DefaultRouter
from django.http import JsonResponse
from . import views

def root_view(request):
    """根路径视图 - 重定向到首页数据"""
    return JsonResponse({
        'message': '欢迎访问珠海优美官网API',
        'company': '珠海优美化妆品有限公司',
        'phone': '13727893557',
        'email': '785981881@qq.com',
        'api_endpoints': {
            'homepage': '/api/homepage/',
            'admin': '/admin/',
        }
    })

# 创建DRF路由器
router = DefaultRouter()
router.register(r'hero-sections', views.HeroSectionViewSet)
router.register(r'vision-sections', views.VisionSectionViewSet)
router.register(r'value-items', views.ValueItemViewSet)
router.register(r'tags', views.TagViewSet)
router.register(r'product-categories', views.ProductCategoryViewSet)
router.register(r'products', views.ProductViewSet)
router.register(r'user-stories', views.UserStoryViewSet)
router.register(r'static-pages', views.StaticPageViewSet)
router.register(r'about-sections', views.AboutSectionViewSet)
router.register(r'research-sections', views.ResearchSectionViewSet)
router.register(r'responsibility-sections', views.ResponsibilitySectionViewSet)
router.register(r'service-sections', views.ServiceSectionViewSet)
router.register(r'company-info', views.CompanyInfoViewSet)
router.register(r'contact-messages', views.ContactMessageViewSet)
router.register(r'news', views.NewsArticleViewSet)

urlpatterns = [
    # 根路径
    path('', root_view, name='root'),

    # 首页数据聚合接口
    path('api/homepage/', views.homepage_data, name='homepage-data'),

    # 搜索相关接口
    path('api/search/', views.search_view, name='search'),
    path('api/sitemap/', views.sitemap_view, name='sitemap'),

    # DRF路由
    path('api/', include(router.urls)),
]
