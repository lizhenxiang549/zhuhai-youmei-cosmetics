# GitHub推送指南 📚

按照以下步骤将珠海优美化妆品官网项目推送到GitHub。

## 🚀 推送步骤

### 1. 初始化Git仓库并提交代码

```bash
# 进入项目目录
cd msd-style-cosmetics/frontend

# 初始化git仓库（如果还没有初始化）
git init

# 将默认分支设为main
git branch -M main

# 添加所有文件到暂存区
git add .

# 创建初始提交
git commit -m "🎉 Initial commit: 珠海优美化妆品官网

✨ 功能特色:
- Vue 3 + TypeScript + Vite 现代化技术栈
- 娇兰风格黑白主题设计
- 响应式布局，完美适配各种设备
- 导航栏黑色下滑线交互效果
- 产品展示、企业介绍、联系我们等完整模块

🎨 设计亮点:
- 高端奢华的黑白配色方案
- 精致的动画过渡效果
- 优雅的用户交互体验

🌐 部署地址: https://same-f4dqy73vop0-latest.netlify.app

🤖 Generated with [Same](https://same.new)

Co-Authored-By: Same <noreply@same.new>"
```

### 2. 在GitHub创建新仓库

1. 访问 [GitHub](https://github.com)
2. 点击右上角的 "+" 号，选择 "New repository"
3. 填写仓库信息：
   - **Repository name**: `zhuhai-youmei-website` 或 `msd-cosmetics-website`
   - **Description**: `珠海优美化妆品官网 - Vue 3 + TypeScript + Vite`
   - **Privacy**: 选择 Public 或 Private
   - **不要勾选** "Add a README file"（我们已经有了）
4. 点击 "Create repository"

### 3. 连接本地仓库到GitHub

```bash
# 添加远程仓库地址（替换为你的GitHub用户名和仓库名）
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY_NAME.git

# 例如：
# git remote add origin https://github.com/yourusername/zhuhai-youmei-website.git

# 验证远程仓库设置
git remote -v
```

### 4. 推送代码到GitHub

```bash
# 首次推送到main分支
git push -u origin main
```

如果遇到权限问题，可能需要使用Personal Access Token：

1. 前往 GitHub Settings > Developer settings > Personal access tokens
2. 生成新的token，选择 `repo` 权限
3. 使用token作为密码进行认证

## 🔄 后续更新流程

每次修改代码后：

```bash
# 查看修改状态
git status

# 添加修改的文件
git add .

# 提交修改
git commit -m "描述你的修改内容"

# 推送到GitHub
git push origin main
```

## 📝 提交信息规范

建议使用以下格式：

```bash
# 新功能
git commit -m "✨ feat: 添加产品详情页面"

# 修复bug
git commit -m "🐛 fix: 修复导航栏在移动端的显示问题"

# 样式更新
git commit -m "💄 style: 优化首页Hero区域的视觉效果"

# 文档更新
git commit -m "📝 docs: 更新部署指南"

# 性能优化
git commit -m "⚡ perf: 优化图片加载性能"

# 重构代码
git commit -m "♻️ refactor: 重构产品组件结构"
```

## 🌐 自动部署设置

### Netlify自动部署

1. 登录 [Netlify](https://netlify.com)
2. 点击 "New site from Git"
3. 选择 GitHub 并授权
4. 选择你的仓库
5. 配置构建设置：
   - **Build command**: `bun run build`
   - **Publish directory**: `dist`
6. 点击 "Deploy site"

每次推送到main分支时，Netlify会自动重新部署。

### Vercel自动部署

1. 登录 [Vercel](https://vercel.com)
2. 点击 "New Project"
3. 导入GitHub仓库
4. Vercel会自动检测Vite项目配置
5. 点击 "Deploy"

## 🔧 常见问题解决

### 权限问题
```bash
# 如果推送时提示权限错误，配置Git用户信息
git config --global user.name "你的GitHub用户名"
git config --global user.email "你的GitHub邮箱"

# 使用SSH密钥（推荐）
ssh-keygen -t rsa -b 4096 -C "你的邮箱"
# 将公钥添加到GitHub Settings > SSH and GPG keys
```

### 大文件问题
```bash
# 如果有大文件需要使用Git LFS
git lfs install
git lfs track "*.zip"
git lfs track "*.tar.gz"
git add .gitattributes
```

### 强制推送（谨慎使用）
```bash
# 如果需要强制推送（会覆盖远程历史）
git push -f origin main
```

## 📊 仓库设置建议

### 分支保护
在GitHub仓库设置中：
1. Settings > Branches
2. 添加规则保护main分支
3. 启用 "Require pull request reviews"

### 问题模板
创建 `.github/ISSUE_TEMPLATE/` 目录，添加问题模板。

### 自动化工作流
创建 `.github/workflows/` 目录，添加GitHub Actions配置。

---

🎉 **推送完成！** 你的项目现在已经在GitHub上了，可以与团队协作或进行自动化部署。
