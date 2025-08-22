from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from django.utils import timezone
from core.models import (
    HeroSection, VisionSection, ValueItem, Tag, ProductCategory, Product,
    AboutSection, ResearchSection, ResponsibilitySection, ServiceSection,
    CompanyInfo, NewsArticle
)


class Command(BaseCommand):
    help = '加载珠海优美化妆品示例数据 - MSD风格'

    def handle(self, *args, **options):
        self.stdout.write(self.style.SUCCESS('开始加载示例数据...'))

        # 创建标签
        tags_data = [
            {'name': '护肤品', 'slug': 'skincare'},
            {'name': '彩妆', 'slug': 'makeup'},
            {'name': '个人护理', 'slug': 'personal-care'},
            {'name': 'ODM', 'slug': 'odm'},
            {'name': 'OEM', 'slug': 'oem'},
            {'name': '研发', 'slug': 'research'},
        ]

        for tag_data in tags_data:
            tag, created = Tag.objects.get_or_create(
                slug=tag_data['slug'],
                defaults=tag_data
            )
            if created:
                self.stdout.write(f'创建标签: {tag.name}')

        # 创建英雄区域
        hero_data = [
            {
                'title': '美妆之道',
                'subtitle': '珠海优美 · 专业制造二十年筑辰',
                'description': 'Doing something useful and being useful to the world.\n做一些有意义的事，并成为一个对世界有贡献的人。',
                'button_text': '了解更多',
                'button_link': '/about',
                'sort_order': 1,
            }
        ]

        for hero in hero_data:
            obj, created = HeroSection.objects.get_or_create(
                title=hero['title'],
                defaults=hero
            )
            if created:
                self.stdout.write(f'创建英雄区域: {obj.title}')

        # 创建愿景区域
        vision_data = {
            'title': '我们的愿景',
            'content': '通过我们的创新美妆产品，改变全世界人们的生活。我们致力成为最顶尖的研发密集型美妆制药公司，并专注于提供领先的创新和解决方案，以满足当今和未来的需求。',
            'subtitle_1': '患者为先',
            'subtitle_2': '尊重他人',
            'subtitle_3': '诚德与诚信',
        }

        vision, created = VisionSection.objects.get_or_create(
            title=vision_data['title'],
            defaults=vision_data
        )
        if created:
            self.stdout.write(f'创建愿景区域: {vision.title}')

        # 创建价值观项目
        values_data = [
            {
                'title': '患者为先',
                'description': '我们将客户的需求放在首位，为每一位客户提供最优质的美妆产品解决方案。',
                'sort_order': 1,
            },
            {
                'title': '尊重他人',
                'description': '尊重每一位员工和合作伙伴，营造多元化和包容性的工作环境。',
                'sort_order': 2,
            },
            {
                'title': '诚德与诚信',
                'description': '诚实守信是我们业务运营的基础，也是我们与客户建立长期关系的根本。',
                'sort_order': 3,
            },
            {
                'title': '创新和科研卓越',
                'description': '持续的创新和科研投入，确保我们始终走在美妆科技的前沿。',
                'sort_order': 4,
            },
        ]

        for value_data in values_data:
            value, created = ValueItem.objects.get_or_create(
                title=value_data['title'],
                defaults=value_data
            )
            if created:
                self.stdout.write(f'创建价值观项目: {value.title}')

        # 创建产品分类
        categories_data = [
            {
                'name': '护肤品',
                'slug': 'skincare',
                'description': '专业护肤品代工制造，包括面霜、精华、洁面等全系列产品',
                'sort_order': 1,
            },
            {
                'name': '彩妆',
                'slug': 'makeup',
                'description': '彩妆产品ODM/OEM服务，涵盖粉底、口红、眼影等彩妆全品类',
                'sort_order': 2,
            },
            {
                'name': '个人护理',
                'slug': 'personal-care',
                'description': '个人护理用品制造，香水、沐浴露、洗发水等日用化学品',
                'sort_order': 3,
            },
            {
                'name': '功能性美容',
                'slug': 'functional-beauty',
                'description': '功能性美容产品，抗衰老、美白、祛斑等特殊功效产品',
                'sort_order': 4,
            },
        ]

        for cat_data in categories_data:
            category, created = ProductCategory.objects.get_or_create(
                slug=cat_data['slug'],
                defaults=cat_data
            )
            if created:
                self.stdout.write(f'创建产品分类: {category.name}')

        # 创建产品
        skincare_category = ProductCategory.objects.get(slug='skincare')
        makeup_category = ProductCategory.objects.get(slug='makeup')

        products_data = [
            {
                'title': '抗衰老精华液',
                'slug': 'anti-aging-serum',
                'category': skincare_category,
                'description': '采用先进的胜肽技术和透明质酸，有效改善肌肤弹性，减少细纹产生',
                'features': '含有五重胜肽复合物，深层滋润，快速吸收',
                'ingredients': '胜肽复合物、透明质酸、维生素E、神经酰胺',
                'skin_type': '所有肌肤类型',
                'min_order_quantity': '5000瓶',
                'production_time': '30-45天',
                'is_featured': True,
            },
            {
                'title': '水润保湿面霜',
                'slug': 'hydrating-cream',
                'category': skincare_category,
                'description': '24小时长效保湿面霜，深层滋润肌肤，修复受损肌肤屏障',
                'features': '24小时持续保湿，质地轻盈不油腻',
                'ingredients': '透明质酸、角鲨烷、甘油、尿囊素',
                'skin_type': '干性至中性肌肤',
                'min_order_quantity': '3000瓶',
                'production_time': '25-35天',
                'is_featured': True,
            },
            {
                'title': '丝绒哑光唇釉',
                'slug': 'matte-lip-gloss',
                'category': makeup_category,
                'description': '持久不脱色的丝绒哑光唇釉，多种色号可选，质地轻盈舒适',
                'features': '8小时持久不脱色，丝绒质地，颜色饱和',
                'ingredients': '植物蜡、维生素E、玫瑰果油',
                'min_order_quantity': '10000支',
                'production_time': '20-30天',
                'is_featured': True,
            },
        ]

        for prod_data in products_data:
            product, created = Product.objects.get_or_create(
                slug=prod_data['slug'],
                defaults=prod_data
            )
            if created:
                self.stdout.write(f'创建产品: {product.title}')

        # 创建关于我们
        about_data = {
            'title': '关于我们',
            'subtitle': '专业美妆代工制造商',
            'content': '美妆代工厂成立于2003年，是一家专业的化妆品ODM/OEM制造商。我们拥有20年的行业经验和先进的生产设备，为全球美妆品牌提供高质量的产品制造和研发服务。',
            'button_text': '了解更多',
            'button_link': '/about',
        }

        about, created = AboutSection.objects.get_or_create(
            title=about_data['title'],
            defaults=about_data
        )
        if created:
            self.stdout.write(f'创建关于我们: {about.title}')

        # 创建研发区域
        research_data = {
            'title': '研究与开发',
            'content': '我们直面充实而不是逃避全球最棘手的美妆科技挑战。我们的研发团队由50多名专业人员组成，年研发投入占比达到8%，致力于为客户提供最前沿的美妆科技解决方案。',
            'button_text': '了解更多',
            'button_link': '/services',
        }

        research, created = ResearchSection.objects.get_or_create(
            title=research_data['title'],
            defaults=research_data
        )
        if created:
            self.stdout.write(f'创建研发区域: {research.title}')

        # 创建社会责任
        responsibility_data = {
            'title': '我们的社会责任',
            'content': '我们认为社会责任关乎我们的健康，关乎人们和全球社区所受到的社会、环境和经济影响。我们致力于可持续发展，为创建更美好的世界贡献力量。',
            'button_text': '了解更多',
            'button_link': '/about',
        }

        responsibility, created = ResponsibilitySection.objects.get_or_create(
            title=responsibility_data['title'],
            defaults=responsibility_data
        )
        if created:
            self.stdout.write(f'创建社会责任: {responsibility.title}')

        # 创建服务项目
        services_data = [
            {
                'title': 'ODM定制服务',
                'slug': 'odm-service',
                'description': '原创设计制造服务，从配方研发到包装设计的全流程定制',
                'detailed_description': '我们提供完整的ODM解决方案，包括产品概念开发、配方研究、包装设计、生产制造等全流程服务。',
                'features': ['配方创新', '包装设计', '品牌定制', '质量保证'],
                'process_steps': ['需求分析', '方案设计', '样品制作', '批量生产'],
                'sort_order': 1,
            },
            {
                'title': 'OEM代工服务',
                'slug': 'oem-service',
                'description': '专业代工制造服务，严格按照客户要求进行生产',
                'detailed_description': '基于客户提供的配方和规格，我们提供专业的OEM代工制造服务，确保产品质量稳定可靠。',
                'features': ['严格质控', '按时交付', '成本优化', '规模生产'],
                'process_steps': ['订单确认', '原料采购', '生产制造', '质量检验'],
                'sort_order': 2,
            },
        ]

        for service_data in services_data:
            service, created = ServiceSection.objects.get_or_create(
                slug=service_data['slug'],
                defaults=service_data
            )
            if created:
                self.stdout.write(f'创建服务项目: {service.title}')

        # 创建公司信息
        company_data = {
            'name': '珠海优美化妆品有限公司',
            'address': '广东省珠海市高新区科技三路1号',
            'phone': '13727893557',
            'email': '785981881@qq.com',
            'copyright_text': '© 2024 珠海优美化妆品有限公司. 保留所有权利.',
            'icp_number': '粤ICP备2024001234号',
            'business_license': '粤珠工商备案2024001234号',
            'established_year': 2003,
            'employee_count': 200,
            'factory_area': '15000平方米',
            'annual_capacity': '5000万支/瓶',
        }

        company, created = CompanyInfo.objects.get_or_create(
            name=company_data['name'],
            defaults=company_data
        )
        if created:
            self.stdout.write(f'创建公司信息: {company.name}')

        # 创建新闻文章
        admin_user = User.objects.get(username='admin')
        news_data = [
            {
                'title': '公司荣获"年度最佳美妆代工企业"称号',
                'slug': 'best-cosmetics-manufacturer-award',
                'summary': '美妆代工厂凭借优异的产品质量和服务水平，荣获行业协会颁发的"年度最佳美妆代工企业"称号。',
                'content': '在刚刚结束的化妆品行业年会上，美妆代工厂凭借其在产品质量、技术创新、服务水平等方面的突出表现，荣获了"年度最佳美妆代工企业"称号。这一荣誉的获得，是对公司20年来专注美妆代工制造的充分肯定。',
                'news_type': 'company',
                'author': admin_user,
                'is_published': True,
                'is_featured': True,
                'publish_date': timezone.now(),
            },
            {
                'title': '新工厂投产，年产能提升至5000万支',
                'slug': 'new-factory-production',
                'summary': '公司新建的现代化生产工厂正式投产，年产能从3000万支提升至5000万支，为客户提供更强大的生产保障。',
                'content': '经过两年的筹备建设，公司位于广州白云区的新生产工厂正式投产。新工厂采用国际先进的自动化生产线，配备10万级洁净车间，年产能达到5000万支/瓶，将为客户提供更加稳定可靠的生产保障。',
                'news_type': 'company',
                'author': admin_user,
                'is_published': True,
                'is_featured': True,
                'publish_date': timezone.now(),
            },
        ]

        for news in news_data:
            article, created = NewsArticle.objects.get_or_create(
                slug=news['slug'],
                defaults=news
            )
            if created:
                self.stdout.write(f'创建新闻: {article.title}')

        self.stdout.write(self.style.SUCCESS('示例数据加载完成！'))
        self.stdout.write(self.style.SUCCESS('管理员账号: admin / admin123'))
        self.stdout.write(self.style.SUCCESS('后端服务: http://localhost:8000'))
        self.stdout.write(self.style.SUCCESS('管理后台: http://localhost:8000/admin'))
