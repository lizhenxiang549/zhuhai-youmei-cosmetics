from django.db import models
from django.contrib.auth.models import User
from django.utils.translation import gettext_lazy as _
from django.utils import timezone


class Tag(models.Model):
    """标签模型"""
    name = models.CharField(_('标签名称'), max_length=50)
    slug = models.SlugField(_('URL别名'), max_length=50, unique=True)
    description = models.TextField(_('描述'), blank=True)
    is_active = models.BooleanField(_('是否激活'), default=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)

    class Meta:
        verbose_name = _('标签')
        verbose_name_plural = _('标签')
        ordering = ['name']

    def __str__(self):
        return self.name


class HeroSection(models.Model):
    """首页英雄区域 - 类似MSD的'疫苗之父'"""
    title = models.CharField(_('标题'), max_length=200)
    subtitle = models.TextField(_('副标题'))
    description = models.TextField(_('描述'), blank=True)
    image = models.ImageField(_('背景图片'), upload_to='hero/', blank=True, null=True)
    button_text = models.CharField(_('按钮文字'), max_length=50, default='了解更多')
    button_link = models.CharField(_('按钮链接'), max_length=200, blank=True)
    is_active = models.BooleanField(_('是否激活'), default=True)
    sort_order = models.IntegerField(_('排序'), default=0)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)

    class Meta:
        verbose_name = _('首页英雄区域')
        verbose_name_plural = _('首页英雄区域')
        ordering = ['sort_order', '-created_at']

    def __str__(self):
        return self.title


class VisionSection(models.Model):
    """愿景区域 - 类似MSD的'我们的愿景'"""
    title = models.CharField(_('标题'), max_length=200, default='我们的愿景')
    content = models.TextField(_('内容'))
    subtitle_1 = models.CharField(_('子标题1'), max_length=200)
    subtitle_2 = models.CharField(_('子标题2'), max_length=200)
    subtitle_3 = models.CharField(_('子标题3'), max_length=200)
    is_active = models.BooleanField(_('是否激活'), default=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)

    class Meta:
        verbose_name = _('愿景区域')
        verbose_name_plural = _('愿景区域')

    def __str__(self):
        return self.title


class ValueItem(models.Model):
    """价值观项目 - 类似MSD的价值观列表"""
    title = models.CharField(_('标题'), max_length=100)
    description = models.TextField(_('描述'), blank=True)
    icon = models.CharField(_('图标类名'), max_length=100, blank=True)
    sort_order = models.IntegerField(_('排序'), default=0)
    is_active = models.BooleanField(_('是否激活'), default=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)

    class Meta:
        verbose_name = _('价值观项目')
        verbose_name_plural = _('价值观项目')
        ordering = ['sort_order', 'title']

    def __str__(self):
        return self.title


class ProductCategory(models.Model):
    """产品分类 - 类似MSD的产品分类"""
    name = models.CharField(_('分类名称'), max_length=100)
    slug = models.SlugField(_('URL别名'), max_length=100, unique=True)
    description = models.TextField(_('分类描述'))
    image = models.ImageField(_('分类图片'), upload_to='categories/', blank=True, null=True)
    icon = models.CharField(_('图标类名'), max_length=100, blank=True)
    sort_order = models.IntegerField(_('排序'), default=0)
    is_active = models.BooleanField(_('是否激活'), default=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)

    class Meta:
        verbose_name = _('产品分类')
        verbose_name_plural = _('产品分类')
        ordering = ['sort_order', 'name']

    def __str__(self):
        return self.name


class Product(models.Model):
    """产品详情"""
    title = models.CharField(_('产品名称'), max_length=200)
    slug = models.SlugField(_('URL别名'), max_length=200, unique=True)
    category = models.ForeignKey(ProductCategory, on_delete=models.CASCADE, verbose_name=_('分类'))
    description = models.TextField(_('产品描述'))
    features = models.TextField(_('产品特点'), blank=True)
    specifications = models.TextField(_('产品规格'), blank=True)
    main_image = models.ImageField(_('主图'), upload_to='products/', blank=True, null=True)
    gallery_images = models.JSONField(_('产品图库'), default=list, blank=True)

    # 美妆工厂特有字段
    ingredients = models.TextField(_('主要成分'), blank=True)
    skin_type = models.CharField(_('适用肌肤'), max_length=200, blank=True)
    usage_method = models.TextField(_('使用方法'), blank=True)
    min_order_quantity = models.CharField(_('最小起订量'), max_length=100, blank=True)
    production_time = models.CharField(_('生产周期'), max_length=100, blank=True)
    customization_options = models.TextField(_('定制选项'), blank=True)

    # 认证和质量
    certifications = models.JSONField(_('认证证书'), default=list, blank=True)
    quality_standards = models.JSONField(_('质量标准'), default=list, blank=True)

    # 标签和状态
    tags = models.ManyToManyField(Tag, blank=True, verbose_name=_('标签'))
    is_featured = models.BooleanField(_('是否推荐'), default=False)
    is_active = models.BooleanField(_('是否激活'), default=True)
    sort_order = models.IntegerField(_('排序'), default=0)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)

    class Meta:
        verbose_name = _('产品')
        verbose_name_plural = _('产品')
        ordering = ['-is_featured', 'sort_order', '-created_at']

    def __str__(self):
        return self.title


class AboutSection(models.Model):
    """关于我们区域 - 类似MSD的'关于默沙东'"""
    title = models.CharField(_('标题'), max_length=200, default='关于我们')
    subtitle = models.CharField(_('副标题'), max_length=500)
    content = models.TextField(_('内容'))
    image = models.ImageField(_('配图'), upload_to='about/', blank=True, null=True)
    button_text = models.CharField(_('按钮文字'), max_length=50, default='更多')
    button_link = models.CharField(_('按钮链接'), max_length=200, blank=True)
    is_active = models.BooleanField(_('是否激活'), default=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)

    class Meta:
        verbose_name = _('关于我们区域')
        verbose_name_plural = _('关于我们区域')

    def __str__(self):
        return self.title


class ResearchSection(models.Model):
    """研发区域 - 类似MSD的'研究与开发'"""
    title = models.CharField(_('标题'), max_length=200, default='研究与开发')
    content = models.TextField(_('内容'))
    image = models.ImageField(_('配图'), upload_to='research/', blank=True, null=True)
    button_text = models.CharField(_('按钮文字'), max_length=50, default='更多')
    button_link = models.CharField(_('按钮链接'), max_length=200, blank=True)
    is_active = models.BooleanField(_('是否激活'), default=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)

    class Meta:
        verbose_name = _('研发区域')
        verbose_name_plural = _('研发区域')

    def __str__(self):
        return self.title


class ResponsibilitySection(models.Model):
    """社会责任区域 - 类似MSD的'我们的社会责任'"""
    title = models.CharField(_('标题'), max_length=200, default='我们的社会责任')
    content = models.TextField(_('内容'))
    image = models.ImageField(_('配图'), upload_to='responsibility/', blank=True, null=True)
    button_text = models.CharField(_('按钮文字'), max_length=50, default='更多')
    button_link = models.CharField(_('按钮链接'), max_length=200, blank=True)
    is_active = models.BooleanField(_('是否激活'), default=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)

    class Meta:
        verbose_name = _('社会责任区域')
        verbose_name_plural = _('社会责任区域')

    def __str__(self):
        return self.title


class ServiceSection(models.Model):
    """服务项目 - ODM/OEM服务"""
    title = models.CharField(_('服务名称'), max_length=200)
    slug = models.SlugField(_('URL别名'), max_length=200, unique=True)
    description = models.TextField(_('服务描述'))
    detailed_description = models.TextField(_('详细描述'), blank=True)
    features = models.JSONField(_('服务特点'), default=list, blank=True)
    process_steps = models.JSONField(_('服务流程'), default=list, blank=True)
    icon = models.CharField(_('图标类名'), max_length=100, blank=True)
    image = models.ImageField(_('服务图片'), upload_to='services/', blank=True, null=True)
    tags = models.ManyToManyField(Tag, blank=True, verbose_name=_('标签'))
    related_products = models.ManyToManyField(Product, blank=True, verbose_name=_('相关产品'))
    sort_order = models.IntegerField(_('排序'), default=0)
    is_active = models.BooleanField(_('是否激活'), default=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)

    class Meta:
        verbose_name = _('服务项目')
        verbose_name_plural = _('服务项目')
        ordering = ['sort_order', 'title']

    def __str__(self):
        return self.title


class CompanyInfo(models.Model):
    """公司基本信息"""
    name = models.CharField(_('公司名称'), max_length=200, default='美妆代工厂')
    logo = models.ImageField(_('公司Logo'), upload_to='company/', blank=True, null=True)

    # 联系信息
    address = models.TextField(_('公司地址'))
    phone = models.CharField(_('联系电话'), max_length=100)
    email = models.EmailField(_('联系邮箱'))
    website = models.URLField(_('公司网站'), blank=True)

    # 法律信息
    copyright_text = models.CharField(_('版权信息'), max_length=500)
    icp_number = models.CharField(_('ICP备案号'), max_length=100, blank=True)
    business_license = models.CharField(_('工商备案号'), max_length=100, blank=True)

    # 统计数据
    established_year = models.IntegerField(_('成立年份'), blank=True, null=True)
    employee_count = models.IntegerField(_('员工数量'), blank=True, null=True)
    factory_area = models.CharField(_('厂房面积'), max_length=100, blank=True)
    annual_capacity = models.CharField(_('年产能'), max_length=100, blank=True)

    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)

    class Meta:
        verbose_name = _('公司信息')
        verbose_name_plural = _('公司信息')

    def __str__(self):
        return self.name


class ContactMessage(models.Model):
    """联系表单消息"""
    INQUIRY_TYPES = [
        ('general', _('一般咨询')),
        ('quotation', _('产品询价')),
        ('odm', _('ODM定制')),
        ('oem', _('OEM代工')),
        ('partnership', _('合作洽谈')),
        ('technical', _('技术支持')),
    ]

    name = models.CharField(_('姓名'), max_length=100)
    email = models.EmailField(_('邮箱'))
    phone = models.CharField(_('电话'), max_length=20, blank=True)
    company = models.CharField(_('公司名称'), max_length=100, blank=True)
    position = models.CharField(_('职位'), max_length=100, blank=True)
    inquiry_type = models.CharField(_('咨询类型'), max_length=20, choices=INQUIRY_TYPES, default='general')
    subject = models.CharField(_('主题'), max_length=200)
    message = models.TextField(_('留言内容'))
    product_interest = models.CharField(_('感兴趣的产品'), max_length=200, blank=True)
    order_quantity = models.CharField(_('预计订购量'), max_length=100, blank=True)

    is_read = models.BooleanField(_('是否已读'), default=False)
    is_replied = models.BooleanField(_('是否已回复'), default=False)
    reply_content = models.TextField(_('回复内容'), blank=True)
    reply_date = models.DateTimeField(_('回复时间'), blank=True, null=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)

    class Meta:
        verbose_name = _('联系消息')
        verbose_name_plural = _('联系消息')
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.name} - {self.subject}"


class NewsArticle(models.Model):
    """新闻文章"""
    NEWS_TYPES = [
        ('company', _('公司新闻')),
        ('industry', _('行业资讯')),
        ('technology', _('技术创新')),
        ('exhibition', _('展会活动')),
    ]

    title = models.CharField(_('文章标题'), max_length=200)
    slug = models.SlugField(_('URL别名'), max_length=200, unique=True)
    content = models.TextField(_('文章内容'))
    summary = models.TextField(_('文章摘要'), max_length=500, blank=True)
    news_type = models.CharField(_('新闻类型'), max_length=20, choices=NEWS_TYPES, default='company')
    featured_image = models.ImageField(_('特色图片'), upload_to='news/', blank=True, null=True)
    author = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name=_('作者'))
    tags = models.ManyToManyField(Tag, blank=True, verbose_name=_('标签'))
    is_published = models.BooleanField(_('是否发布'), default=False)
    is_featured = models.BooleanField(_('是否推荐'), default=False)
    publish_date = models.DateTimeField(_('发布时间'), blank=True, null=True)
    read_count = models.IntegerField(_('阅读次数'), default=0)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)

    class Meta:
        verbose_name = _('新闻文章')
        verbose_name_plural = _('新闻文章')
        ordering = ['-publish_date', '-created_at']

    def __str__(self):
        return self.title


class UserStory(models.Model):
    """用户故事/案例研究"""
    STORY_TYPES = [
        ('case_study', _('案例研究')),
        ('success_story', _('成功故事')),
        ('testimonial', _('客户见证')),
        ('partnership', _('合作伙伴')),
    ]

    title = models.CharField(_('标题'), max_length=200)
    slug = models.SlugField(_('URL别名'), max_length=200, unique=True)
    story_type = models.CharField(_('故事类型'), max_length=20, choices=STORY_TYPES, default='case_study')
    customer_name = models.CharField(_('客户姓名'), max_length=100, blank=True)
    company_name = models.CharField(_('公司名称'), max_length=200, blank=True)
    industry = models.CharField(_('行业'), max_length=100, blank=True)
    summary = models.TextField(_('摘要'), max_length=500)
    content = models.TextField(_('详细内容'))
    featured_image = models.ImageField(_('特色图片'), upload_to='user_stories/', blank=True, null=True)
    tags = models.ManyToManyField(Tag, blank=True, verbose_name=_('标签'))
    related_products = models.ManyToManyField(Product, blank=True, verbose_name=_('相关产品'))
    is_published = models.BooleanField(_('是否发布'), default=False)
    is_featured = models.BooleanField(_('是否推荐'), default=False)
    publish_date = models.DateTimeField(_('发布时间'), blank=True, null=True)
    sort_order = models.IntegerField(_('排序'), default=0)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)

    class Meta:
        verbose_name = _('用户故事')
        verbose_name_plural = _('用户故事')
        ordering = ['-is_featured', 'sort_order', '-publish_date']

    def __str__(self):
        return self.title


class StaticPage(models.Model):
    """静态页面"""
    PAGE_TYPES = [
        ('policy', _('政策页面')),
        ('legal', _('法律页面')),
        ('help', _('帮助页面')),
        ('other', _('其他页面')),
    ]

    title = models.CharField(_('页面标题'), max_length=200)
    slug = models.SlugField(_('URL别名'), max_length=200, unique=True)
    content = models.TextField(_('页面内容'))
    page_type = models.CharField(_('页面类型'), max_length=20, choices=PAGE_TYPES, default='other')
    meta_description = models.CharField(_('SEO描述'), max_length=200, blank=True)
    show_in_footer = models.BooleanField(_('在页脚显示'), default=False)
    show_in_sitemap = models.BooleanField(_('在站点地图显示'), default=True)
    is_active = models.BooleanField(_('是否激活'), default=True)
    sort_order = models.IntegerField(_('排序'), default=0)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)

    class Meta:
        verbose_name = _('静态页面')
        verbose_name_plural = _('静态页面')
        ordering = ['sort_order', 'title']

    def __str__(self):
        return self.title


class SearchLog(models.Model):
    """搜索日志"""
    query = models.CharField(_('搜索关键词'), max_length=200)
    results_count = models.IntegerField(_('结果数量'), default=0)
    ip_address = models.GenericIPAddressField(_('IP地址'), blank=True, null=True)
    user_agent = models.TextField(_('用户代理'), blank=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)

    class Meta:
        verbose_name = _('搜索日志')
        verbose_name_plural = _('搜索日志')
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.query} ({self.results_count} 结果)"
