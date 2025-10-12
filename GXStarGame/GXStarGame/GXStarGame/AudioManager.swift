import AVFoundation
import AudioToolbox
import UIKit

/// 音频管理器 - 管理游戏中的所有音乐和音效
class AudioManager {
    
    // MARK: - 单例
    static let shared = AudioManager()
    
    // MARK: - 音频播放器
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var soundEffectPlayers: [String: AVAudioPlayer] = [:]
    
    // MARK: - 设置
    private var isMusicEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isMusicEnabled")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isMusicEnabled")
        }
    }
    
    private var isSoundEffectsEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isSoundEffectsEnabled")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isSoundEffectsEnabled")
        }
    }
    
    // MARK: - 初始化
    private init() {
        // 设置默认值 - 首次启动时音效默认开启
        let hasLaunched = UserDefaults.standard.object(forKey: "hasLaunchedBefore") != nil
        if !hasLaunched {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.set(true, forKey: "isMusicEnabled")
            UserDefaults.standard.set(true, forKey: "isSoundEffectsEnabled")
        }
        
        // 配置音频会话
        setupAudioSession()
        
        print("🔊 音频管理器初始化")
        print("   音乐开关: \(getMusicEnabled())")
        print("   音效开关: \(getSoundEffectsEnabled())")
    }
    
    // MARK: - 音频会话设置
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.ambient, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("⚠️ 音频会话设置失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 背景音乐
    
    /// 播放背景音乐
    func playBackgroundMusic(filename: String = "background_music", fileExtension: String = "mp3") {
        guard isMusicEnabled else { return }
        
        // 如果已经在播放相同的音乐，不重复播放
        if backgroundMusicPlayer?.isPlaying == true {
            return
        }
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            print("⚠️ 找不到音乐文件: \(filename).\(fileExtension)")
            print("💡 提示: 请将音乐文件添加到项目中")
            return
        }
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1 // 无限循环
            backgroundMusicPlayer?.volume = 0.3 // 背景音乐音量稍低
            backgroundMusicPlayer?.prepareToPlay()
            backgroundMusicPlayer?.play()
            print("🎵 背景音乐开始播放")
        } catch {
            print("⚠️ 播放背景音乐失败: \(error.localizedDescription)")
        }
    }
    
    /// 停止背景音乐
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
        print("🎵 背景音乐已停止")
    }
    
    /// 暂停背景音乐
    func pauseBackgroundMusic() {
        backgroundMusicPlayer?.pause()
    }
    
    /// 恢复背景音乐
    func resumeBackgroundMusic() {
        guard isMusicEnabled else { return }
        backgroundMusicPlayer?.play()
    }
    
    /// 设置背景音乐音量
    func setBackgroundMusicVolume(_ volume: Float) {
        backgroundMusicPlayer?.volume = volume
    }
    
    // MARK: - 音效
    
    /// 播放音效
    func playSoundEffect(_ effect: SoundEffect) {
        guard isSoundEffectsEnabled else {
            print("🔇 音效已关闭")
            return
        }
        
        print("🔊 尝试播放音效: \(effect.filename)")
        
        // 先尝试播放自定义音效文件
        if let url = Bundle.main.url(forResource: effect.filename, withExtension: effect.fileExtension) {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.volume = effect.volume
                player.prepareToPlay()
                player.play()
                
                print("✅ 使用自定义音效: \(effect.filename)")
                
                // 保存引用，防止被释放
                soundEffectPlayers[effect.filename] = player
                
                // 播放完成后清理
                DispatchQueue.main.asyncAfter(deadline: .now() + player.duration + 0.1) {
                    self.soundEffectPlayers.removeValue(forKey: effect.filename)
                }
                return
            } catch {
                print("⚠️ 播放音效失败: \(error.localizedDescription)")
            }
        }
        
        // 如果找不到文件，使用系统音效和触觉反馈
        print("💡 使用系统音效: ID \(effect.systemSoundID)")
        AudioServicesPlaySystemSound(effect.systemSoundID)
        
        // 同时添加触觉反馈，增强体验
        playHapticFeedback(for: effect)
    }
    
    /// 播放触觉反馈
    private func playHapticFeedback(for effect: SoundEffect) {
        let generator = UIImpactFeedbackGenerator(style: effect.hapticStyle)
        generator.prepare()
        generator.impactOccurred()
    }
    
    // MARK: - 设置管理
    
    /// 获取音乐开关状态
    func getMusicEnabled() -> Bool {
        return isMusicEnabled
    }
    
    /// 设置音乐开关
    func setMusicEnabled(_ enabled: Bool) {
        isMusicEnabled = enabled
        
        if enabled {
            playBackgroundMusic()
        } else {
            stopBackgroundMusic()
        }
    }
    
    /// 获取音效开关状态
    func getSoundEffectsEnabled() -> Bool {
        return isSoundEffectsEnabled
    }
    
    /// 设置音效开关
    func setSoundEffectsEnabled(_ enabled: Bool) {
        isSoundEffectsEnabled = enabled
    }
    
    /// 切换音乐开关
    func toggleMusic() {
        setMusicEnabled(!isMusicEnabled)
    }
    
    /// 切换音效开关
    func toggleSoundEffects() {
        setSoundEffectsEnabled(!isSoundEffectsEnabled)
    }
    
    // MARK: - 高级音效（可选）
    
    /// 使用代码生成的音效（立即可用，无需文件）
    func playGeneratedSoundEffect(_ effect: SoundEffect) {
        guard isSoundEffectsEnabled else { return }
        
        // 使用简单的正弦波生成音效并立即播放
        let sampleRate = 44100.0
        let duration = effect.generatedDuration
        let frequency = effect.generatedFrequency
        let sampleCount = Int(sampleRate * duration)
        
        var samples = [Float](repeating: 0, count: sampleCount)
        
        for i in 0..<sampleCount {
            let time = Double(i) / sampleRate
            let envelope = getEnvelope(time: time, duration: duration)
            samples[i] = Float(sin(2.0 * .pi * frequency * time) * 0.5 * envelope)
        }
        
        // 创建临时音频并播放
        playGeneratedAudio(samples: samples, sampleRate: sampleRate)
    }
    
    /// 计算音频包络（淡入淡出）
    private func getEnvelope(time: Double, duration: Double) -> Double {
        let attackTime = min(0.01, duration * 0.1)    // 淡入
        let releaseTime = min(0.05, duration * 0.2)   // 淡出
        
        if time < attackTime {
            return time / attackTime
        } else if time > duration - releaseTime {
            return (duration - time) / releaseTime
        } else {
            return 1.0
        }
    }
    
    /// 播放生成的音频
    private func playGeneratedAudio(samples: [Float], sampleRate: Double) {
        let format = AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: sampleRate,
            channels: 1,
            interleaved: false
        )!
        
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(samples.count)) else {
            return
        }
        
        buffer.frameLength = buffer.frameCapacity
        
        if let channelData = buffer.floatChannelData {
            for i in 0..<samples.count {
                channelData[0][i] = samples[i]
            }
        }
        
        // 使用 AVAudioEngine 播放
        let engine = AVAudioEngine()
        let playerNode = AVAudioPlayerNode()
        
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: format)
        
        do {
            try engine.start()
            playerNode.scheduleBuffer(buffer, at: nil, options: [], completionHandler: nil)
            playerNode.play()
        } catch {
            print("⚠️ 播放生成音频失败: \(error.localizedDescription)")
        }
    }
}

// MARK: - 音效枚举

/// 游戏音效类型
enum SoundEffect {
    case select      // 选择宝石
    case swap        // 交换宝石
    case match       // 匹配消除
    case drop        // 宝石下落
    case gameOver    // 游戏结束
    case buttonTap   // 按钮点击
    
    var filename: String {
        switch self {
        case .select:
            return "select"
        case .swap:
            return "swap"
        case .match:
            return "match"
        case .drop:
            return "drop"
        case .gameOver:
            return "game_over"
        case .buttonTap:
            return "button_tap"
        }
    }
    
    var fileExtension: String {
        return "mp3"
    }
    
    var volume: Float {
        switch self {
        case .select, .buttonTap:
            return 0.5
        case .swap:
            return 0.6
        case .match:
            return 0.7
        case .drop:
            return 0.4
        case .gameOver:
            return 0.8
        }
    }
    
    /// 系统音效ID（备选方案）
    var systemSoundID: SystemSoundID {
        switch self {
        case .select:
            return 1104  // 按键音（更明显）
        case .swap:
            return 1105  // 按键音2
        case .match:
            return 1057  // 提示音（更响亮）
        case .drop:
            return 1054  // 提示音2
        case .gameOver:
            return 1053  // 提示音3
        case .buttonTap:
            return 1104  // 按键音
        }
    }
    
    /// 触觉反馈风格
    var hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle {
        switch self {
        case .select, .buttonTap:
            return .light
        case .swap:
            return .medium
        case .match:
            return .heavy
        case .drop:
            return .light
        case .gameOver:
            return .heavy
        }
    }
    
    /// 生成音频的频率（用于代码生成）
    var generatedFrequency: Double {
        switch self {
        case .select:
            return 800
        case .swap:
            return 700
        case .match:
            return 600
        case .drop:
            return 500
        case .gameOver:
            return 400
        case .buttonTap:
            return 1000
        }
    }
    
    /// 生成音频的时长（用于代码生成）
    var generatedDuration: Double {
        switch self {
        case .select:
            return 0.15
        case .swap:
            return 0.2
        case .match:
            return 0.3
        case .drop:
            return 0.2
        case .gameOver:
            return 0.5
        case .buttonTap:
            return 0.1
        }
    }
}

