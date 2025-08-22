from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from datetime import datetime, date
from core.models import (
    HeroSection, VisionSection, ValueItem, ProductCategory, Product,
    AboutSection, ResearchSection, ResponsibilitySection, ServiceSection,
    CompanyInfo, NewsArticle
)


class Command(BaseCommand):
    help = '加载MSD风格的美妆工厂示例数据'

    def handle(self, *args, **options):
        self.stdout.write('开始加载MSD风格示例数据...')

        # 创建管理员用户
        self.create_admin_user()

        # 创建公司信息
        self.create_company_info()

        # 创建首页英雄区域
        self.create_hero_sections()

        # 创建愿景区域
        self.create_vision_section()

        # 创建价值观项目
        self.create_value_items()

        # 创建产品分类和产品
        self.create_products()

        # 创建各个内容区域
        self.create_content_sections()

        # 创建服务项目
        self.create_service_sections()

        # 创建新闻文章
        self.create_news_articles()

        self.stdout.write(self.style.SUCCESS('MSD风格示例数据加载完成！'))

    def create_admin_user(self):
        """创建管理员用户"""
        if not User.objects.filter(username='admin').exists():
            admin_user = User.objects.create_superuser(
                username='admin',
                email='admin@cosmetics-msd.com',
                password='admin123'
            )
            self.stdout.write(f'创建管理员用户: {admin_user.username}')
        else:
            self.stdout.write('管理员用户已存在')

    def create_company_info(self):
        """创建公司信息"""
        company_info, created = CompanyInfo.objects.get_or_create(
            defaults={
                'name': '美妆代工厂',
                'address': '广东省广州市白云区化妆品产业园区A座15层',
                'phone': '400-888-9999',
                'email': 'info@cosmetics-msd.com',
                'website': 'https://www.cosmetics-msd.com',
                'copyright_text': '© 2024 美妆代工厂. 保留所有权利.',
                'icp_number': '粤ICP备12345678号-1',
                'business_license': '91440101123456789X',
                'established_year': 2003,
                'employee_count': 200,
                'factory_area': '15000平方米',
                'annual_capacity': '年产5000万支/瓶',
            }
        )
        self.stdout.write(f"{'创建' if created else '更新'}公司信息")

    def create_hero_sections(self):
        """创建首页英雄区域 - 类似MSD的'见亮行动'"""
        hero_data = [
            {
                'title': '美妆革新',
                'subtitle': '携手中国美妆品牌发展基金会，全国美妆品牌创新委员会开展',
                'description': '致力于推动中国美妆产业的创新发展，为品牌提供专业的ODM/OEM服务',
                'button_text': '了解更多',
                'sort_order': 1,
            },
            {
                'title': '品质制造',
                'subtitle': '20年专业美妆代工经验，服务全球知名品牌',
                'description': '我们拥有国际先进的生产设备和严格的质量管理体系',
                'button_text': '查看产品',
                'sort_order': 2,
            },
            {
                'title': '创新研发',
                'subtitle': '专业研发团队，引领美妆科技前沿',
                'description': '50+专业研发人员，年投入研发资金超过销售额的8%',
                'button_text': '了解研发',
                'sort_order': 3,
            }
        ]

        for data in hero_data:
            hero, created = HeroSection.objects.get_or_create(
                title=data['title'],
                defaults=data
            )
            self.stdout.write(f"{'创建' if created else '更新'}英雄区域: {hero.title}")

    def create_vision_section(self):
        """创建愿景区域"""
        vision, created = VisionSection.objects.get_or_create(
            defaults={
                'title': '我们的愿景',
                'content': '通过我们的创新技术、疫苗以及动物保健产品，改变全世界人们的美丽。我们致力成为最顶尖的研密集型美妆制造公司，并专注于提供领先的创新和解决方案，以满足当今和未来的需求。',
                'subtitle_1': '品质为先',
                'subtitle_2': '尊重他人',
                'subtitle_3': '诚德与诚信',
            }
        )
        self.stdout.write(f"{'创建' if created else '更新'}愿景区域")

    def create_value_items(self):
        """创建价值观项目"""
        values_data = [
            {
                'title': '品质为先',
                'description': '我们的价值观代表了我们品质的内核。价值观指导了我们的每一个决策和行动。',
                'sort_order': 1,
            },
            {
                'title': '尊重他人',
                'description': '我们尊重每一位合作伙伴，重视多元化和包容性的工作环境。',
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
            }
        ]

        for data in values_data:
            value, created = ValueItem.objects.get_or_create(
                title=data['title'],
                defaults=data
            )
            self.stdout.write(f"{'创建' if created else '更新'}价值观: {value.title}")

    def create_products(self):
        """创建产品分类和产品"""
        # 产品分类数据
        categories_data = [
            {
                'name': '护肤品',
                'description': '我们专注于科研创新、探索、开发并提供能让全球数百万人受益的护肤和美妆。',
                'sort_order': 1,
            },
            {
                'name': '彩妆',
                'description': '专业彩妆产品制造，涵盖口红、粉底、眼影等全品类彩妆产品。',
                'sort_order': 2,
            },
            {
                'name': '个人护理',
                'description': '全面的个人护理产品解决方案，包括洗护、身体护理等产品线。',
                'sort_order': 3,
            },
            {
                'name': '功能性美容',
                'description': '具有特殊功效的美容产品，满足不同肌肤需求和美容目标。',
                'sort_order': 4,
            }
        ]

        # 创建产品分类
        for cat_data in categories_data:
            category, created = ProductCategory.objects.get_or_create(
                name=cat_data['name'],
                defaults=cat_data
            )
            self.stdout.write(f"{'创建' if created else '更新'}分类: {category.name}")

        # 创建产品
        skincare_category = ProductCategory.objects.get(name='护肤品')
        makeup_category = ProductCategory.objects.get(name='彩妆')

        products_data = [
            {
                'title': '抗衰老精华液',
                'category': skincare_category,
                'description': '含有专利抗衰老成分的高效精华液，能够深层滋润肌肤，减少细纹和皱纹。',
                'features': '深层补水、抗衰老、提亮肤色、收缩毛孔',
                'specifications': '容量：30ml\n保质期：3年\n适用年龄：25岁以上',
                'ingredients': '透明质酸、胶原蛋白、维生素C、烟酰胺',
                'skin_type': '所有肌肤类型',
                'usage_method': '洁面后取适量均匀涂抹于面部，轻拍至吸收',
                'min_order_quantity': '1000支',
                'production_time': '15-20天',
                'customization_options': '包装定制、配方调整、容量选择',
                'certifications': ['GMPC认证', 'ISO9001认证', 'FDA认证'],
                'quality_standards': ['国际标准', '欧盟标准', 'FDA标准'],
                'is_featured': True,
            },
            {
                'title': '温和洁面乳',
                'category': skincare_category,
                'description': '氨基酸配方的温和洁面乳，有效清洁的同时保持肌肤水油平衡。',
                'features': '温和清洁、保湿不紧绷、氨基酸配方、深层清洁',
                'specifications': '容量：120ml\n保质期：3年\n适用年龄：全年龄段',
                'ingredients': '氨基酸表活、甜菜碱、透明质酸、甘油',
                'skin_type': '敏感肌、干性肌、混合性肌肤',
                'usage_method': '取适量于手心加水起泡，轻柔按摩面部后清水洗净',
                'min_order_quantity': '2000支',
                'production_time': '10-15天',
                'customization_options': '香味定制、包装设计、规格选择',
                'certifications': ['GMPC认证', 'REACH认证'],
                'quality_standards': ['国际标准', '有机认证'],
                'is_featured': True,
            },
            {
                'title': '长效持妆口红',
                'category': makeup_category,
                'description': '创新配方长效持妆口红，丝绒哑光质地，显色度高，持妆时间长达8小时。',
                'features': '长效持妆、丝绒质地、高显色度、不掉色',
                'specifications': '容量：3.5g\n保质期：3年\n色号：20个色号可选',
                'ingredients': '天然蜡质、植物油脂、色素颗粒、维生素E',
                'skin_type': '所有唇部类型',
                'usage_method': '直接涂抹于唇部，可多层叠涂加深颜色',
                'min_order_quantity': '500支',
                'production_time': '20-25天',
                'customization_options': '色号定制、包装设计、香味选择',
                'certifications': ['GMPC认证', 'FDA认证', 'CE认证'],
                'quality_standards': ['国际标准', '欧盟标准'],
                'is_featured': True,
            }
        ]

        for prod_data in products_data:
            product, created = Product.objects.get_or_create(
                title=prod_data['title'],
                defaults=prod_data
            )
            self.stdout.write(f"{'创建' if created else '更新'}产品: {product.title}")

    def create_content_sections(self):
        """创建各个内容区域"""
        # 关于我们区域
        about, created = AboutSection.objects.get_or_create(
            defaults={
                'title': '关于美妆代工厂',
                'subtitle': '我们为更好的未来发明创造。',
                'content': '美妆代工厂是一家专业的化妆品ODM/OEM制造商，拥有20年的行业经验。我们致力于为全球美妆品牌提供高质量的产品制造和研发服务，帮助客户实现品牌价值的最大化。',
            }
        )
        self.stdout.write(f"{'创建' if created else '更新'}关于我们区域")

        # 研发区域
        research, created = ResearchSection.objects.get_or_create(
            defaults={
                'title': '研究与开发',
                'content': '我们直面未来不是逃避全球最难手的美妆挑战。我们的研发团队由50多名专业人员组成，每年投入研发资金超过销售额的8%，确保我们始终走在美妆科技的前沿。',
            }
        )
        self.stdout.write(f"{'创建' if created else '更新'}研发区域")

        # 社会责任区域
        responsibility, created = ResponsibilitySection.objects.get_or_create(
            defaults={
                'title': '我们的社会责任',
                'content': '我们认为社会责任关乎我们的健康，关乎人们和全球社区所受到的社会、环境和经济影响。我们致力于可持续发展，保护环境，创造更美好的未来。',
            }
        )
        self.stdout.write(f"{'创建' if created else '更新'}社会责任区域")

    def create_service_sections(self):
        """创建服务项目"""
        services_data = [
            {
                'title': 'ODM定制开发',
                'description': '从配方研发到包装设计的全流程定制服务，为您打造独特的美妆产品。',
                'features': ['配方研发', '包装设计', '品牌策划', '市场分析'],
                'process_steps': ['需求分析', '配方开发', '样品制作', '包装设计', '批量生产'],
                'sort_order': 1,
            },
            {
                'title': 'OEM代工生产',
                'description': '按照客户提供的配方和包装要求进行专业化生产制造。',
                'features': ['生产制造', '质量检测', '包装服务', '物流配送'],
                'process_steps': ['配方确认', '原料采购', '生产制造', '质量检测', '包装发货'],
                'sort_order': 2,
            },
            {
                'title': '配方研发',
                'description': '专业研发团队提供配方开发和优化服务，确保产品功效和安全性。',
                'features': ['配方设计', '功效测试', '稳定性测试', '安全性评估'],
                'process_steps': ['需求分析', '配方设计', '实验室测试', '配方优化', '最终确认'],
                'sort_order': 3,
            },
            {
                'title': '包装设计',
                'description': '专业设计团队提供包装容器和外观设计，塑造独特的品牌形象。',
                'features': ['容器设计', '标签设计', '包装盒设计', '品牌VI设计'],
                'process_steps': ['设计Brief', '概念设计', '3D建模', '样品制作', '量产确认'],
                'sort_order': 4,
            }
        ]

        for serv_data in services_data:
            service, created = ServiceSection.objects.get_or_create(
                title=serv_data['title'],
                defaults=serv_data
            )
            self.stdout.write(f"{'创建' if created else '更新'}服务: {service.title}")

    def create_news_articles(self):
        """创建新闻文章"""
        admin_user = User.objects.get(username='admin')

        news_data = [
            {
                'title': '公司获得ISO9001质量管理体系认证',
                'content': '经过严格的审核和评估，我公司正式获得ISO9001:2015质量管理体系认证。这一认证标志着我们在质量管理方面达到了国际先进水平，进一步增强了客户对我们产品和服务的信心。\n\nISO9001质量管理体系是国际标准化组织制定的质量管理标准，它要求组织建立完善的质量管理体系，确保产品和服务能够满足客户要求和相关法规要求。\n\n我们将继续坚持质量第一的原则，不断完善质量管理体系，为客户提供更优质的产品和服务。',
                'summary': '我公司通过ISO9001质量管理体系认证，进一步提升了产品质量保证能力',
                'news_type': 'company',
                'is_published': True,
                'is_featured': True,
                'publish_date': datetime.now(),
                'tags': ['质量认证', 'ISO9001', '公司资质'],
            },
            {
                'title': '2024年美妆行业发展趋势分析',
                'content': '随着消费者对美妆产品需求的不断升级，2024年美妆行业呈现出新的发展趋势。根据最新的市场研究报告，以下几个方面值得关注：\n\n1. 个性化定制需求增长：消费者越来越追求个性化的美妆产品，定制化服务成为新的增长点。\n\n2. 天然有机成分受欢迎：消费者对产品成分的关注度提高，天然有机成分的产品更受青睐。\n\n3. 科技与美妆深度融合：AI、AR等技术在美妆行业的应用越来越广泛。\n\n作为专业的美妆代工厂，我们将密切关注这些趋势，不断调整产品策略和服务模式，为客户提供更好的解决方案。',
                'summary': '分析2024年美妆行业的最新发展趋势和市场机遇',
                'news_type': 'industry',
                'is_published': True,
                'is_featured': True,
                'publish_date': datetime.now(),
                'tags': ['行业趋势', '市场分析', '2024年'],
            },
            {
                'title': '参加2024广州国际美博会圆满成功',
                'content': '我公司于2024年3月参加了广州国际美博会，本次展会取得了圆满成功。展会期间，我们展示了最新的产品技术和服务能力，吸引了众多国内外客户的关注。\n\n在为期三天的展会中，我们接待了来自20多个国家和地区的客户，签署了多项合作意向书。特别是我们展示的新一代抗衰老精华液和长效持妆口红，受到了客户的高度评价。\n\n通过本次展会，我们不仅展示了公司的实力，也了解了最新的市场需求和行业动态，为今后的发展方向提供了重要参考。',
                'summary': '公司参加广州国际美博会，获得众多客户关注和好评',
                'news_type': 'exhibition',
                'is_published': True,
                'is_featured': False,
                'publish_date': datetime.now(),
                'tags': ['展会', '美博会', '广州'],
            }
        ]

        for news_item in news_data:
            news, created = NewsArticle.objects.get_or_create(
                title=news_item['title'],
                defaults={
                    **news_item,
                    'author': admin_user,
                }
            )
            self.stdout.write(f"{'创建' if created else '更新'}新闻: {news.title}")

        self.stdout.write(self.style.SUCCESS('所有示例数据创建完成！'))
