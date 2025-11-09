# 📱 App Store 截图制作指南

## 📋 App Store 截图要求

### 必需尺寸

#### iPhone
| 设备类型 | 尺寸 (像素) | 设备示例 | 是否必需 |
|---------|-----------|---------|---------|
| 6.7" Display | 1290 x 2796 | iPhone 14 Pro Max, 15 Pro Max | ✅ 必需 |
| 6.5" Display | 1242 x 2688 | iPhone 11 Pro Max, XS Max | ✅ 必需 |
| 5.5" Display | 1242 x 2208 | iPhone 8 Plus, 7 Plus | ✅ 推荐 |

#### iPad (可选)
| 设备类型 | 尺寸 (像素) | 设备示例 |
|---------|-----------|---------|
| 12.9" iPad Pro | 2048 x 2732 | iPad Pro 12.9" |
| 11" iPad Pro | 1668 x 2388 | iPad Pro 11" |

### 截图数量
- **最少**: 每个尺寸至少 1 张
- **最多**: 每个尺寸最多 10 张
- **推荐**: 3-5 张最佳

---

## 🎨 星辰魔法师 - 建议截图内容

### 截图 1: 游戏主界面（封面图）
**重点展示：**
- 完整的游戏界面
- 精美的紫色渐变背景
- 清晰的宝石布局
- 分数面板
- 游戏标题

**特点：**
- 这是用户第一眼看到的，要最吸引人
- 展示游戏的整体美感

### 截图 2: 游戏进行中
**重点展示：**
- 选中宝石的状态（放大效果）
- 可消除的宝石匹配
- 较高的分数（如：150分）
- 动态的游戏氛围

**特点：**
- 展示游戏的互动性
- 让用户了解玩法

### 截图 3: 消除动画瞬间
**重点展示：**
- 宝石消除的特效
- 匹配的宝石高亮
- 分数增加
- 动态效果

**特点：**
- 展示游戏的动画流畅度
- 体现游戏的趣味性

### 截图 4: 高分展示
**重点展示：**
- 较高的分数（如：500分以上）
- 几乎满屏的宝石
- 复杂的宝石布局
- 游戏深度

**特点：**
- 展示游戏的挑战性
- 激发用户的竞争心理

### 截图 5: 游戏结束界面
**重点展示：**
- 游戏结束对话框
- 最终分数
- 重新开始选项
- 完整的游戏循环

**特点：**
- 展示游戏的完整性
- 显示游戏有结束和重玩机制

---

## 📸 截图制作方法

### 方法一：使用 Xcode 模拟器（推荐）

#### 步骤：

1. **打开项目**
   ```bash
   open GXStarGame.xcodeproj
   ```

2. **选择合适的模拟器**
   - iPhone 14 Pro Max (6.7")
   - iPhone 11 Pro Max (6.5")
   - iPhone 8 Plus (5.5")

3. **运行应用**
   - 点击运行按钮（⌘R）
   - 等待应用启动

4. **准备截图场景**
   - 调整到合适的游戏状态
   - 确保界面美观

5. **截图**
   - 方式1：Xcode菜单 → Debug → Take Screenshot
   - 方式2：模拟器菜单 → File → New Screen Shot (⌘S)
   - 方式3：使用 `xcrun simctl io booted screenshot screenshot.png`

6. **保存位置**
   - 截图自动保存到桌面
   - 或使用命令行指定保存位置

---

### 方法二：使用真机截图（最佳质量）

#### 步骤：

1. **连接设备**
   - 使用数据线连接iPhone到Mac

2. **运行应用**
   - 在Xcode中选择真机设备
   - 点击运行

3. **截图**
   - iPhone X及以上：同时按下**侧边按钮 + 音量增加键**
   - iPhone 8及以下：同时按下**Home键 + 电源键**

4. **导出截图**
   - 方式1：AirDrop传到Mac
   - 方式2：使用"照片"应用同步
   - 方式3：使用Image Capture应用导入

---

### 方法三：使用命令行批量截图

创建截图脚本：

```bash
#!/bin/bash
# screenshot.sh - 自动截图脚本

# 设置模拟器
SIMULATOR="iPhone 14 Pro Max"

# 启动模拟器
xcrun simctl boot "$SIMULATOR" 2>/dev/null

# 等待模拟器启动
sleep 3

# 运行应用（需要先build）
# xcodebuild -scheme GXStarGame -destination "platform=iOS Simulator,name=$SIMULATOR"

# 等待应用启动
sleep 5

# 截图1 - 主界面
xcrun simctl io booted screenshot ~/Desktop/screenshot-1-home.png

# 你可以在这里添加自动化操作，然后截更多图
# 比如使用 UI Testing 来模拟点击

echo "截图完成！保存在桌面"
```

---

## 🎨 截图美化建议

### 添加设备边框

使用在线工具添加iPhone边框，让截图更专业：

**推荐工具：**
1. **Mockup Generator** - https://mockuper.net/
2. **Previewed** - https://previewed.app/
3. **App Store Screenshot Generator** - https://www.appstorescreenshot.com/
4. **Devices by Facebook** - https://facebook.design/devices

**使用步骤：**
1. 上传纯截图
2. 选择设备型号
3. 下载带边框的图片

### 添加文字说明

在截图上添加简短说明，突出功能：

**中文截图文字建议：**
- 截图1：「精美的游戏界面」
- 截图2：「简单易学的玩法」
- 截图3：「流畅的消除动画」
- 截图4：「挑战高分记录」
- 截图5：「无限游戏乐趣」

**英文截图文字建议：**
- Screenshot 1: "Beautiful Game Interface"
- Screenshot 2: "Easy to Learn Gameplay"
- Screenshot 3: "Smooth Match Animations"
- Screenshot 4: "Challenge High Scores"
- Screenshot 5: "Endless Gaming Fun"

**推荐设计工具：**
- Figma（免费）
- Canva（部分免费）
- Adobe Photoshop
- Sketch（Mac专用）

---

## 📱 快速截图指南

### 使用我们提供的截图模板

我已经为你创建了一个截图辅助工具，可以快速生成不同状态的游戏界面。

**使用方法：**

1. 在Xcode中运行应用
2. 选择对应的模拟器尺寸
3. 玩游戏到需要的状态
4. 使用模拟器截图（⌘S）
5. 重复以上步骤获取不同状态的截图

---

## 📐 截图尺寸对照表

### 直接使用模拟器截图

| 模拟器设备 | 截图尺寸 | 缩放比例 | 用途 |
|-----------|---------|---------|------|
| iPhone 14 Pro Max | 1290 x 2796 | @3x | 6.7" Display |
| iPhone 11 Pro Max | 1242 x 2688 | @3x | 6.5" Display |
| iPhone 8 Plus | 1242 x 2208 | @3x | 5.5" Display |

### 如果尺寸不对，需要调整

使用以下工具调整尺寸：
- **sips** (macOS命令行工具)
- **Preview** (macOS自带)
- **ImageMagick**
- **在线工具**: https://www.iloveimg.com/resize-image

---

## 🔧 截图处理脚本

### 批量调整尺寸

```bash
#!/bin/bash
# resize-screenshots.sh

# 调整到6.5"尺寸
sips -z 2688 1242 screenshot-1.png --out screenshot-1-6.5.png
sips -z 2688 1242 screenshot-2.png --out screenshot-2-6.5.png
sips -z 2688 1242 screenshot-3.png --out screenshot-3-6.5.png

# 调整到5.5"尺寸
sips -z 2208 1242 screenshot-1.png --out screenshot-1-5.5.png
sips -z 2208 1242 screenshot-2.png --out screenshot-2-5.5.png
sips -z 2208 1242 screenshot-3.png --out screenshot-3-5.5.png

echo "尺寸调整完成！"
```

---

## 📝 截图文件命名建议

### 命名规范

```
游戏名_设备尺寸_语言_序号.png
```

**示例：**
```
StarMatch_6.5_zh_01.png  (中文，6.5英寸，第1张)
StarMatch_6.5_zh_02.png
StarMatch_6.5_zh_03.png

StarMatch_6.5_en_01.png  (英文，6.5英寸，第1张)
StarMatch_6.5_en_02.png
StarMatch_6.5_en_03.png
```

---

## ✅ 截图检查清单

提交前确认：

### 技术要求
- [ ] 尺寸正确（至少两种必需尺寸）
- [ ] 格式为PNG或JPG
- [ ] 文件大小不超过500MB
- [ ] 分辨率符合要求
- [ ] 截图清晰无模糊

### 内容要求
- [ ] 不包含非游戏内容
- [ ] 没有Android或其他平台UI元素
- [ ] 没有透明背景或边框（除非设计需要）
- [ ] 界面完整，没有被截断
- [ ] 文字清晰可读

### 质量要求
- [ ] 展示了游戏核心玩法
- [ ] 画面美观吸引人
- [ ] 展示了游戏特色
- [ ] 中英文分别准备
- [ ] 顺序合理，有逻辑性

---

## 🎯 上传到App Store Connect

### 步骤：

1. **登录App Store Connect**
   - https://appstoreconnect.apple.com

2. **选择你的应用**
   - 我的App → 星辰魔法师

3. **准备提交**
   - 1.0 准备提交

4. **上传截图**
   - 6.5" Display → 点击"+"添加图片
   - 按顺序上传3-5张截图
   - 重复为其他尺寸上传

5. **本地化**
   - 中文简体：上传中文界面截图
   - 英语：上传英文界面截图

6. **预览**
   - 检查顺序
   - 确认显示正确

7. **保存**
   - 点击右上角"保存"

---

## 💡 专业建议

### 1. 突出游戏特色
- 紫色渐变背景很漂亮，要充分展示
- 宝石的3D效果要清晰
- 玻璃态UI设计是亮点

### 2. 展示核心玩法
- 第一张图一定要最吸引人
- 要让用户一眼看懂怎么玩
- 展示游戏的趣味性

### 3. 保持一致性
- 所有截图使用相同语言
- 保持相似的分数范围（除非展示进度）
- 界面元素完整显示

### 4. 避免常见错误
- ❌ 截图太暗或太亮
- ❌ 包含调试信息
- ❌ 游戏状态混乱
- ❌ 界面元素被遮挡
- ❌ 尺寸不符合要求

---

## 🎨 设计模板（可选）

如果想要更专业的效果，可以使用设计模板：

### Figma模板
1. 搜索"App Store Screenshot Template"
2. 选择iPhone尺寸模板
3. 导入游戏截图
4. 添加文字和装饰
5. 导出PNG

### 在线工具
- **AppLaunchpad** - https://theapplaunchpad.com/
- **Scr截图美化** - https://screenshots.pro/

---

## 📞 需要帮助？

如果在制作截图过程中遇到问题：

📧 **技术支持**: 279694479@qq.com

---

**祝你的应用顺利通过审核！** 🎉📱

---

_截图指南版本：v1.0_  
_最后更新：2025年10月12日_


