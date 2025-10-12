import UIKit

/// 设置界面
class SettingsViewController: UIViewController {
    
    // MARK: - UI组件
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    
    // 音乐设置
    private let musicSection = UIView()
    private let musicLabel = UILabel()
    private let musicSwitch = UISwitch()
    
    // 音效设置
    private let soundSection = UIView()
    private let soundLabel = UILabel()
    private let soundSwitch = UISwitch()
    
    // 关于部分
    private let aboutSection = UIView()
    private let aboutLabel = UILabel()
    private let versionLabel = UILabel()
    private let developerLabel = UILabel()
    
    // MARK: - 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSettings()
    }
    
    // MARK: - UI设置
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // 标题
        titleLabel.text = NSLocalizedString("menu.settings", comment: "设置")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // 关闭按钮
        closeButton.setTitle(NSLocalizedString("settings.close", comment: "关闭"), for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        contentView.addSubview(closeButton)
        
        // 音乐设置部分
        setupMusicSection()
        
        // 音效设置部分
        setupSoundSection()
        
        // 关于部分
        setupAboutSection()
        
        // 约束
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 标题
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // 关闭按钮
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 音乐部分
            musicSection.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            musicSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            musicSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            musicSection.heightAnchor.constraint(equalToConstant: 60),
            
            // 音效部分
            soundSection.topAnchor.constraint(equalTo: musicSection.bottomAnchor, constant: 20),
            soundSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            soundSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            soundSection.heightAnchor.constraint(equalToConstant: 60),
            
            // 关于部分
            aboutSection.topAnchor.constraint(equalTo: soundSection.bottomAnchor, constant: 40),
            aboutSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            aboutSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            aboutSection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupMusicSection() {
        musicSection.backgroundColor = UIColor.systemGray6
        musicSection.layer.cornerRadius = 15
        musicSection.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(musicSection)
        
        // 图标和文字
        let iconLabel = UILabel()
        iconLabel.text = "🎵"
        iconLabel.font = UIFont.systemFont(ofSize: 30)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        musicSection.addSubview(iconLabel)
        
        musicLabel.text = NSLocalizedString("settings.music", comment: "背景音乐")
        musicLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        musicLabel.translatesAutoresizingMaskIntoConstraints = false
        musicSection.addSubview(musicLabel)
        
        musicSwitch.onTintColor = UIColor(red: 0.6, green: 0.3, blue: 1.0, alpha: 1.0)
        musicSwitch.translatesAutoresizingMaskIntoConstraints = false
        musicSwitch.addTarget(self, action: #selector(musicSwitchChanged), for: .valueChanged)
        musicSection.addSubview(musicSwitch)
        
        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: musicSection.leadingAnchor, constant: 15),
            iconLabel.centerYAnchor.constraint(equalTo: musicSection.centerYAnchor),
            
            musicLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 15),
            musicLabel.centerYAnchor.constraint(equalTo: musicSection.centerYAnchor),
            
            musicSwitch.trailingAnchor.constraint(equalTo: musicSection.trailingAnchor, constant: -15),
            musicSwitch.centerYAnchor.constraint(equalTo: musicSection.centerYAnchor)
        ])
    }
    
    private func setupSoundSection() {
        soundSection.backgroundColor = UIColor.systemGray6
        soundSection.layer.cornerRadius = 15
        soundSection.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(soundSection)
        
        // 图标和文字
        let iconLabel = UILabel()
        iconLabel.text = "🔊"
        iconLabel.font = UIFont.systemFont(ofSize: 30)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        soundSection.addSubview(iconLabel)
        
        soundLabel.text = NSLocalizedString("settings.sound", comment: "游戏音效")
        soundLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        soundLabel.translatesAutoresizingMaskIntoConstraints = false
        soundSection.addSubview(soundLabel)
        
        soundSwitch.onTintColor = UIColor(red: 0.6, green: 0.3, blue: 1.0, alpha: 1.0)
        soundSwitch.translatesAutoresizingMaskIntoConstraints = false
        soundSwitch.addTarget(self, action: #selector(soundSwitchChanged), for: .valueChanged)
        soundSection.addSubview(soundSwitch)
        
        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: soundSection.leadingAnchor, constant: 15),
            iconLabel.centerYAnchor.constraint(equalTo: soundSection.centerYAnchor),
            
            soundLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 15),
            soundLabel.centerYAnchor.constraint(equalTo: soundSection.centerYAnchor),
            
            soundSwitch.trailingAnchor.constraint(equalTo: soundSection.trailingAnchor, constant: -15),
            soundSwitch.centerYAnchor.constraint(equalTo: soundSection.centerYAnchor)
        ])
    }
    
    private func setupAboutSection() {
        aboutSection.backgroundColor = UIColor.systemGray6
        aboutSection.layer.cornerRadius = 15
        aboutSection.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(aboutSection)
        
        aboutLabel.text = NSLocalizedString("settings.about", comment: "关于")
        aboutLabel.font = UIFont.boldSystemFont(ofSize: 18)
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutSection.addSubview(aboutLabel)
        
        versionLabel.text = "版本: v1.0"
        versionLabel.font = UIFont.systemFont(ofSize: 16)
        versionLabel.textColor = .secondaryLabel
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutSection.addSubview(versionLabel)
        
        developerLabel.text = "开发者: GX Team"
        developerLabel.font = UIFont.systemFont(ofSize: 16)
        developerLabel.textColor = .secondaryLabel
        developerLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutSection.addSubview(developerLabel)
        
        // 支持按钮
        let supportButton = UIButton(type: .system)
        supportButton.setTitle("📧 " + NSLocalizedString("settings.support", comment: "技术支持"), for: .normal)
        supportButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        supportButton.translatesAutoresizingMaskIntoConstraints = false
        supportButton.addTarget(self, action: #selector(supportTapped), for: .touchUpInside)
        aboutSection.addSubview(supportButton)
        
        NSLayoutConstraint.activate([
            aboutLabel.topAnchor.constraint(equalTo: aboutSection.topAnchor, constant: 20),
            aboutLabel.leadingAnchor.constraint(equalTo: aboutSection.leadingAnchor, constant: 20),
            
            versionLabel.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 15),
            versionLabel.leadingAnchor.constraint(equalTo: aboutSection.leadingAnchor, constant: 20),
            
            developerLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 10),
            developerLabel.leadingAnchor.constraint(equalTo: aboutSection.leadingAnchor, constant: 20),
            
            supportButton.topAnchor.constraint(equalTo: developerLabel.bottomAnchor, constant: 20),
            supportButton.centerXAnchor.constraint(equalTo: aboutSection.centerXAnchor),
            supportButton.bottomAnchor.constraint(equalTo: aboutSection.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - 设置加载和保存
    
    private func loadSettings() {
        musicSwitch.isOn = AudioManager.shared.getMusicEnabled()
        soundSwitch.isOn = AudioManager.shared.getSoundEffectsEnabled()
    }
    
    @objc private func musicSwitchChanged() {
        AudioManager.shared.setMusicEnabled(musicSwitch.isOn)
        
        // 播放音效
        if soundSwitch.isOn {
            AudioManager.shared.playSoundEffect(.buttonTap)
        }
    }
    
    @objc private func soundSwitchChanged() {
        AudioManager.shared.setSoundEffectsEnabled(soundSwitch.isOn)
        
        // 播放音效（测试）
        if soundSwitch.isOn {
            AudioManager.shared.playSoundEffect(.buttonTap)
        }
    }
    
    // MARK: - 按钮事件
    
    @objc private func closeTapped() {
        AudioManager.shared.playSoundEffect(.buttonTap)
        dismiss(animated: true)
    }
    
    @objc private func supportTapped() {
        AudioManager.shared.playSoundEffect(.buttonTap)
        
        let email = "279694479@qq.com"
        let subject = "[星辰消消乐] 技术支持"
        let urlString = "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}


