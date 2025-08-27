<template>
  <div class="contact-page">
    <!-- 导航栏 -->
    <AppHeader />

    <!-- 页面标题区域 -->
    <section class="page-hero">
      <div class="container">
        <div class="hero-content">
          <h1 class="page-title">联系我们</h1>
          <p class="page-subtitle">
            联系我们获取专业的美妆产品解决方案，我们将为您提供最优质的服务
          </p>
        </div>
      </div>
    </section>

    <!-- 联系方式和表单 -->
    <section class="contact-content">
      <div class="container">
        <div class="contact-layout">
          <!-- 联系信息 -->
          <div class="contact-info">
            <h2 class="section-title">联系方式</h2>
            <p class="section-subtitle">
              我们的专业团队随时为您提供咨询和支持服务
            </p>

            <div class="info-list">
              <div class="info-item">
                <div class="info-icon">
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <path d="M21 10C21 17 12 23 12 23C12 23 3 17 3 10C3 7.61305 3.94821 5.32387 5.63604 3.63604C7.32387 1.94821 9.61305 1 12 1C14.3869 1 16.6761 1.94821 18.3639 3.63604C20.0518 5.32387 21 7.61305 21 10Z" stroke="currentColor" stroke-width="2"/>
                    <circle cx="12" cy="10" r="3" stroke="currentColor" stroke-width="2"/>
                  </svg>
                </div>
                <div class="info-content">
                  <h3 class="info-title">公司地址</h3>
                  <p class="info-text">广东省广州市白云区化妆品产业园区A座15层</p>
                </div>
              </div>

              <div class="info-item">
                <div class="info-icon">
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <path d="M22 16.92V19.92C22 20.4728 21.5523 20.9205 21 20.9205H3C2.44772 20.9205 2 20.4728 2 19.92V16.92C2 16.3672 2.44772 15.9195 3 15.9195H21C21.5523 15.9195 22 16.3672 22 16.92Z" stroke="currentColor" stroke-width="2"/>
                    <path d="M2 16.92L12 8.92L22 16.92" stroke="currentColor" stroke-width="2"/>
                  </svg>
                </div>
                <div class="info-content">
                  <h3 class="info-title">邮箱地址</h3>
                  <p class="info-text">info@cosmetics-msd.com</p>
                </div>
              </div>

              <div class="info-item">
                <div class="info-icon">
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <path d="M22 16.92V19.92C22.0011 20.1985 21.9441 20.4742 21.8325 20.7293C21.7209 20.9845 21.5573 21.2136 21.3521 21.4019C21.1468 21.5901 20.9046 21.7335 20.6407 21.8227C20.3769 21.9119 20.0974 21.9451 19.82 21.92C16.7428 21.5856 13.787 20.5341 11.19 18.85C8.77382 17.3147 6.72533 15.2662 5.19 12.85C3.49998 10.2412 2.44818 7.27099 2.12 4.18C2.095 3.90347 2.12787 3.62476 2.2165 3.36162C2.30513 3.09849 2.44756 2.85669 2.63421 2.65162C2.82086 2.44655 3.04816 2.28271 3.30207 2.17052C3.55599 2.05833 3.83056 2.00026 4.11 2H7.11C7.59531 1.99522 8.06579 2.16708 8.43376 2.48353C8.80173 2.79999 9.04207 3.23945 9.11 3.72C9.23662 4.68007 9.47144 5.62273 9.81 6.53C9.94454 6.88792 9.9736 7.27691 9.89384 7.65088C9.81408 8.02485 9.6288 8.36811 9.36 8.64L8.09 9.91C9.51355 12.4135 11.5865 14.4864 14.09 15.91L15.36 14.64C15.6319 14.3712 15.9751 14.1859 16.3491 14.1062C16.7231 14.0264 17.1121 14.0555 17.47 14.19C18.3773 14.5286 19.3199 14.7634 20.28 14.89C20.7658 14.9585 21.2094 15.2032 21.5265 15.5775C21.8437 15.9518 22.0122 16.4296 22 16.92Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </div>
                <div class="info-content">
                  <h3 class="info-title">联系电话</h3>
                  <p class="info-text">400-888-9999</p>
                </div>
              </div>

              <div class="info-item">
                <div class="info-icon">
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
                    <path d="M12 6V12L16 14" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </div>
                <div class="info-content">
                  <h3 class="info-title">工作时间</h3>
                  <p class="info-text">周一至周五 9:00-18:00</p>
                </div>
              </div>
            </div>

            <!-- 业务类型 -->
            <div class="business-types">
              <h3 class="business-title">主要业务</h3>
              <div class="business-grid">
                <div class="business-item">
                  <div class="business-icon">ODM</div>
                  <span class="business-name">原创设计制造</span>
                </div>
                <div class="business-item">
                  <div class="business-icon">OEM</div>
                  <span class="business-name">代工生产</span>
                </div>
                <div class="business-item">
                  <div class="business-icon">R&D</div>
                  <span class="business-name">配方研发</span>
                </div>
                <div class="business-item">
                  <div class="business-icon">QC</div>
                  <span class="business-name">质量控制</span>
                </div>
              </div>
            </div>
          </div>

          <!-- 联系表单 -->
          <div class="contact-form">
            <h2 class="form-title">发送咨询</h2>
            <p class="form-subtitle">请填写以下信息，我们将尽快回复您</p>

            <form @submit.prevent="submitForm" class="form">
              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">姓名 *</label>
                  <input
                    v-model="formData.name"
                    type="text"
                    class="form-input"
                    placeholder="请输入您的姓名"
                    required
                  />
                </div>
                <div class="form-group">
                  <label class="form-label">邮箱 *</label>
                  <input
                    v-model="formData.email"
                    type="email"
                    class="form-input"
                    placeholder="请输入您的邮箱"
                    required
                  />
                </div>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">电话</label>
                  <input
                    v-model="formData.phone"
                    type="tel"
                    class="form-input"
                    placeholder="请输入您的电话"
                  />
                </div>
                <div class="form-group">
                  <label class="form-label">公司名称</label>
                  <input
                    v-model="formData.company"
                    type="text"
                    class="form-input"
                    placeholder="请输入公司名称"
                  />
                </div>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">职位</label>
                  <input
                    v-model="formData.position"
                    type="text"
                    class="form-input"
                    placeholder="请输入您的职位"
                  />
                </div>
                <div class="form-group">
                  <label class="form-label">咨询类型 *</label>
                  <select
                    v-model="formData.inquiry_type"
                    class="form-select"
                    required
                  >
                    <option value="">请选择咨询类型</option>
                    <option value="general">一般咨询</option>
                    <option value="quotation">产品询价</option>
                    <option value="odm">ODM定制</option>
                    <option value="oem">OEM代工</option>
                    <option value="partnership">合作洽谈</option>
                    <option value="technical">技术支持</option>
                  </select>
                </div>
              </div>

              <div class="form-group">
                <label class="form-label">主题 *</label>
                <input
                  v-model="formData.subject"
                  type="text"
                  class="form-input"
                  placeholder="请输入咨询主题"
                  required
                />
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">感兴趣的产品</label>
                  <input
                    v-model="formData.product_interest"
                    type="text"
                    class="form-input"
                    placeholder="请输入您感兴趣的产品"
                  />
                </div>
                <div class="form-group">
                  <label class="form-label">预计订购量</label>
                  <input
                    v-model="formData.order_quantity"
                    type="text"
                    class="form-input"
                    placeholder="请输入预计订购量"
                  />
                </div>
              </div>

              <div class="form-group">
                <label class="form-label">留言内容 *</label>
                <textarea
                  v-model="formData.message"
                  class="form-textarea"
                  rows="5"
                  placeholder="请详细描述您的需求和问题..."
                  required
                ></textarea>
              </div>

              <div class="form-actions">
                <button
                  type="submit"
                  :disabled="submitting"
                  class="btn btn-primary btn-submit"
                >
                  <span v-if="submitting" class="loading-spinner"></span>
                  {{ submitting ? '提交中...' : '发送咨询' }}
                </button>
              </div>
            </form>

            <!-- 提交状态 -->
            <div v-if="submitMessage" :class="['submit-message', submitStatus]">
              {{ submitMessage }}
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 页脚 -->
    <AppFooter />
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { apiService } from '@/utils/api'
import type { ContactMessage } from '@/types'

// 组件导入
import AppHeader from '@/components/AppHeader.vue'
import AppFooter from '@/components/AppFooter.vue'

// 响应式状态
const submitting = ref(false)
const submitMessage = ref('')
const submitStatus = ref('')

const formData = reactive<ContactMessage>({
  name: '',
  email: '',
  phone: '',
  company: '',
  position: '',
  inquiry_type: 'general',
  subject: '',
  message: '',
  product_interest: '',
  order_quantity: '',
})

// 提交表单
const submitForm = async () => {
  submitting.value = true
  submitMessage.value = ''
  submitStatus.value = ''

  try {
    const response = await apiService.submitContactMessage(formData)

    if (response.success) {
      submitMessage.value = response.message || '消息发送成功！我们会尽快联系您。'
      submitStatus.value = 'success'

      // 重置表单
      Object.assign(formData, {
        name: '',
        email: '',
        phone: '',
        company: '',
        position: '',
        inquiry_type: 'general',
        subject: '',
        message: '',
        product_interest: '',
        order_quantity: '',
      })
    } else {
      submitMessage.value = '提交失败，请稍后重试。'
      submitStatus.value = 'error'
    }
  } catch (error) {
    console.error('Submit form error:', error)
    submitMessage.value = '提交失败，请检查网络连接后重试。'
    submitStatus.value = 'error'
  } finally {
    submitting.value = false

    // 3秒后清除提示信息
    setTimeout(() => {
      submitMessage.value = ''
      submitStatus.value = ''
    }, 3000)
  }
}
</script>

<style scoped>
.contact-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

/* 页面标题区域 */
.page-hero {
  padding: 120px 0 80px;
  background: linear-gradient(135deg, #000000 0%, #2a2a2a 50%, #000000 100%);
  color: white;
  margin-top: 90px;
  position: relative;
}

.page-hero::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background:
    radial-gradient(circle at 20% 30%, rgba(255,255,255,0.3) 2%, transparent 3%),
    radial-gradient(circle at 80% 70%, rgba(255,255,255,0.2) 1%, transparent 2%),
    radial-gradient(circle at 60% 20%, rgba(255,255,255,0.1) 3%, transparent 4%);
  background-size: 100px 100px, 150px 150px, 80px 80px;
}

.hero-content {
  text-align: center;
  position: relative;
  z-index: 1;
}

.page-title {
  font-size: 48px;
  font-weight: 300;
  margin-bottom: 24px;
  line-height: 1.2;
}

.page-subtitle {
  font-size: 20px;
  opacity: 0.9;
  max-width: 600px;
  margin: 0 auto;
  line-height: 1.5;
}

/* 联系内容区域 */
.contact-content {
  padding: 120px 0;
  background: var(--gray-bg);
  flex: 1;
}

.contact-layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 80px;
  align-items: flex-start;
}

/* 联系信息 */
.contact-info {
  background: white;
  padding: 48px;
  border-radius: 16px;
  box-shadow: var(--shadow-sm);
}

.section-title {
  font-size: 32px;
  font-weight: 400;
  color: var(--text-primary);
  margin-bottom: 16px;
}

.section-subtitle {
  font-size: 16px;
  color: var(--text-secondary);
  margin-bottom: 40px;
  line-height: 1.5;
}

.info-list {
  margin-bottom: 40px;
}

.info-item {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  margin-bottom: 32px;
}

.info-icon {
  flex-shrink: 0;
  width: 48px;
  height: 48px;
  border-radius: 12px;
  background: var(--primary-color);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
}

.info-content {
  flex: 1;
}

.info-title {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 8px;
}

.info-text {
  font-size: 14px;
  color: var(--text-secondary);
  line-height: 1.5;
  margin: 0;
}

/* 业务类型 */
.business-types {
  padding-top: 32px;
  border-top: 1px solid var(--border-color);
}

.business-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 24px;
}

.business-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.business-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px;
  background: var(--gray-bg);
  border-radius: 8px;
  transition: all 0.3s ease;
}

.business-item:hover {
  background: var(--primary-color);
  color: white;
}

.business-icon {
  width: 32px;
  height: 32px;
  border-radius: 6px;
  background: var(--primary-color);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 10px;
  font-weight: 600;
}

.business-item:hover .business-icon {
  background: rgba(255, 255, 255, 0.2);
}

.business-name {
  font-size: 12px;
  font-weight: 500;
}

/* 联系表单 */
.contact-form {
  background: white;
  padding: 48px;
  border-radius: 16px;
  box-shadow: var(--shadow-sm);
}

.form-title {
  font-size: 32px;
  font-weight: 400;
  color: var(--text-primary);
  margin-bottom: 16px;
}

.form-subtitle {
  font-size: 16px;
  color: var(--text-secondary);
  margin-bottom: 32px;
  line-height: 1.5;
}

.form {
  margin-bottom: 24px;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  margin-bottom: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
}

.form-label {
  font-size: 14px;
  font-weight: 500;
  color: var(--text-primary);
  margin-bottom: 8px;
}

.form-input,
.form-select,
.form-textarea {
  padding: 12px 16px;
  border: 2px solid var(--border-color);
  border-radius: 8px;
  font-size: 14px;
  background: white;
  color: var(--text-primary);
  transition: border-color 0.3s ease;
}

.form-input:focus,
.form-select:focus,
.form-textarea:focus {
  outline: none;
  border-color: var(--primary-color);
}

.form-textarea {
  resize: vertical;
  min-height: 120px;
  line-height: 1.5;
}

.form-actions {
  margin-top: 32px;
}

.btn-submit {
  width: 100%;
  padding: 16px;
  font-size: 16px;
  font-weight: 500;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.btn-submit:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.loading-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top: 2px solid white;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* 提交状态 */
.submit-message {
  padding: 16px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  text-align: center;
}

.submit-message.success {
  background: #d4edda;
  color: #155724;
  border: 1px solid #c3e6cb;
}

.submit-message.error {
  background: #f8d7da;
  color: #721c24;
  border: 1px solid #f5c6cb;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .page-title {
    font-size: 40px;
  }

  .contact-layout {
    gap: 60px;
  }

  .contact-info,
  .contact-form {
    padding: 40px;
  }

  .form-row {
    gap: 16px;
  }
}

@media (max-width: 768px) {
  .page-hero {
    padding: 100px 0 60px;
  }

  .page-title {
    font-size: 32px;
  }

  .contact-content {
    padding: 80px 0;
  }

  .contact-layout {
    grid-template-columns: 1fr;
    gap: 40px;
  }

  .contact-info,
  .contact-form {
    padding: 32px;
  }

  .form-row {
    grid-template-columns: 1fr;
    gap: 0;
  }

  .business-grid {
    grid-template-columns: 1fr;
  }

  .section-title,
  .form-title {
    font-size: 28px;
  }
}

@media (max-width: 480px) {
  .page-title {
    font-size: 28px;
  }

  .contact-info,
  .contact-form {
    padding: 24px;
  }

  .section-title,
  .form-title {
    font-size: 24px;
  }

  .info-item {
    margin-bottom: 24px;
  }

  .info-icon {
    width: 40px;
    height: 40px;
  }
}
</style>
