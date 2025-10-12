import UIKit

class GemView: UIView {
    private let gemType: GemType
    private let heartImageView = UIImageView()
    
    init(gemType: GemType) {
        self.gemType = gemType
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // 设置圆角和阴影效果（更强的阴影）
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.4
        
        // 设置背景颜色
        backgroundColor = gemType.color
        
        // 添加更漂亮的渐变效果
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            gemType.color.withAlphaComponent(0.7).cgColor,
            gemType.color.cgColor,
            gemType.color.withAlphaComponent(0.9).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 10
        layer.insertSublayer(gradientLayer, at: 0)
        
        // 添加内边框（光泽效果）
        let borderLayer = CALayer()
        borderLayer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        borderLayer.borderWidth = 2
        borderLayer.cornerRadius = 10
        layer.addSublayer(borderLayer)
        
        // 添加高光层
        addHighlightLayer()
        
        // 设置爱心图标
        setupHeartIcon()
    }
    
    private func addHighlightLayer() {
        let highlightLayer = CAGradientLayer()
        highlightLayer.colors = [
            UIColor.white.withAlphaComponent(0.4).cgColor,
            UIColor.white.withAlphaComponent(0.0).cgColor
        ]
        highlightLayer.locations = [0.0, 0.5]
        highlightLayer.startPoint = CGPoint(x: 0, y: 0)
        highlightLayer.endPoint = CGPoint(x: 0, y: 1)
        highlightLayer.cornerRadius = 10
        layer.addSublayer(highlightLayer)
    }
    
    private func setupHeartIcon() {
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(heartImageView)
        
        // 创建爱心图标
        let heartImage = createHeartImage()
        heartImageView.image = heartImage
        heartImageView.contentMode = .scaleAspectFit
        heartImageView.tintColor = .white
        
        NSLayoutConstraint.activate([
            heartImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            heartImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            heartImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            heartImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6)
        ])
    }
    
    private func createHeartImage() -> UIImage? {
        let size = CGSize(width: 24, height: 24)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let cgContext = context.cgContext
            
            // 设置填充颜色
            cgContext.setFillColor(UIColor.white.cgColor)
            
            // 绘制爱心形状
            let path = UIBezierPath()
            let width = size.width
            let height = size.height
            
            // 爱心的数学公式绘制
            let centerX = width / 2
            let centerY = height / 2
            let radius = min(width, height) / 4
            
            // 左半部分
            path.addArc(withCenter: CGPoint(x: centerX - radius/2, y: centerY - radius/2), 
                       radius: radius, 
                       startAngle: .pi, 
                       endAngle: 0, 
                       clockwise: true)
            
            // 右半部分
            path.addArc(withCenter: CGPoint(x: centerX + radius/2, y: centerY - radius/2), 
                       radius: radius, 
                       startAngle: .pi, 
                       endAngle: 0, 
                       clockwise: true)
            
            // 底部尖角
            path.addLine(to: CGPoint(x: centerX, y: centerY + radius))
            path.close()
            
            cgContext.addPath(path.cgPath)
            cgContext.fillPath()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 更新所有层的frame
        layer.sublayers?.forEach { sublayer in
            if sublayer is CAGradientLayer || sublayer is CALayer {
                sublayer.frame = bounds
            }
        }
    }
    
    // MARK: - 动画方法
    
    func animateSelection() {
        UIView.animate(withDuration: 0.15,
                      delay: 0,
                      usingSpringWithDamping: 0.6,
                      initialSpringVelocity: 0.5,
                      options: .curveEaseOut,
                      animations: {
            self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            self.layer.shadowRadius = 10
            self.layer.shadowOpacity = 0.6
        })
    }
    
    func animateDeselection() {
        UIView.animate(withDuration: 0.15,
                      delay: 0,
                      usingSpringWithDamping: 0.7,
                      initialSpringVelocity: 0.5,
                      options: .curveEaseOut,
                      animations: {
            self.transform = .identity
            self.layer.shadowRadius = 6
            self.layer.shadowOpacity = 0.4
        })
    }
    
    func animateRemoval() {
        // 添加粒子效果般的消除动画
        UIView.animate(withDuration: 0.25,
                      delay: 0,
                      options: .curveEaseIn,
                      animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.alpha = 0
            }
        }
    }
    
    func animateMove(to position: CGPoint) {
        UIView.animate(withDuration: GameConfig.animationDuration, 
                      delay: 0,
                      usingSpringWithDamping: 0.8,
                      initialSpringVelocity: 0.3,
                      options: [.curveEaseInOut], 
                      animations: {
            self.center = position
        })
    }
    
    func animateDrop(to position: CGPoint) {
        UIView.animate(withDuration: GameConfig.dropAnimationDuration, 
                      delay: 0,
                      usingSpringWithDamping: 0.7,
                      initialSpringVelocity: 0.5,
                      options: [.curveEaseIn], 
                      animations: {
            self.center = position
            self.alpha = 1.0
        })
    }
    
    func animateSpawn() {
        // 初始状态：透明且缩小并带有旋转
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1).rotated(by: .pi / 4)
        
        // 动画到正常状态（带有弹性效果）
        UIView.animate(withDuration: 0.4, 
                      delay: 0,
                      usingSpringWithDamping: 0.6,
                      initialSpringVelocity: 0.8,
                      options: [.curveEaseOut], 
                      animations: {
            self.alpha = 1.0
            self.transform = .identity
        })
    }
}