# 📄 用户协议和隐私政策使用说明

## ✅ 已生成的文档

我已为《星辰魔法师》生成了完整的用户协议和隐私政策，中英文各一份：

### 中文文档
1. **Terms-of-Service-Chinese.md** - 用户服务协议（简体中文）
2. **Privacy-Policy-Chinese.md** - 隐私政策（简体中文）

### 英文文档
3. **Terms-of-Service-English.md** - Terms of Service (English)
4. **Privacy-Policy-English.md** - Privacy Policy (English)

---

## 📋 文档内容概览

### 用户协议包含：
1. ✅ 服务内容和范围
2. ✅ 账号使用规则
3. ✅ 知识产权声明
4. ✅ 免责条款
5. ✅ 用户数据和隐私
6. ✅ 服务变更条款
7. ✅ 未成年人保护
8. ✅ 协议修改规则
9. ✅ 法律适用和争议解决
10. ✅ 联系方式

### 隐私政策包含：
1. ✅ 信息收集说明（最小化原则）
2. ✅ 信息使用目的
3. ✅ 信息存储方式（本地存储）
4. ✅ 信息分享规则（不分享承诺）
5. ✅ 第三方服务说明（目前无）
6. ✅ 用户权利说明
7. ✅ 未成年人保护
8. ✅ 数据安全措施
9. ✅ 隐私承诺
10. ✅ 联系方式

---

## 🔧 使用方法

### 1. App Store 上架配置

在提交应用到App Store时，需要提供隐私政策和用户协议的URL链接。

#### 方式一：托管到网站（推荐）

**步骤：**
1. 将Markdown文档转换为HTML格式
2. 上传到您的网站服务器
3. 在App Store Connect中填写URL

**URL示例：**
```
中文隐私政策: https://www.你的域名.com/privacy-zh.html
英文隐私政策: https://www.你的域名.com/privacy-en.html
中文用户协议: https://www.你的域名.com/terms-zh.html
英文用户协议: https://www.你的域名.com/terms-en.html
```

#### 方式二：使用GitHub Pages（免费）

**步骤：**
1. 在GitHub创建仓库
2. 上传这些文档
3. 启用GitHub Pages
4. 使用生成的URL

**示例：**
```
https://你的用户名.github.io/gxstargame/privacy-zh.html
https://你的用户名.github.io/gxstargame/privacy-en.html
```

#### 方式三：使用第三方托管平台

可以使用：
- Notion（转为公开页面）
- Google Drive（设为公开分享）
- 其他文档托管平台

### 2. 应用内展示

**建议在应用中添加：**
1. 设置页面中的"用户协议"和"隐私政策"入口
2. 首次启动时的同意弹窗
3. 登录/注册时的协议确认

**示例代码：**
```swift
// 在设置页面添加按钮
let privacyButton = UIButton()
privacyButton.setTitle("隐私政策", for: .normal)
privacyButton.addTarget(self, action: #selector(showPrivacyPolicy), for: .touchUpInside)

@objc func showPrivacyPolicy() {
    let url = URL(string: "https://www.你的域名.com/privacy-zh.html")!
    UIApplication.shared.open(url)
}
```

### 3. App Store Connect 配置

**在App Store Connect中：**

1. **App 隐私**部分：
   - 点击"管理"
   - 填写数据收集详情
   - 添加隐私政策URL

2. **App 信息**部分：
   - 隐私政策URL（必填）
   - 用户协议URL（可选但推荐）

---

## ⚠️ 重要提示

### 必须修改的内容

在发布前，请务必修改以下信息：

#### 1. 联系方式
将文档中的联系方式改为您的实际信息：
```markdown
- 电子邮箱：support@gxstargame.com  👈 改为你的邮箱
- 电子邮箱：privacy@gxstargame.com  👈 改为你的邮箱
```

#### 2. 开发者信息
确认开发者名称是否需要修改：
```markdown
- 开发者：GX Team  👈 如需修改请改为你的团队名
```

#### 3. 生效日期
根据实际发布时间修改：
```markdown
生效日期：2025年10月12日  👈 改为实际日期
```

### 可选修改的内容

#### 1. 添加更多功能说明
如果将来添加了新功能（如云同步、社交分享等），需要更新：
- 用户协议的"服务内容"部分
- 隐私政策的"信息收集"部分

#### 2. 添加第三方服务
如果集成了第三方SDK，需要在隐私政策中说明：
- SDK名称
- 收集的信息类型
- 使用目的
- 第三方隐私政策链接

#### 3. 支持URL
如果有官方网站或客服页面，可以添加：
```markdown
- 官方网站：https://www.你的域名.com
- 在线客服：https://support.你的域名.com
```

---

## 📝 Markdown 转 HTML

### 方法一：使用在线工具

推荐工具：
1. **Markdown to HTML** - https://markdowntohtml.com/
2. **Dillinger** - https://dillinger.io/
3. **StackEdit** - https://stackedit.io/

### 方法二：使用命令行工具

安装pandoc：
```bash
brew install pandoc
```

转换命令：
```bash
pandoc Terms-of-Service-Chinese.md -o terms-zh.html
pandoc Terms-of-Service-English.md -o terms-en.html
pandoc Privacy-Policy-Chinese.md -o privacy-zh.html
pandoc Privacy-Policy-English.md -o privacy-en.html
```

### 方法三：使用Python脚本

```python
import markdown

with open('Terms-of-Service-Chinese.md', 'r', encoding='utf-8') as f:
    text = f.read()
    html = markdown.markdown(text)
    
with open('terms-zh.html', 'w', encoding='utf-8') as f:
    f.write(html)
```

---

## 🌐 多语言配置

### App Store Connect 中的语言配置

1. **中文简体**：
   - 隐私政策URL：上传中文版本URL
   - 截图：使用中文界面

2. **英语**：
   - 隐私政策URL：上传英文版本URL
   - 截图：使用英文界面

### 应用内根据语言自动跳转

```swift
func getPrivacyPolicyURL() -> URL {
    let language = Locale.preferredLanguages.first ?? "en"
    
    if language.hasPrefix("zh") {
        return URL(string: "https://www.你的域名.com/privacy-zh.html")!
    } else {
        return URL(string: "https://www.你的域名.com/privacy-en.html")!
    }
}
```

---

## ✅ 上架前检查清单

在提交App Store审核前，请确认：

### 文档方面
- [ ] 已修改所有联系方式为真实信息
- [ ] 已确认开发者名称正确
- [ ] 已更新生效日期
- [ ] 已转换为HTML格式（如需要）
- [ ] 已上传到可访问的网站
- [ ] 已测试URL可正常访问
- [ ] 中英文版本都已准备

### App Store Connect
- [ ] 已在"App 隐私"中填写数据收集信息
- [ ] 已填写隐私政策URL（必填）
- [ ] 已添加用户协议URL（推荐）
- [ ] 中英文版本分别配置URL

### 应用内
- [ ] 已在设置页面添加协议入口（可选）
- [ ] 已添加首次启动同意弹窗（可选）

---

## 📊 隐私政策要点说明

### 我们的应用特点
根据当前应用实际情况，我们在隐私政策中明确说明：

#### ✅ 我们承诺
- 仅本地存储数据，不上传服务器
- 不收集任何个人身份信息
- 不使用任何第三方SDK
- 不投放广告
- 不分享用户数据

#### 📊 实际收集的数据
- 游戏分数（本地存储）
- 语言偏好（本地存储）
- 匿名设备信息（用于兼容性）
- 崩溃日志（用于修复bug）

这些都已在隐私政策中详细说明。

---

## 🔍 常见问题

### Q1: 必须要有隐私政策吗？
A: 是的，App Store要求所有应用都必须提供隐私政策URL。

### Q2: 用户协议是必须的吗？
A: 不是必须的，但强烈推荐，可以保护开发者权益。

### Q3: 隐私政策必须是网页形式吗？
A: 是的，必须提供一个可访问的URL，不能是PDF或应用内文本。

### Q4: 可以中英文用同一个URL吗？
A: 可以，但最好根据用户语言提供对应版本，提升用户体验。

### Q5: 需要律师审核吗？
A: 如果是商业应用或有复杂的数据处理，建议咨询律师。我们提供的是标准模板。

### Q6: 集成广告后需要更新吗？
A: 是的，任何数据收集变化都需要更新隐私政策并通知用户。

---

## 📧 下一步

1. **修改文档**中的联系方式等信息
2. **转换为HTML**格式
3. **上传到网站**获得URL
4. **在App Store Connect**中配置
5. **（可选）在应用内**添加协议入口

---

## 📞 需要帮助？

如果您在使用这些文档时遇到问题，可以：

1. 查阅Apple官方文档：
   - [App Store审核指南](https://developer.apple.com/app-store/review/guidelines/)
   - [隐私要求](https://developer.apple.com/app-store/user-privacy-and-data-use/)

2. 咨询专业人士：
   - 法律顾问（复杂情况）
   - App Store审核专家

---

**祝您的应用顺利上架！** 🚀

---

_文档说明版本：v1.0_  
_创建日期：2025年10月12日_

