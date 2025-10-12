import Foundation

class GameEngine {
    weak var delegate: GameEngineDelegate?
    
    private var gameBoard: [[Gem?]]
    private var score: Int = 0
    private var isProcessing = false
    private var lastSwap: (from: Position, to: Position)?
    
    init() {
        gameBoard = Array(repeating: Array(repeating: nil, count: GameConfig.cols), count: GameConfig.rows)
        setupInitialBoard()
    }
    
    // MARK: - 公共接口
    
    func getGem(at position: Position) -> Gem? {
        guard isValidPosition(position) else { return nil }
        return gameBoard[position.row][position.col]
    }
    
    func getCurrentScore() -> Int {
        return score
    }
    
    func canSwapGem(at position1: Position, with position2: Position) -> Bool {
        guard !isProcessing else { return false }
        guard isValidPosition(position1) && isValidPosition(position2) else { return false }
        guard isAdjacent(position1, position2) else { return false }
        guard gameBoard[position1.row][position1.col] != nil && gameBoard[position2.row][position2.col] != nil else { return false }
        
        return true
    }
    
    func swapGems(at position1: Position, with position2: Position) {
        guard canSwapGem(at: position1, with: position2) else { return }
        
        isProcessing = true
        print("开始交换: \(position1) -> \(position2)")
        
        // 记录交换前的宝石类型
        let gem1Type = gameBoard[position1.row][position1.col]?.type
        let gem2Type = gameBoard[position2.row][position2.col]?.type
        print("交换前: \(position1) = \(gem1Type), \(position2) = \(gem2Type)")
        
        // 记录交换位置
        lastSwap = (from: position1, to: position2)
        
        // 执行交换
        let temp = gameBoard[position1.row][position1.col]
        gameBoard[position1.row][position1.col] = gameBoard[position2.row][position2.col]
        gameBoard[position2.row][position2.col] = temp
        
        // 记录交换后的宝石类型
        let newGem1Type = gameBoard[position1.row][position1.col]?.type
        let newGem2Type = gameBoard[position2.row][position2.col]?.type
        print("交换后: \(position1) = \(newGem1Type), \(position2) = \(newGem2Type)")
        
        // 通知UI交换动画 - 双向交换
        delegate?.gameEngine(self, didMoveGems: [
            (from: position1, to: position2),
            (from: position2, to: position1)
        ])
        
        // 延迟检查匹配
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.checkAndProcessMatches()
        }
    }
    
    func resetGame() {
        isProcessing = false
        score = 0
        setupInitialBoard()
        delegate?.gameEngine(self, didUpdateScore: score)
    }
    
    // MARK: - 私有方法
    
    private func setupInitialBoard() {
        // 清空游戏板
        for row in 0..<GameConfig.rows {
            for col in 0..<GameConfig.cols {
                gameBoard[row][col] = nil
            }
        }
        
        // 填充初始宝石，确保没有初始匹配
        for row in 0..<GameConfig.rows {
            for col in 0..<GameConfig.cols {
                gameBoard[row][col] = createRandomGem(avoidingMatchesAt: Position(row, col))
            }
        }
        
        print("游戏板初始化完成")
    }
    
    private func createRandomGem(avoidingMatchesAt position: Position) -> Gem {
        let availableTypes = GemType.allCases
        var excludedTypes: Set<GemType> = []
        
        // 检查水平方向（向左看两个）
        if position.col >= 2 {
            let type1 = gameBoard[position.row][position.col - 1]?.type
            let type2 = gameBoard[position.row][position.col - 2]?.type
            if let t1 = type1, let t2 = type2, t1 == t2 {
                excludedTypes.insert(t1)
            }
        }
        
        // 检查垂直方向（向上看两个）
        if position.row >= 2 {
            let type1 = gameBoard[position.row - 1][position.col]?.type
            let type2 = gameBoard[position.row - 2][position.col]?.type
            if let t1 = type1, let t2 = type2, t1 == t2 {
                excludedTypes.insert(t1)
            }
        }
        
        // 从可用类型中排除会导致匹配的类型
        let validTypes = availableTypes.filter { !excludedTypes.contains($0) }
        
        // 如果有可用类型，随机选择一个；否则返回任意类型
        let selectedType = validTypes.isEmpty ? availableTypes.randomElement()! : validTypes.randomElement()!
        return Gem(type: selectedType)
    }
    
    private func isValidPosition(_ position: Position) -> Bool {
        return position.row >= 0 && position.row < GameConfig.rows &&
               position.col >= 0 && position.col < GameConfig.cols
    }
    
    private func isAdjacent(_ pos1: Position, _ pos2: Position) -> Bool {
        let rowDiff = abs(pos1.row - pos2.row)
        let colDiff = abs(pos1.col - pos2.col)
        return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1)
    }
    
    private func checkAndProcessMatches() {
        print("检查匹配...")
        printGameBoard()
        
        if hasMatches() {
            processMatches()
        } else {
            print("没有匹配，交换无效，恢复原状")
            revertLastSwap()
        }
    }
    
    private func printGameBoard() {
        print("当前游戏板状态:")
        for row in 0..<GameConfig.rows {
            var rowString = "行\(row): "
            for col in 0..<GameConfig.cols {
                if let gem = gameBoard[row][col] {
                    rowString += "\(gem.type) "
                } else {
                    rowString += "nil "
                }
            }
            print(rowString)
        }
    }
    
    private func revertLastSwap() {
        // 恢复最后一次交换
        guard let swap = lastSwap else {
            isProcessing = false
            delegate?.gameEngineDidCompleteTurn(self)
            return
        }
        
        print("恢复交换: \(swap.to) -> \(swap.from)")
        
        // 恢复游戏板状态
        let temp = gameBoard[swap.from.row][swap.from.col]
        gameBoard[swap.from.row][swap.from.col] = gameBoard[swap.to.row][swap.to.col]
        gameBoard[swap.to.row][swap.to.col] = temp
        
        // 通知UI恢复交换动画 - 双向交换
        delegate?.gameEngine(self, didMoveGems: [
            (from: swap.to, to: swap.from),
            (from: swap.from, to: swap.to)
        ])
        
        // 清除记录
        lastSwap = nil
        
        // 延迟结束处理
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isProcessing = false
            self.delegate?.gameEngineDidCompleteTurn(self)
        }
    }
    
    private func hasMatches() -> Bool {
        print("开始检查匹配...")
        
        // 检查水平匹配
        for row in 0..<GameConfig.rows {
            var count = 1
            var currentType: GemType?
            
            for col in 0..<GameConfig.cols {
                guard let gem = gameBoard[row][col] else {
                    // 遇到空方块，重置计数
                    if count >= GameConfig.minMatchCount {
                        print("找到水平匹配: 行\(row), 从列\(col-count)到列\(col-1)")
                        return true
                    }
                    count = 1
                    currentType = nil
                    continue
                }
                
                if gem.type == currentType {
                    count += 1
                } else {
                    // 类型改变，检查当前匹配
                    if count >= GameConfig.minMatchCount {
                        print("找到水平匹配: 行\(row), 从列\(col-count)到列\(col-1)")
                        return true
                    }
                    count = 1
                    currentType = gem.type
                }
            }
            
            // 行结束时检查最后的匹配
            if count >= GameConfig.minMatchCount {
                print("找到水平匹配: 行\(row), 从列\(GameConfig.cols-count)到列\(GameConfig.cols-1)")
                return true
            }
        }
        
        // 检查垂直匹配
        for col in 0..<GameConfig.cols {
            var count = 1
            var currentType: GemType?
            
            for row in 0..<GameConfig.rows {
                guard let gem = gameBoard[row][col] else {
                    // 遇到空方块，重置计数
                    if count >= GameConfig.minMatchCount {
                        print("找到垂直匹配: 列\(col), 从行\(row-count)到行\(row-1)")
                        return true
                    }
                    count = 1
                    currentType = nil
                    continue
                }
                
                if gem.type == currentType {
                    count += 1
                } else {
                    // 类型改变，检查当前匹配
                    if count >= GameConfig.minMatchCount {
                        print("找到垂直匹配: 列\(col), 从行\(row-count)到行\(row-1)")
                        return true
                    }
                    count = 1
                    currentType = gem.type
                }
            }
            
            // 列结束时检查最后的匹配
            if count >= GameConfig.minMatchCount {
                print("找到垂直匹配: 列\(col), 从行\(GameConfig.rows-count)到行\(GameConfig.rows-1)")
                return true
            }
        }
        
        print("没有找到匹配")
        return false
    }
    
    private func processMatches() {
        print("处理匹配...")
        
        let matches = findMatches()
        if matches.isEmpty {
            isProcessing = false
            delegate?.gameEngineDidCompleteTurn(self)
            return
        }
        
        print("找到 \(matches.count) 个匹配组")
        
        // 收集所有匹配的位置
        let allMatchedPositions = Set(matches.flatMap { $0 })
        
        // 通知UI显示匹配
        delegate?.gameEngine(self, didFindMatches: Array(allMatchedPositions))
        
        // 延迟移除匹配的宝石
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.removeMatchedGems(matchedPositions: allMatchedPositions)
        }
    }
    
    private func findMatches() -> [[Position]] {
        var allMatches: [[Position]] = []
        
        // 查找水平匹配
        for row in 0..<GameConfig.rows {
            var currentMatch: [Position] = []
            var currentType: GemType?
            
            for col in 0..<GameConfig.cols {
                guard let gem = gameBoard[row][col] else {
                    if currentMatch.count >= GameConfig.minMatchCount {
                        allMatches.append(currentMatch)
                    }
                    currentMatch = []
                    currentType = nil
                    continue
                }
                
                if gem.type == currentType {
                    currentMatch.append(Position(row, col))
                } else {
                    if currentMatch.count >= GameConfig.minMatchCount {
                        allMatches.append(currentMatch)
                    }
                    currentMatch = [Position(row, col)]
                    currentType = gem.type
                }
            }
            
            if currentMatch.count >= GameConfig.minMatchCount {
                allMatches.append(currentMatch)
            }
        }
        
        // 查找垂直匹配
        for col in 0..<GameConfig.cols {
            var currentMatch: [Position] = []
            var currentType: GemType?
            
            for row in 0..<GameConfig.rows {
                guard let gem = gameBoard[row][col] else {
                    if currentMatch.count >= GameConfig.minMatchCount {
                        allMatches.append(currentMatch)
                    }
                    currentMatch = []
                    currentType = nil
                    continue
                }
                
                if gem.type == currentType {
                    currentMatch.append(Position(row, col))
                } else {
                    if currentMatch.count >= GameConfig.minMatchCount {
                        allMatches.append(currentMatch)
                    }
                    currentMatch = [Position(row, col)]
                    currentType = gem.type
                }
            }
            
            if currentMatch.count >= GameConfig.minMatchCount {
                allMatches.append(currentMatch)
            }
        }
        
        return allMatches
    }
    
    private func removeMatchedGems(matchedPositions: Set<Position>) {
        print("移除 \(matchedPositions.count) 个匹配的宝石")
        
        // 移除匹配的宝石
        for position in matchedPositions {
            gameBoard[position.row][position.col] = nil
        }
        
        // 计算分数
        let matchScore = matchedPositions.count * 10
        score += matchScore
        delegate?.gameEngine(self, didUpdateScore: score)
        
        // 通知UI移除宝石
        delegate?.gameEngine(self, didRemoveGems: Array(matchedPositions))
        
        // 延迟执行下落
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dropGems()
        }
    }
    
    private func dropGems() {
        print("开始下落宝石")
        var drops: [(from: Position, to: Position)] = []
        
        for col in 0..<GameConfig.cols {
            var writeIndex = GameConfig.rows - 1
            
            // 从底部向上扫描，将非空宝石向下移动
            for readIndex in stride(from: GameConfig.rows - 1, through: 0, by: -1) {
                if let gem = gameBoard[readIndex][col] {
                    if readIndex != writeIndex {
                        // 需要移动
                        gameBoard[writeIndex][col] = gem
                        gameBoard[readIndex][col] = nil
                        drops.append((from: Position(readIndex, col), to: Position(writeIndex, col)))
                    }
                    writeIndex -= 1
                }
            }
        }
        
        if !drops.isEmpty {
            print("执行 \(drops.count) 个下落动画")
            delegate?.gameEngine(self, didMoveGems: drops)
            
            // 延迟生成新宝石
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.spawnNewGems()
            }
        } else {
            // 没有下落，直接生成新宝石
            spawnNewGems()
        }
    }
    
    private func spawnNewGems() {
        print("开始生成新宝石")
        var spawnedPositions: [Position] = []
        
        // 按列处理，从顶部开始生成新方块
        for col in 0..<GameConfig.cols {
            for row in 0..<GameConfig.rows {
                if gameBoard[row][col] == nil {
                    let newGem = createRandomGem(avoidingMatchesAt: Position(row, col))
                    gameBoard[row][col] = newGem
                    spawnedPositions.append(Position(row, col))
                }
            }
        }
        
        if !spawnedPositions.isEmpty {
            print("生成了 \(spawnedPositions.count) 个新宝石")
            delegate?.gameEngine(self, didSpawnNewGems: spawnedPositions)
            
            // 延迟检查新的匹配
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.processMatches()
            }
        } else {
            // 没有生成新宝石，检查是否还有可用移动
            print("没有生成新宝石，检查是否有可用移动")
            if !hasPossibleMoves() {
                print("没有可用移动，游戏结束")
                isProcessing = false
                delegate?.gameEngineDidGameOver(self)
            } else {
                print("还有可用移动，结束处理")
                isProcessing = false
                delegate?.gameEngineDidCompleteTurn(self)
            }
        }
    }
    
    // MARK: - 检测可用移动
    
    private func hasPossibleMoves() -> Bool {
        // 遍历所有位置，尝试与相邻位置交换
        for row in 0..<GameConfig.rows {
            for col in 0..<GameConfig.cols {
                let position = Position(row, col)
                
                // 尝试向右交换
                if col < GameConfig.cols - 1 {
                    let rightPosition = Position(row, col + 1)
                    if wouldCreateMatch(swapping: position, with: rightPosition) {
                        return true
                    }
                }
                
                // 尝试向下交换
                if row < GameConfig.rows - 1 {
                    let downPosition = Position(row + 1, col)
                    if wouldCreateMatch(swapping: position, with: downPosition) {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    private func wouldCreateMatch(swapping pos1: Position, with pos2: Position) -> Bool {
        // 临时交换
        let temp = gameBoard[pos1.row][pos1.col]
        gameBoard[pos1.row][pos1.col] = gameBoard[pos2.row][pos2.col]
        gameBoard[pos2.row][pos2.col] = temp
        
        // 检查是否产生匹配
        let hasMatch = hasMatches()
        
        // 恢复交换
        gameBoard[pos2.row][pos2.col] = gameBoard[pos1.row][pos1.col]
        gameBoard[pos1.row][pos1.col] = temp
        
        return hasMatch
    }
}