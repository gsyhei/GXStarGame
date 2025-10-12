import AVFoundation
import UIKit

/// 简单音频生成器 - 使用代码生成简单的音效文件
class SimpleAudioGenerator {
    
    /// 生成所有游戏需要的音效文件
    static func generateAllSoundEffects() {
        print("🎵 开始生成音效文件...")
        
        let effects: [(name: String, frequency: Double, duration: Double)] = [
            ("select", 800, 0.15),      // 选择 - 高音短促
            ("match", 600, 0.3),        // 消除 - 中音较长
            ("button_tap", 1000, 0.1),  // 按钮 - 极高音极短
            ("game_over", 400, 0.5),    // 结束 - 低音较长
            ("swap", 700, 0.2),         // 交换 - 中高音
            ("drop", 500, 0.2)          // 下落 - 中音
        ]
        
        for effect in effects {
            generateBeepSound(
                filename: effect.name,
                frequency: effect.frequency,
                duration: effect.duration
            )
        }
        
        // 生成背景音乐（简单的循环旋律）
        generateBackgroundMusic()
        
        print("✅ 所有音效生成完成！")
        print("📁 文件保存在 Documents 目录")
        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            print("路径: \(documentsPath.path)")
        }
        print("\n⚠️ 下一步：")
        print("1. 从设备下载这些文件")
        print("2. 将它们添加到Xcode项目中")
        print("3. 或者使用系统音效（已自动启用）")
    }
    
    /// 生成简单的哔声音效
    private static func generateBeepSound(filename: String, frequency: Double, duration: Double) {
        let sampleRate = 44100.0
        let amplitude = 0.5
        let sampleCount = Int(sampleRate * duration)
        
        // 创建音频缓冲区
        var samples = [Float](repeating: 0, count: sampleCount)
        
        // 生成正弦波
        for i in 0..<sampleCount {
            let time = Double(i) / sampleRate
            // 正弦波 + 包络（淡入淡出）
            let envelope = getEnvelope(time: time, duration: duration)
            samples[i] = Float(sin(2.0 * .pi * frequency * time) * amplitude * envelope)
        }
        
        // 保存为音频文件
        saveAudioFile(samples: samples, sampleRate: sampleRate, filename: "\(filename).mp3")
    }
    
    /// 生成背景音乐（简单旋律）
    private static func generateBackgroundMusic() {
        let sampleRate = 44100.0
        let duration = 10.0  // 10秒循环
        let sampleCount = Int(sampleRate * duration)
        
        var samples = [Float](repeating: 0, count: sampleCount)
        
        // 简单的旋律音符（C大调音阶）
        let notes: [(frequency: Double, start: Double, duration: Double)] = [
            (523.25, 0.0, 0.5),    // C5
            (587.33, 0.5, 0.5),    // D5
            (659.25, 1.0, 0.5),    // E5
            (698.46, 1.5, 0.5),    // F5
            (783.99, 2.0, 1.0),    // G5
            (698.46, 3.0, 0.5),    // F5
            (659.25, 3.5, 0.5),    // E5
            (587.33, 4.0, 0.5),    // D5
            (523.25, 4.5, 1.5),    // C5
            // 重复
            (659.25, 6.0, 0.5),    // E5
            (783.99, 6.5, 0.5),    // G5
            (880.00, 7.0, 1.0),    // A5
            (783.99, 8.0, 0.5),    // G5
            (659.25, 8.5, 1.5),    // E5
        ]
        
        // 生成每个音符
        for note in notes {
            let startSample = Int(note.start * sampleRate)
            let noteDuration = note.duration
            let noteSamples = Int(noteDuration * sampleRate)
            
            for i in 0..<noteSamples {
                let sampleIndex = startSample + i
                if sampleIndex < sampleCount {
                    let time = Double(i) / sampleRate
                    let envelope = getEnvelope(time: time, duration: noteDuration)
                    samples[sampleIndex] += Float(sin(2.0 * .pi * note.frequency * time) * 0.3 * envelope)
                }
            }
        }
        
        saveAudioFile(samples: samples, sampleRate: sampleRate, filename: "background_music.mp3")
    }
    
    /// 计算音频包络（淡入淡出）
    private static func getEnvelope(time: Double, duration: Double) -> Double {
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
    
    /// 计算音符包络
    private static func getNoteEnvelope(time: Double, duration: Double) -> Double {
        return getEnvelope(time: time, duration: duration)
    }
    
    /// 保存音频文件
    private static func saveAudioFile(samples: [Float], sampleRate: Double, filename: String) {
        // 创建音频格式
        let format = AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: sampleRate,
            channels: 1,
            interleaved: false
        )!
        
        // 创建音频缓冲区
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(samples.count)) else {
            print("❌ 创建缓冲区失败")
            return
        }
        
        buffer.frameLength = buffer.frameCapacity
        
        // 复制样本数据
        if let channelData = buffer.floatChannelData {
            for i in 0..<samples.count {
                channelData[0][i] = samples[i]
            }
        }
        
        // 保存到文件
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent(filename)
        
        do {
            let audioFile = try AVAudioFile(
                forWriting: fileURL,
                settings: format.settings,
                commonFormat: .pcmFormatInt16,
                interleaved: false
            )
            
            try audioFile.write(from: buffer)
            print("✅ 生成音效: \(filename)")
        } catch {
            print("❌ 保存失败: \(filename) - \(error.localizedDescription)")
        }
    }
}
