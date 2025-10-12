import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI 组件
    private let titleLabel = UILabel()
    private let scoreLabel = UILabel()
    private let scorePanelView = UIView()
    private let gameBoardView = UIView()
    private let resetButton = UIButton(type: .system)
    private let backButton = UIButton(type: .system)
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - 游戏相关
    private let gameEngine = GameEngine()
    private var gemViews: [[GemView?]] = []
    private var selectedPosition: Position?
    private var isAnimating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupUI()
        setupGame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        layoutGameBoard()
    }
    
    // MARK: - UI 设置
    
    private func setupGradientBackground() {
        // 创建漂亮的渐变背景
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
        // 标题
        titleLabel.text = NSLocalizedString("game.title", comment: "游戏标题")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleLabel.layer.shadowRadius = 4
        titleLabel.layer.shadowOpacity = 0.3
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // 分数面板容器
        scorePanelView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        scorePanelView.layer.cornerRadius = 15
        scorePanelView.layer.borderWidth = 2
        scorePanelView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        scorePanelView.layer.shadowColor = UIColor.black.cgColor
        scorePanelView.layer.shadowOffset = CGSize(width: 0, height: 4)
        scorePanelView.layer.shadowRadius = 8
        scorePanelView.layer.shadowOpacity = 0.2
        scorePanelView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scorePanelView)
        
        // 分数标签
        scoreLabel.text = String(format: NSLocalizedString("game.score", comment: "分数"), 0)
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 22)
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = .white
        scoreLabel.layer.shadowColor = UIColor.black.cgColor
        scoreLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        scoreLabel.layer.shadowRadius = 2
        scoreLabel.layer.shadowOpacity = 0.5
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scorePanelView.addSubview(scoreLabel)
        
        // 游戏板
        gameBoardView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        gameBoardView.layer.cornerRadius = 20
        gameBoardView.layer.borderWidth = 3
        gameBoardView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        gameBoardView.layer.shadowColor = UIColor.black.cgColor
        gameBoardView.layer.shadowOffset = CGSize(width: 0, height: 8)
        gameBoardView.layer.shadowRadius = 16
        gameBoardView.layer.shadowOpacity = 0.3
        gameBoardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameBoardView)
        
        // 重置按钮
        resetButton.setTitle(NSLocalizedString("game.reset", comment: "重新开始"), for: .normal)
        resetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        resetButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        resetButton.setTitleColor(UIColor(red: 0.4, green: 0.2, blue: 0.8, alpha: 1.0), for: .normal)
        resetButton.layer.cornerRadius = 25
        resetButton.layer.shadowColor = UIColor.black.cgColor
        resetButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        resetButton.layer.shadowRadius = 8
        resetButton.layer.shadowOpacity = 0.3
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        view.addSubview(resetButton)
        
        // 返回菜单按钮
        backButton.setTitle("⬅️ 菜单", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        backButton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        backButton.setTitleColor(.white, for: .normal)
        backButton.layer.cornerRadius = 20
        backButton.layer.borderWidth = 2
        backButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 标题
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // 分数面板
            scorePanelView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            scorePanelView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scorePanelView.widthAnchor.constraint(equalToConstant: 200),
            scorePanelView.heightAnchor.constraint(equalToConstant: 50),
            
            // 分数标签
            scoreLabel.centerXAnchor.constraint(equalTo: scorePanelView.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: scorePanelView.centerYAnchor),
            
            // 游戏板
            gameBoardView.topAnchor.constraint(equalTo: scorePanelView.bottomAnchor, constant: 20),
            gameBoardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameBoardView.widthAnchor.constraint(equalToConstant: CGFloat(GameConfig.cols) * GameConfig.gemSize + CGFloat(GameConfig.cols - 1) * GameConfig.gemSpacing + 30),
            gameBoardView.heightAnchor.constraint(equalToConstant: CGFloat(GameConfig.rows) * GameConfig.gemSize + CGFloat(GameConfig.rows - 1) * GameConfig.gemSpacing + 30),
            
            // 重置按钮
            resetButton.topAnchor.constraint(equalTo: gameBoardView.bottomAnchor, constant: 25),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.widthAnchor.constraint(equalToConstant: 160),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 返回按钮
            backButton.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 15),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 120),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gameBoardTapped(_:)))
        gameBoardView.addGestureRecognizer(tapGesture)
    }
    
    private func setupGame() {
        gameEngine.delegate = self
        gameEngine.resetGame()  // 先重置游戏，生成游戏板
        createGemViews()        // 再创建视图，确保视图与游戏板一致
    }
    
    private func createGemViews() {
        // 清除现有的视图
        gemViews.forEach { row in
            row.forEach { $0?.removeFromSuperview() }
        }
        gemViews.removeAll()
        
        // 创建新的视图数组
        gemViews = Array(repeating: Array(repeating: nil, count: GameConfig.cols), count: GameConfig.rows)
        
        for row in 0..<GameConfig.rows {
            for col in 0..<GameConfig.cols {
                if let gem = gameEngine.getGem(at: Position(row, col)) {
                    let gemView = GemView(gemType: gem.type)
                    gemView.tag = row * GameConfig.cols + col
                    gameBoardView.addSubview(gemView)
                    gemViews[row][col] = gemView
                }
            }
        }
    }
    
    private func layoutGameBoard() {
        let boardWidth = gameBoardView.bounds.width
        let boardHeight = gameBoardView.bounds.height
        
        guard boardWidth > 0 && boardHeight > 0 else { return }
        
        let totalWidth = CGFloat(GameConfig.cols) * GameConfig.gemSize + CGFloat(GameConfig.cols - 1) * GameConfig.gemSpacing
        let totalHeight = CGFloat(GameConfig.rows) * GameConfig.gemSize + CGFloat(GameConfig.rows - 1) * GameConfig.gemSpacing
        
        let startX = (boardWidth - totalWidth) / 2
        let startY = (boardHeight - totalHeight) / 2
        
        for row in 0..<GameConfig.rows {
            for col in 0..<GameConfig.cols {
                if let gemView = gemViews[row][col] {
                    let x = startX + CGFloat(col) * (GameConfig.gemSize + GameConfig.gemSpacing)
                    let y = startY + CGFloat(row) * (GameConfig.gemSize + GameConfig.gemSpacing)
                    
                    gemView.frame = CGRect(x: x, y: y, width: GameConfig.gemSize, height: GameConfig.gemSize)
                }
            }
        }
    }
    
    // MARK: - 用户交互
    
    @objc private func gameBoardTapped(_ gesture: UITapGestureRecognizer) {
        guard !isAnimating else {
            print("点击被忽略，正在动画中")
            return
        }
        
        let location = gesture.location(in: gameBoardView)
        let position = positionFromLocation(location)
        
        print("点击位置: \(position)")
        
        if let selected = selectedPosition {
            if selected == position {
                // 取消选择
                deselectGem(at: selected)
                selectedPosition = nil
            } else if gameEngine.canSwapGem(at: selected, with: position) {
                // 执行交换
                print("开始交换: \(selected) -> \(position)")
                deselectGem(at: selected)
                selectedPosition = nil
                gameEngine.swapGems(at: selected, with: position)
            } else {
                // 选择新的位置
                deselectGem(at: selected)
                selectGem(at: position)
                selectedPosition = position
            }
        } else {
            // 选择新位置
            selectGem(at: position)
            selectedPosition = position
        }
    }
    
    @objc private func resetButtonTapped() {
        guard !isAnimating else { return }
        
        // 播放按钮音效
        AudioManager.shared.playSoundEffect(.buttonTap)
        
        selectedPosition = nil
        gameEngine.resetGame()
        createGemViews()
        layoutGameBoard()
    }
    
    @objc private func backButtonTapped() {
        // 播放按钮音效
        AudioManager.shared.playSoundEffect(.buttonTap)
        
        // 返回菜单
        dismiss(animated: true)
    }
    
    // MARK: - 辅助方法
    
    private func positionFromLocation(_ location: CGPoint) -> Position {
        let boardWidth = gameBoardView.bounds.width
        let boardHeight = gameBoardView.bounds.height
        
        let totalWidth = CGFloat(GameConfig.cols) * GameConfig.gemSize + CGFloat(GameConfig.cols - 1) * GameConfig.gemSpacing
        let totalHeight = CGFloat(GameConfig.rows) * GameConfig.gemSize + CGFloat(GameConfig.rows - 1) * GameConfig.gemSpacing
        
        let startX = (boardWidth - totalWidth) / 2
        let startY = (boardHeight - totalHeight) / 2
        
        let col = Int((location.x - startX) / (GameConfig.gemSize + GameConfig.gemSpacing))
        let row = Int((location.y - startY) / (GameConfig.gemSize + GameConfig.gemSpacing))
        
        return Position(max(0, min(row, GameConfig.rows - 1)), max(0, min(col, GameConfig.cols - 1)))
    }
    
    private func selectGem(at position: Position) {
        guard let gemView = gemViews[position.row][position.col] else { return }
        gemView.animateSelection()
        
        // 播放选择音效
        AudioManager.shared.playSoundEffect(.select)
        
        print("选择方块: \(position)")
    }
    
    private func deselectGem(at position: Position) {
        guard let gemView = gemViews[position.row][position.col] else { return }
        gemView.animateDeselection()
    }
}

// MARK: - GameEngineDelegate

extension ViewController: GameEngineDelegate {
    
    func gameEngine(_ engine: GameEngine, didUpdateScore score: Int) {
        DispatchQueue.main.async {
            self.scoreLabel.text = String(format: NSLocalizedString("game.score", comment: "分数"), score)
            
            // 添加分数更新动画
            UIView.animate(withDuration: 0.2, animations: {
                self.scorePanelView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    self.scorePanelView.transform = .identity
                }
            }
        }
    }
    
    func gameEngine(_ engine: GameEngine, didFindMatches matches: [Position]) {
        DispatchQueue.main.async {
            self.isAnimating = true
            print("显示匹配动画: \(matches.count) 个位置")
            
            // 播放消除音效
            AudioManager.shared.playSoundEffect(.match)
            
            for position in matches {
                if let gemView = self.gemViews[position.row][position.col] {
                    gemView.animateRemoval()
                }
            }
        }
    }
    
    func gameEngine(_ engine: GameEngine, didRemoveGems positions: [Position]) {
        DispatchQueue.main.async {
            print("移除方块: \(positions.count) 个位置")
            
            for position in positions {
                if let gemView = self.gemViews[position.row][position.col] {
                    gemView.removeFromSuperview()
                    self.gemViews[position.row][position.col] = nil
                }
            }
        }
    }
    
    func gameEngine(_ engine: GameEngine, didMoveGems moves: [(from: Position, to: Position)]) {
        DispatchQueue.main.async {
            print("移动方块: \(moves.count) 个移动")
            
            // 创建临时数组来存储交换信息
            var tempStorage: [(view: GemView, toRow: Int, toCol: Int)] = []
            
            for move in moves {
                if let gemView = self.gemViews[move.from.row][move.from.col] {
                    let boardWidth = self.gameBoardView.bounds.width
                    let boardHeight = self.gameBoardView.bounds.height
                    let totalWidth = CGFloat(GameConfig.cols) * GameConfig.gemSize + CGFloat(GameConfig.cols - 1) * GameConfig.gemSpacing
                    let totalHeight = CGFloat(GameConfig.rows) * GameConfig.gemSize + CGFloat(GameConfig.rows - 1) * GameConfig.gemSpacing
                    let startX = (boardWidth - totalWidth) / 2
                    let startY = (boardHeight - totalHeight) / 2
                    
                    let x = startX + CGFloat(move.to.col) * (GameConfig.gemSize + GameConfig.gemSpacing) + GameConfig.gemSize / 2
                    let y = startY + CGFloat(move.to.row) * (GameConfig.gemSize + GameConfig.gemSpacing) + GameConfig.gemSize / 2
                    
                    let toPosition = CGPoint(x: x, y: y)
                    
                    gemView.animateMove(to: toPosition)
                    
                    // 暂存移动信息
                    tempStorage.append((view: gemView, toRow: move.to.row, toCol: move.to.col))
                    
                    // 先清空from位置
                    self.gemViews[move.from.row][move.from.col] = nil
                }
            }
            
            // 在动画完成后更新视图数组
            DispatchQueue.main.asyncAfter(deadline: .now() + GameConfig.animationDuration) {
                for item in tempStorage {
                    self.gemViews[item.toRow][item.toCol] = item.view
                }
            }
        }
    }
    
    func gameEngine(_ engine: GameEngine, didSpawnNewGems positions: [Position]) {
        DispatchQueue.main.async {
            print("生成新方块: \(positions.count) 个位置")
            
            for position in positions {
                if let gem = engine.getGem(at: position) {
                    let gemView = GemView(gemType: gem.type)
                    gemView.tag = position.row * GameConfig.cols + position.col
                    
                    // 设置初始位置（在屏幕上方）
                    let boardWidth = self.gameBoardView.bounds.width
                    let boardHeight = self.gameBoardView.bounds.height
                    let totalWidth = CGFloat(GameConfig.cols) * GameConfig.gemSize + CGFloat(GameConfig.cols - 1) * GameConfig.gemSpacing
                    let totalHeight = CGFloat(GameConfig.rows) * GameConfig.gemSize + CGFloat(GameConfig.rows - 1) * GameConfig.gemSpacing
                    let startX = (boardWidth - totalWidth) / 2
                    let startY = (boardHeight - totalHeight) / 2
                    
                    let x = startX + CGFloat(position.col) * (GameConfig.gemSize + GameConfig.gemSpacing)
                    let y = startY - GameConfig.gemSize * 2 // 从上方开始
                    
                    gemView.frame = CGRect(x: x, y: y, width: GameConfig.gemSize, height: GameConfig.gemSize)
                    gemView.alpha = 1.0  // 修复：设置为完全可见
                    
                    self.gameBoardView.addSubview(gemView)
                    self.gemViews[position.row][position.col] = gemView
                    
                    // 动画到目标位置
                    let targetY = startY + CGFloat(position.row) * (GameConfig.gemSize + GameConfig.gemSpacing)
                    let targetPosition = CGPoint(x: x + GameConfig.gemSize / 2, y: targetY + GameConfig.gemSize / 2)
                    
                    gemView.animateDrop(to: targetPosition)
                }
            }
        }
    }
    
    func gameEngineDidCompleteTurn(_ engine: GameEngine) {
        DispatchQueue.main.async {
            self.isAnimating = false
            print("游戏处理完成，可以接受点击")
        }
    }
    
    func gameEngineDidGameOver(_ engine: GameEngine) {
        DispatchQueue.main.async {
            self.isAnimating = false
            print("游戏结束")
            
            // 播放游戏结束音效
            AudioManager.shared.playSoundEffect(.gameOver)
            
            // 显示游戏结束提示
            let finalScore = engine.getCurrentScore()
            let alert = UIAlertController(
                title: NSLocalizedString("game.over.title", comment: "游戏结束"),
                message: String(format: NSLocalizedString("game.over.message", comment: "游戏结束信息"), finalScore),
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("game.over.restart", comment: "重新开始"), style: .default) { _ in
                self.resetButtonTapped()
            })
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("game.over.cancel", comment: "取消"), style: .cancel))
            
            self.present(alert, animated: true)
        }
    }
}