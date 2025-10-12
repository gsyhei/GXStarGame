import Foundation
import UIKit

// MARK: - 游戏配置
struct GameConfig {
    static let rows = 8
    static let cols = 8
    static let gemSize: CGFloat = 40
    static let gemSpacing: CGFloat = 3
    static let minMatchCount = 3
    static let animationDuration: TimeInterval = 0.3
    static let dropAnimationDuration: TimeInterval = 0.4
}

// MARK: - 位置结构
struct Position: Equatable, Hashable {
    let row: Int
    let col: Int
    
    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }
}

// MARK: - 宝石类型
enum GemType: CaseIterable {
    case red
    case blue
    case green
    case yellow
    case purple
    case orange
    
    var color: UIColor {
        switch self {
        case .red: return UIColor.systemRed
        case .blue: return UIColor.systemBlue
        case .green: return UIColor.systemGreen
        case .yellow: return UIColor.systemYellow
        case .purple: return UIColor.systemPurple
        case .orange: return UIColor.systemOrange
        }
    }
}

// MARK: - 宝石模型
class Gem {
    let type: GemType
    let id: UUID
    
    init(type: GemType) {
        self.type = type
        self.id = UUID()
    }
}

// MARK: - 游戏状态
enum GameState {
    case ready
    case animating
    case processing
    case gameOver
}

// MARK: - 游戏引擎代理
protocol GameEngineDelegate: AnyObject {
    func gameEngine(_ engine: GameEngine, didUpdateScore score: Int)
    func gameEngine(_ engine: GameEngine, didFindMatches matches: [Position])
    func gameEngine(_ engine: GameEngine, didRemoveGems positions: [Position])
    func gameEngine(_ engine: GameEngine, didMoveGems moves: [(from: Position, to: Position)])
    func gameEngine(_ engine: GameEngine, didSpawnNewGems positions: [Position])
    func gameEngineDidCompleteTurn(_ engine: GameEngine)
    func gameEngineDidGameOver(_ engine: GameEngine)
}