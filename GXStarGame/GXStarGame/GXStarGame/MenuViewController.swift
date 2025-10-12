import UIKit

/// 游戏主菜单界面
class MenuViewController: UIViewController {
    
    // MARK: - UI组件
    private let gradientLayer = CAGradientLayer()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let iconLabel = UILabel()
    private let startButton = UIButton(type: .system)
    private let settingsButton = UIButton(type: .system)
    private let versionLabel = UILabel()
    
    // MARK: - 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupUI()
        setupAnimations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 开始播放背景音乐
        AudioManager.shared.playBackgroundMusic()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    // MARK: - UI设置
    
    private func setupGradientBackground() {
        // 使用与游戏相同的渐变背景
        gradientLayer.colors = [
            UIColor(red: 0.4, green: 0.2, blue: 0.8, alpha: 1.0).cgColor,
            UIColor(red: 0.6, green: 0.3, blue: 1.0, alpha: 1.0).cgColor,
            UIColor(red: 0.8, green: 0.4, blue: 1.0, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupUI() {
        // 游戏图标
        iconLabel.text = "💎"
        iconLabel.font = UIFont.systemFont(ofSize: 120)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(iconLabel)
        
        // 游戏标题
        titleLabel.text = NSLocalizedString("game.title", comment: "游戏标题")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 40)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 3)
        titleLabel.layer.shadowRadius = 6
        titleLabel.layer.shadowOpacity = 0.4
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // 副标题
        subtitleLabel.text = "GX Star Game"
        subtitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)
        
        // 开始游戏按钮
        startButton.setTitle(NSLocalizedString("menu.start", comment: "开始游戏"), for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        startButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        startButton.setTitleColor(UIColor(red: 0.4, green: 0.2, blue: 0.8, alpha: 1.0), for: .normal)
        startButton.layer.cornerRadius = 28
        startButton.layer.shadowColor = UIColor.black.cgColor
        startButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        startButton.layer.shadowRadius = 8
        startButton.layer.shadowOpacity = 0.3
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)
        view.addSubview(startButton)
        
        // 设置按钮
        settingsButton.setTitle(NSLocalizedString("menu.settings", comment: "设置"), for: .normal)
        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        settingsButton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        settingsButton.setTitleColor(.white, for: .normal)
        settingsButton.layer.cornerRadius = 25
        settingsButton.layer.borderWidth = 2
        settingsButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        view.addSubview(settingsButton)
        
        // 版本号
        versionLabel.text = "v1.0"
        versionLabel.font = UIFont.systemFont(ofSize: 14)
        versionLabel.textAlignment = .center
        versionLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(versionLabel)
        
        // 约束
        NSLayoutConstraint.activate([
            // 图标
            iconLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            
            // 标题
            titleLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            // 副标题
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            // 开始按钮
            startButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 60),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 240),
            startButton.heightAnchor.constraint(equalToConstant: 56),
            
            // 设置按钮
            settingsButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: 200),
            settingsButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 版本号
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupAnimations() {
        // 图标跳动动画
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 1.0
        pulse.toValue = 1.1
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        iconLabel.layer.add(pulse, forKey: "pulse")
        
        // 按钮渐入动画
        startButton.alpha = 0
        startButton.transform = CGAffineTransform(translationX: 0, y: 20)
        settingsButton.alpha = 0
        settingsButton.transform = CGAffineTransform(translationX: 0, y: 20)
        
        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.startButton.alpha = 1
            self.startButton.transform = .identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.settingsButton.alpha = 1
            self.settingsButton.transform = .identity
        }
    }
    
    // MARK: - 按钮事件
    
    @objc private func startGameTapped() {
        // 播放按钮音效
        AudioManager.shared.playSoundEffect(.buttonTap)
        
        // 按钮动画
        UIView.animate(withDuration: 0.1, animations: {
            self.startButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.startButton.transform = .identity
            }
        }
        
        // 延迟跳转，让动画播放完
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.navigateToGame()
        }
    }
    
    @objc private func settingsTapped() {
        // 播放按钮音效
        AudioManager.shared.playSoundEffect(.buttonTap)
        
        // 按钮动画
        UIView.animate(withDuration: 0.1, animations: {
            self.settingsButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.settingsButton.transform = .identity
            }
        }
        
        // 打开设置界面
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.presentSettings()
        }
    }
    
    // MARK: - 导航
    
    private func navigateToGame() {
        let gameVC = ViewController()
        gameVC.modalPresentationStyle = .fullScreen
        gameVC.modalTransitionStyle = .crossDissolve
        present(gameVC, animated: true)
    }
    
    private func presentSettings() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .pageSheet
        
        // iOS 15+ 设置自定义高度
        if #available(iOS 15.0, *) {
            if let sheet = settingsVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
        }
        
        present(settingsVC, animated: true)
    }
}


