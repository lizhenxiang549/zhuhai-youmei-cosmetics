#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from core.models import *
import json


class Command(BaseCommand):
    help = '加载珠海优美化妆品代工厂测试数据'

    def handle(self, *args, **options):
        self.stdout.write(self.style.SUCCESS('开始加载珠海优美化妆品代工厂数据...'))

        # 创建产品分类
        self.create_categories()

        # 创建产品
        self.create_products()

        # 创建首页Hero区域
        self.create_hero_sections()

        # 创建公司信息
        self.create_company_info()

        # 创建标签
        self.create_tags()

        # 创建服务项目
        self.create_services()

        self.stdout.write(self.style.SUCCESS('数据加载完成！'))

    def create_categories(self):
        """创建产品分类"""
        categories_data = [
            {
                'name': '香水',
                'slug': 'perfume',
                'description': '专业香水代工生产，从配方研发到包装设计的全方位服务',
                'sort_order': 1
            },
            {
                'name': '彩妆',
                'slug': 'makeup',
                'description': '彩妆产品ODM/OEM，包括口红、粉底、眼影等全系列产品',
                'sort_order': 2
            },
            {
                'name': '护肤',
                'slug': 'skincare',
                'description': '护肤品代工制造，提供面霜、精华、洁面等全系列产品',
                'sort_order': 3
            },
            {
                'name': '个护用品',
                'slug': 'personal-care',
                'description': '个人护理用品代工，包括洗发水、沐浴露、牙膏等',
                'sort_order': 4
            }
        ]

        for data in categories_data:
            category, created = ProductCategory.objects.get_or_create(
                name=data['name'],
                defaults=data
            )
            if created:
                self.stdout.write(f'创建分类: {category.name}')

    def create_products(self):
        """创建产品"""
        # 获取分类
        perfume_cat = ProductCategory.objects.get(name='香水')
        makeup_cat = ProductCategory.objects.get(name='彩妆')
        skincare_cat = ProductCategory.objects.get(name='护肤')

        products_data = [
            # 香水产品
            {
                'title': '蜜颜奢养香水',
                'slug': 'luxury-honey-perfume',
                'category': perfume_cat,
                'description': '采用天然蜂蜜精华调配，散发清雅蜜香，持久留香8-12小时',
                'features': '天然蜂蜜精华\n法式调香工艺\n持久留香\n优雅包装',
                'ingredients': '香精、酒精、蜂蜜精华、天然植物萃取',
                'min_order_quantity': '500瓶',
                'production_time': '15-20个工作日',
                'is_featured': True,
                'sort_order': 1
            },
            {
                'title': '璀璨金辉男士香水',
                'slug': 'golden-men-perfume',
                'category': perfume_cat,
                'description': '专为现代男士打造的经典香调，彰显成熟魅力',
                'features': '木质香调\n成熟男性气息\n商务场合适用\n精致包装',
                'ingredients': '香精、酒精、檀香精油、雪松精华',
                'min_order_quantity': '300瓶',
                'production_time': '15-20个工作日',
                'is_featured': True,
                'sort_order': 2
            },

            # 彩妆产品
            {
                'title': '雪兰莳金芯口红',
                'slug': 'golden-core-lipstick',
                'category': makeup_cat,
                'description': '丝滑质地，显色持久，多色可选，完美贴合唇部',
                'features': '丝滑质地\n高显色度\n持久不脱色\n多色可选',
                'ingredients': '蜂蜡、植物油脂、天然色素、维生素E',
                'min_order_quantity': '1000支',
                'production_time': '10-15个工作日',
                'is_featured': True,
                'sort_order': 3
            },
            {
                'title': '皇室蜂蜜粉底液',
                'slug': 'royal-honey-foundation',
                'category': makeup_cat,
                'description': '蜂蜜成分滋润保湿，完美遮瑕，自然妆感',
                'features': '蜂蜜滋润\n完美遮瑕\n自然妆感\n持久不脱妆',
                'ingredients': '蜂蜜精华、矿物质粉末、保湿因子',
                'min_order_quantity': '500瓶',
                'production_time': '10-15个工作日',
                'is_featured': True,
                'sort_order': 4
            },

            # 护肤产品
            {
                'title': '黄金蜜缘面霜',
                'slug': 'golden-honey-cream',
                'category': skincare_cat,
                'description': '富含黄金微粒和蜂蜜精华，深度滋养肌肤，重现年轻光彩',
                'features': '黄金微粒\n蜂蜜精华\n深度滋养\n抗衰老',
                'ingredients': '黄金微粒、蜂蜜精华、透明质酸、胶原蛋白',
                'skin_type': '所有肌肤类型',
                'min_order_quantity': '300瓶',
                'production_time': '20-25个工作日',
                'is_featured': True,
                'sort_order': 5
            },
            {
                'title': '宫廷蜜语精华液',
                'slug': 'palace-honey-serum',
                'category': skincare_cat,
                'description': '古法蜂蜜发酵工艺，深层修护，改善肌肤纹理',
                'features': '古法发酵\n深层修护\n改善纹理\n提亮肌肤',
                'ingredients': '发酵蜂蜜、烟酰胺、维生素C、植物精华',
                'skin_type': '敏感肌肤、干性肌肤',
                'min_order_quantity': '500瓶',
                'production_time': '25-30个工作日',
                'is_featured': True,
                'sort_order': 6
            }
        ]

        for data in products_data:
            product, created = Product.objects.get_or_create(
                title=data['title'],
                defaults=data
            )
            if created:
                self.stdout.write(f'创建产品: {product.title}')

    def create_hero_sections(self):
        """创建首页Hero区域"""
        hero_data = [
            {
                'title': '慕心沉礼. 蜜爱永系',
                'subtitle': '珠海优美现蜜意',
                'description': '专业美妆代工制造商，拥有20年行业经验，为全球知名品牌提供ODM/OEM服务',
                'button_text': '探索产品',
                'button_link': '/products',
                'sort_order': 1
            }
        ]

        for data in hero_data:
            hero, created = HeroSection.objects.get_or_create(
                title=data['title'],
                defaults=data
            )
            if created:
                self.stdout.write(f'创建Hero区域: {hero.title}')

    def create_company_info(self):
        """创建公司信息"""
        company_data = {
            'name': '珠海优美化妆品有限公司',
            'address': '广东省珠海市香洲区工业园区优美大道88号',
            'phone': '+86-756-8888888',
            'email': 'info@zhuhai-youmei.com',
            'website': 'https://www.zhuhai-youmei.com',
            'copyright_text': '© 2024 珠海优美化妆品有限公司. 保留所有权利.',
            'icp_number': '粤ICP备2024000001号',
            'business_license': '914404001234567890',
            'established_year': 2004,
            'employee_count': 500,
            'factory_area': '50000平方米',
            'annual_capacity': '2000万件'
        }

        company, created = CompanyInfo.objects.get_or_create(
            name=company_data['name'],
            defaults=company_data
        )
        if created:
            self.stdout.write(f'创建公司信息: {company.name}')

    def create_tags(self):
        """创建标签"""
        tags_data = [
            {'name': '蜂蜜系列', 'slug': 'honey-series'},
            {'name': '天然成分', 'slug': 'natural-ingredients'},
            {'name': '抗衰老', 'slug': 'anti-aging'},
            {'name': '保湿', 'slug': 'moisturizing'},
            {'name': '美白', 'slug': 'whitening'},
            {'name': '敏感肌', 'slug': 'sensitive-skin'},
            {'name': '持久', 'slug': 'long-lasting'},
            {'name': '奢华', 'slug': 'luxury'}
        ]

        for data in tags_data:
            tag, created = Tag.objects.get_or_create(
                name=data['name'],
                defaults=data
            )
            if created:
                self.stdout.write(f'创建标签: {tag.name}')

    def create_services(self):
        """创建服务项目"""
        services_data = [
            {
                'title': 'ODM全程定制',
                'slug': 'odm-customization',
                'description': '从配方研发到包装设计的全程定制服务',
                'detailed_description': '我们提供从产品概念到市场投放的全流程ODM服务，包括配方研发、包装设计、生产制造、质量检测等环节。',
                'features': ['配方研发', '包装设计', '生产制造', '质量检测', '法规咨询'],
                'process_steps': ['需求分析', '配方研发', '样品制作', '包装设计', '试产验证', '批量生产'],
                'sort_order': 1
            },
            {
                'title': 'OEM代工生产',
                'slug': 'oem-manufacturing',
                'description': '专业的OEM代工生产服务，严格的质量控制体系',
                'detailed_description': '基于您的配方和设计，我们提供专业的OEM代工生产服务，确保产品质量和交付时间。',
                'features': ['专业生产线', '质量保证', '准时交付', '灵活产能', '成本优化'],
                'process_steps': ['配方确认', '生产排期', '原料采购', '生产制造', '质量检测', '包装发货'],
                'sort_order': 2
            },
            {
                'title': '配方研发',
                'slug': 'formula-development',
                'description': '专业配方师团队，创新产品配方研发',
                'detailed_description': '拥有专业的配方研发团队和先进的实验设备，为客户开发创新、安全、有效的产品配方。',
                'features': ['专业团队', '创新配方', '安全有效', '快速响应', '保密协议'],
                'process_steps': ['需求沟通', '配方设计', '实验验证', '样品制作', '效果测试', '配方优化'],
                'sort_order': 3
            },
            {
                'title': '包装设计',
                'slug': 'packaging-design',
                'description': '创意包装设计，提升产品市场竞争力',
                'detailed_description': '专业的包装设计团队，结合市场趋势和品牌定位，为产品打造具有竞争力的包装方案。',
                'features': ['创意设计', '品牌定位', '市场导向', '环保材料', '成本控制'],
                'process_steps': ['品牌调研', '设计概念', '方案制作', '客户确认', '工程制图', '样品制作'],
                'sort_order': 4
            }
        ]

        for data in services_data:
            service, created = ServiceSection.objects.get_or_create(
                title=data['title'],
                defaults=data
            )
            if created:
                self.stdout.write(f'创建服务: {service.title}')
