#!/bin/bash

# 星辰消消乐 - App Store 截图自动化脚本
# 使用方法：chmod +x 快速截图脚本.sh && ./快速截图脚本.sh

echo "🎮 星辰消消乐 - 截图工具"
echo "========================"
echo ""

# 创建截图目录
SCREENSHOT_DIR="$HOME/Desktop/GXStarGame-Screenshots"
mkdir -p "$SCREENSHOT_DIR"

echo "📁 截图将保存到: $SCREENSHOT_DIR"
echo ""

# 支持的模拟器列表
SIMULATORS=(
    "iPhone 14 Pro Max"
    "iPhone 11 Pro Max"
    "iPhone 8 Plus"
)

# 选择模拟器
echo "请选择要使用的模拟器："
echo "1) iPhone 14 Pro Max (6.7\" - 1290x2796)"
echo "2) iPhone 11 Pro Max (6.5\" - 1242x2688)"
echo "3) iPhone 8 Plus (5.5\" - 1242x2208)"
echo "4) 全部（自动在三个模拟器上截图）"
echo ""
read -p "请输入选项 (1-4): " choice

case $choice in
    1)
        SELECTED_SIM="${SIMULATORS[0]}"
        SIZE="6.7"
        ;;
    2)
        SELECTED_SIM="${SIMULATORS[1]}"
        SIZE="6.5"
        ;;
    3)
        SELECTED_SIM="${SIMULATORS[2]}"
        SIZE="5.5"
        ;;
    4)
        echo "将在所有模拟器上运行"
        ;;
    *)
        echo "❌ 无效选项"
        exit 1
        ;;
esac

# 截图函数
take_screenshot() {
    local simulator_name=$1
    local size_name=$2
    local shot_num=$3
    
    echo "📸 正在截图 $shot_num..."
    
    local filename="${SCREENSHOT_DIR}/StarMatch_${size_name}_screenshot_${shot_num}.png"
    
    xcrun simctl io booted screenshot "$filename"
    
    if [ $? -eq 0 ]; then
        echo "✅ 截图成功: $(basename $filename)"
    else
        echo "❌ 截图失败"
    fi
}

# 启动模拟器并截图
capture_on_simulator() {
    local simulator=$1
    local size=$2
    
    echo ""
    echo "🚀 启动模拟器: $simulator"
    
    # 启动模拟器
    xcrun simctl boot "$simulator" 2>/dev/null
    
    # 等待模拟器启动
    echo "⏳ 等待模拟器启动..."
    sleep 3
    
    # 打开模拟器窗口
    open -a Simulator
    sleep 2
    
    echo ""
    echo "📱 模拟器已启动"
    echo ""
    echo "⚠️  接下来需要手动操作："
    echo "   1. 在Xcode中运行应用到此模拟器"
    echo "   2. 调整游戏到需要截图的状态"
    echo "   3. 按回车键开始截图"
    echo ""
    read -p "准备好后按回车继续..."
    
    # 截图
    echo ""
    echo "开始截图流程..."
    echo "（每张截图之间会有5秒间隔，请调整游戏状态）"
    echo ""
    
    # 截图1 - 主界面
    echo "📸 截图 1/5 - 主界面（游戏标题和完整布局）"
    read -p "   准备好后按回车截图..." 
    take_screenshot "$simulator" "$size" "01"
    sleep 2
    
    # 截图2 - 游戏中
    echo ""
    echo "📸 截图 2/5 - 游戏进行中（选中宝石状态）"
    echo "   请在游戏中选择一个宝石，展示交互效果"
    read -p "   准备好后按回车截图..."
    take_screenshot "$simulator" "$size" "02"
    sleep 2
    
    # 截图3 - 消除
    echo ""
    echo "📸 截图 3/5 - 消除瞬间（动画效果）"
    echo "   请进行一次消除，捕捉消除动画"
    read -p "   准备好后按回车截图..."
    take_screenshot "$simulator" "$size" "03"
    sleep 2
    
    # 截图4 - 高分
    echo ""
    echo "📸 截图 4/5 - 高分展示（分数较高）"
    echo "   建议分数至少300+，展示游戏深度"
    read -p "   准备好后按回车截图..."
    take_screenshot "$simulator" "$size" "04"
    sleep 2
    
    # 截图5 - 游戏结束
    echo ""
    echo "📸 截图 5/5 - 游戏结束界面"
    echo "   请让游戏结束，显示结束对话框"
    read -p "   准备好后按回车截图..."
    take_screenshot "$simulator" "$size" "05"
    
    echo ""
    echo "✅ $simulator 截图完成！"
    
    # 关闭模拟器
    read -p "是否关闭此模拟器？(y/n): " close_sim
    if [ "$close_sim" = "y" ]; then
        xcrun simctl shutdown "$simulator"
        echo "已关闭模拟器"
    fi
}

# 执行截图
if [ $choice -eq 4 ]; then
    # 在所有模拟器上截图
    for i in 0 1 2; do
        sim="${SIMULATORS[$i]}"
        if [ $i -eq 0 ]; then
            size="6.7"
        elif [ $i -eq 1 ]; then
            size="6.5"
        else
            size="5.5"
        fi
        
        capture_on_simulator "$sim" "$size"
        
        if [ $i -lt 2 ]; then
            echo ""
            echo "准备切换到下一个模拟器..."
            read -p "按回车继续..."
        fi
    done
else
    # 在选定的模拟器上截图
    capture_on_simulator "$SELECTED_SIM" "$SIZE"
fi

echo ""
echo "🎉 所有截图已完成！"
echo ""
echo "📁 截图保存位置: $SCREENSHOT_DIR"
echo ""
echo "下一步："
echo "1. 检查截图质量"
echo "2. （可选）使用在线工具添加设备边框"
echo "3. （可选）添加文字说明"
echo "4. 上传到App Store Connect"
echo ""
echo "如需为不同语言截图，请："
echo "1. 在iOS设置中更改系统语言"
echo "2. 重新运行此脚本"
echo ""

# 打开截图文件夹
read -p "是否打开截图文件夹？(y/n): " open_folder
if [ "$open_folder" = "y" ]; then
    open "$SCREENSHOT_DIR"
fi

echo ""
echo "📧 如有问题，请联系: 279694479@qq.com"
echo ""
echo "完成！✨"

