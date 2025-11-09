#!/bin/bash

# 星辰魔法师 - App Store 截图自动化脚本
# 使用方法：chmod +x 快速截图脚本.sh && ./快速截图脚本.sh

set -e

echo "🎮 星辰魔法师 - 全自动截图工具"
echo "================================"
echo ""

# 截图目录
SCREENSHOT_DIR="$HOME/Desktop/GXStarGame-Screenshots"
mkdir -p "$SCREENSHOT_DIR"

echo "📁 截图将保存到: $SCREENSHOT_DIR"
echo ""

# 支持的模拟器（名称|屏幕尺寸标签）
SIMULATORS=(
    "iPhone 17 Pro Max|6.9"
    "iPhone 14 Pro Max|6.7"
    "iPhone 11 Pro Max|6.5"
    "iPhone 8 Plus|5.5"
)

# 截图描述与文件后缀（描述|后缀）
SHOT_SPECS=(
    "主菜单（标题与完整布局）|menu"
    "游戏进行中（选中宝石）|selected"
    "消除瞬间（动画效果）|match"
    "高分展示（分数较高）|highscore"
    "修炼结束（游戏结束弹窗）|gameover"
)

# 倒计时时长（秒），可通过 COUNTDOWN_SECONDS 覆盖
COUNTDOWN_SECONDS=${COUNTDOWN_SECONDS:-8}

# 获取模拟器 UDID
get_simulator_udid() {
    local name="$1"
    xcrun simctl list devices | \
        grep -F "$name (" | \
        grep -v "unavailable" | \
        head -1 | \
        awk -F '[()]' 'NF>1 {print $2}'
}

countdown() {
    local seconds=$1
    local message=$2

    echo ""
    echo "$message"
    for ((s=seconds; s>0; s--)); do
        printf "   ⏳ %2d 秒后自动截图\r" "$s"
        sleep 1
    done
    echo -e "   ⏳  0 秒 - 开始截图            "
}

sanitize_name() {
    echo "$1" | tr ' ' '_'
}

take_screenshot() {
    local simulator_udid=$1
    local size=$2
    local shot_label=$3
    local simulator_tag
    simulator_tag=$(sanitize_name "$4")

    local filename="${SCREENSHOT_DIR}/StarMagician_${simulator_tag}_${shot_label}_${size}.png"

    if xcrun simctl io "$simulator_udid" screenshot "$filename" >/dev/null 2>&1; then
        echo "   ✅ 已保存: $(basename "$filename")"
    else
        echo "   ❌ 截图失败: $(basename "$filename")"
    fi
}

capture_on_simulator() {
    local simulator=$1
    local size=$2
    local simulator_tag
    simulator_tag=$(sanitize_name "$simulator")

    local simulator_udid
    simulator_udid=$(get_simulator_udid "$simulator")

    if [ -z "$simulator_udid" ]; then
        echo "❌ 未找到模拟器: $simulator"
        return
    fi

    echo ""
    echo "🚀 启动模拟器: $simulator"
    xcrun simctl boot "$simulator_udid" >/dev/null 2>&1 || true

    echo "⏳ 等待模拟器启动..."
    sleep 4

    # 将模拟器窗口置前
    open -a Simulator >/dev/null 2>&1 || true
    sleep 3

    echo ""
    echo "📱 请确保应用已在 $simulator 上运行。"
    echo "   将脚本启动时，游戏应处于截图所需状态。"

    for index in "${!SHOT_SPECS[@]}"; do
        local spec="${SHOT_SPECS[$index]}"
        local description="${spec%%|*}"
        local label="${spec##*|}"
        local shot_num=$(printf "%02d" $((index + 1)))

        countdown "$COUNTDOWN_SECONDS" "📸 截图 ${shot_num}/5 - $description"
        take_screenshot "$simulator_udid" "$size" "${shot_num}-${label}" "$simulator"
    done

    echo ""
    echo "✅ $simulator 截图完成，正在关闭模拟器..."
    xcrun simctl shutdown "$simulator_udid" >/dev/null 2>&1 || true
}

echo "📋 将按以下顺序自动截图："
for sim_entry in "${SIMULATORS[@]}"; do
    sim_name="${sim_entry%%|*}"
    echo "   • $sim_name"
done
echo ""
echo "🕒 每张截图前会自动倒计时 ${COUNTDOWN_SECONDS} 秒，可在此期间快速调整画面。"
echo "   如需更多时间，可重新运行脚本并设置 COUNTDOWN_SECONDS（例如：COUNTDOWN_SECONDS=12 ./快速截图脚本.sh）"
echo ""

for entry in "${SIMULATORS[@]}"; do
    simulator="${entry%%|*}"
    size="${entry##*|}"
    capture_on_simulator "$simulator" "$size"
done

echo ""
echo "🎉 全部截图已完成！"
echo "📁 截图保存位置: $SCREENSHOT_DIR"
echo ""
echo "📸 提示：如需多语言截图，请切换模拟器系统语言后再次运行脚本。"
echo ""

# 自动打开截图目录
open "$SCREENSHOT_DIR" >/dev/null 2>&1 || true

echo "📧 如有疑问，请联系: 279694479@qq.com"
echo "✨ 完成！"

