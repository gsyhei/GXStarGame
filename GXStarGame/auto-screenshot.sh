#!/bin/bash

# 自动截图辅助脚本
echo "📸 iPhone截图辅助工具"
echo "===================="
echo ""

# 创建截图目录
SCREENSHOT_DIR="$HOME/Desktop/GXStarGame-Screenshots"
mkdir -p "$SCREENSHOT_DIR"

# 检查模拟器
SIMULATOR_NAME="iPhone 15 Pro Max"
SIMULATOR_ID=$(xcrun simctl list devices | grep "$SIMULATOR_NAME" | grep -v "unavailable" | head -1 | grep -oE '\([A-Z0-9-]+\)' | tr -d '()')

if [ -z "$SIMULATOR_ID" ]; then
    echo "❌ 找不到 $SIMULATOR_NAME 模拟器"
    exit 1
fi

echo "📱 使用模拟器: $SIMULATOR_NAME"
echo "📁 截图保存到: $SCREENSHOT_DIR"
echo ""

# 启动模拟器
echo "🚀 启动模拟器..."
xcrun simctl boot "$SIMULATOR_ID" 2>/dev/null
sleep 2

# 打开模拟器窗口
open -a Simulator
sleep 3

echo ""
echo "✅ 模拟器已启动"
echo ""
echo "📋 接下来的步骤："
echo ""
echo "1️⃣ 在Xcode中选择 iPhone 15 Pro Max"
echo "2️⃣ 点击运行按钮 ▶️"
echo "3️⃣ 等待应用启动"
echo ""
read -p "应用启动后，按回车继续..."

echo ""
echo "📸 开始截图流程"
echo "==============="
echo ""

# 截图1 - 主菜单
echo "📸 截图 1/5: 主菜单"
echo "   应该显示：跳动的宝石图标 + 开始游戏按钮 + 设置按钮"
read -p "   准备好后按回车截图..."
xcrun simctl io booted screenshot "$SCREENSHOT_DIR/01-menu.png"
echo "   ✅ 已保存: 01-menu.png"
sleep 1

# 截图2 - 游戏开始
echo ""
echo "📸 截图 2/5: 游戏初始界面"
echo "   请点击'开始游戏'，进入游戏界面"
echo "   不要点击任何宝石，保持初始状态"
read -p "   准备好后按回车截图..."
xcrun simctl io booted screenshot "$SCREENSHOT_DIR/02-game-start.png"
echo "   ✅ 已保存: 02-game-start.png"
sleep 1

# 截图3 - 选中状态
echo ""
echo "📸 截图 3/5: 宝石选中状态"
echo "   请点击任意一个宝石，让它保持选中（放大）状态"
read -p "   准备好后按回车截图..."
xcrun simctl io booted screenshot "$SCREENSHOT_DIR/03-selected.png"
echo "   ✅ 已保存: 03-selected.png"
sleep 1

# 截图4 - 游戏中
echo ""
echo "📸 截图 4/5: 游戏进行中（高分）"
echo "   请玩游戏一会儿，让分数达到200分以上"
echo "   建议：多消除几次，展示游戏性"
read -p "   准备好后按回车截图..."
xcrun simctl io booted screenshot "$SCREENSHOT_DIR/04-gameplay.png"
echo "   ✅ 已保存: 04-gameplay.png"
sleep 1

# 截图5 - 游戏结束
echo ""
echo "📸 截图 5/5: 游戏结束界面"
echo "   请继续玩直到游戏结束"
echo "   会弹出'游戏结束'对话框"
read -p "   准备好后按回车截图..."
xcrun simctl io booted screenshot "$SCREENSHOT_DIR/05-game-over.png"
echo "   ✅ 已保存: 05-game-over.png"

echo ""
echo "🎉 所有截图完成！"
echo ""
echo "📁 截图位置: $SCREENSHOT_DIR"
echo ""

# 打开文件夹
open "$SCREENSHOT_DIR"

echo "✅ 截图清单："
ls -lh "$SCREENSHOT_DIR"/*.png 2>/dev/null | awk '{print "   " $9 " - " $5}'

echo ""
echo "📊 截图尺寸检查："
for file in "$SCREENSHOT_DIR"/*.png; do
    if [ -f "$file" ]; then
        size=$(sips -g pixelWidth -g pixelHeight "$file" | grep -E "pixelWidth|pixelHeight" | awk '{print $2}' | paste -sd "x" -)
        echo "   $(basename "$file"): $size"
    fi
done

echo ""
echo "🌍 如需英文截图："
echo "1. 在模拟器设置中切换到English"
echo "2. 重启应用"
echo "3. 重新运行此脚本"
echo ""

echo "📧 如有问题请联系: 279694479@qq.com"
echo ""
echo "✨ 完成！"
