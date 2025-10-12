import UIKit

/// App Icon 生成器
/// 使用方法：在 AppDelegate 或任意位置调用 AppIconGenerator.generateIcons() 即可生成所有尺寸的图标
class AppIconGenerator {
    
    static func generateIcons() {
        let sizes: [(String, CGFloat)] = [
            ("20x20", 20),
            ("20x20@2x", 40),
            ("20x20@3x", 60),
            ("29x29", 29),
            ("29x29@2x", 58),
            ("29x29@3x", 87),
            ("40x40", 40),
            ("40x40@2x", 80),
            ("40x40@3x", 120),
            ("60x60@2x", 120),
            ("60x60@3x", 180),
            ("1024x1024", 1024)
        ]
        
        for (name, size) in sizes {
            if let image = generateAppIcon(size: size) {
                saveImage(image, name: name)
            }
        }
        
        print("✅ App Icons 生成完成！请在 Documents 目录查看生成的图标。")
        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            print("📁 路径: \(documentsPath.path)")
        }
    }
    
    private static func generateAppIcon(size: CGFloat) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // 绘制渐变背景
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [
            UIColor(red: 0.4, green: 0.2, blue: 0.8, alpha: 1.0).cgColor,
            UIColor(red: 0.6, green: 0.3, blue: 1.0, alpha: 1.0).cgColor
        ] as CFArray
        
        if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: [0.0, 1.0]) {
            context.drawLinearGradient(gradient,
                                      start: CGPoint(x: 0, y: 0),
                                      end: CGPoint(x: size, y: size),
                                      options: [])
        }
        
        // 绘制圆角矩形边框（可选）
        let borderRect = rect.insetBy(dx: size * 0.08, dy: size * 0.08)
        let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: size * 0.15)
        UIColor.white.withAlphaComponent(0.3).setStroke()
        borderPath.lineWidth = size * 0.02
        borderPath.stroke()
        
        // 绘制宝石图案
        drawGemPattern(in: context, size: size)
        
        // 绘制文字（对于较大的图标）
        if size >= 120 {
            let fontSize = size * 0.15
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: fontSize),
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black.withAlphaComponent(0.3),
                .strokeWidth: -2.0
            ]
            
            let text = "星辰"
            let textSize = text.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (size - textSize.width) / 2,
                y: size * 0.65,
                width: textSize.width,
                height: textSize.height
            )
            text.draw(in: textRect, withAttributes: attributes)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    private static func drawGemPattern(in context: CGContext, size: CGFloat) {
        let centerX = size / 2
        let centerY = size * 0.4
        let gemSize = size * 0.3
        
        // 绘制宝石形状
        context.saveGState()
        
        // 主宝石
        drawGem(in: context, center: CGPoint(x: centerX, y: centerY), size: gemSize, color: .white)
        
        // 小宝石装饰
        let smallSize = gemSize * 0.4
        drawGem(in: context, center: CGPoint(x: centerX - gemSize * 0.6, y: centerY - gemSize * 0.3), size: smallSize, color: UIColor.white.withAlphaComponent(0.6))
        drawGem(in: context, center: CGPoint(x: centerX + gemSize * 0.6, y: centerY - gemSize * 0.3), size: smallSize, color: UIColor.white.withAlphaComponent(0.6))
        
        context.restoreGState()
    }
    
    private static func drawGem(in context: CGContext, center: CGPoint, size: CGFloat, color: UIColor) {
        let path = UIBezierPath()
        
        // 创建宝石形状（菱形）
        path.move(to: CGPoint(x: center.x, y: center.y - size / 2))
        path.addLine(to: CGPoint(x: center.x + size / 2, y: center.y))
        path.addLine(to: CGPoint(x: center.x, y: center.y + size / 2))
        path.addLine(to: CGPoint(x: center.x - size / 2, y: center.y))
        path.close()
        
        // 填充宝石
        context.saveGState()
        path.addClip()
        
        // 添加渐变效果
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [
            color.cgColor,
            color.withAlphaComponent(0.7).cgColor
        ] as CFArray
        
        if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: [0.0, 1.0]) {
            context.drawLinearGradient(gradient,
                                      start: CGPoint(x: center.x - size / 2, y: center.y - size / 2),
                                      end: CGPoint(x: center.x + size / 2, y: center.y + size / 2),
                                      options: [])
        }
        
        context.restoreGState()
        
        // 绘制边框
        color.setStroke()
        path.lineWidth = size * 0.05
        path.stroke()
        
        // 添加高光
        let highlightPath = UIBezierPath()
        highlightPath.move(to: CGPoint(x: center.x - size * 0.15, y: center.y - size * 0.2))
        highlightPath.addLine(to: CGPoint(x: center.x + size * 0.15, y: center.y - size * 0.2))
        highlightPath.addLine(to: CGPoint(x: center.x, y: center.y))
        highlightPath.close()
        
        UIColor.white.withAlphaComponent(0.5).setFill()
        highlightPath.fill()
    }
    
    private static func saveImage(_ image: UIImage, name: String) {
        guard let data = image.pngData() else { return }
        
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let fileURL = documentsDirectory.appendingPathComponent("AppIcon-\(name).png")
        
        do {
            try data.write(to: fileURL)
            print("✓ 生成: AppIcon-\(name).png")
        } catch {
            print("✗ 保存失败: \(name) - \(error.localizedDescription)")
        }
    }
    
    /// 快速预览图标（用于调试）
    static func previewIcon() -> UIImage? {
        return generateAppIcon(size: 180)
    }
}



