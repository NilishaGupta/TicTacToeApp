//
//  Game.swift
//  TicTacToe
//
//  Created by Nilisha Gupta on 11/01/23.
//

import Foundation

class Game {
    // MARK: - Variable Declarations
    // Game vars
    var table: [[Sign]]
    var player1: Player
    var player2: Player
    var currentPlayerSign: Sign
    
    // Init the game
    init(player1: Player, player2: Player) {
        self.table = [[.empty, .empty, .empty], [.empty, .empty, .empty], [.empty, .empty, .empty]]
        self.player1 = player1
        self.player2 = player2
        self.currentPlayerSign = player1.sign
    }
    
    /// Gameplay
    internal func nextMove() {
        let win = win(table: table)
        // Check that it's not the end of the game
        if !full(table: table) && win == .empty {
            // Iterate the players
            for player in [player1, player2] {
                if player.sign == currentPlayerSign {
                    // Here the player plays
                    player.play(game: self) { [weak self] (x, y) in
                        guard let uSelf = self else { return }
                        // Set the move
                        if uSelf.play(rowIndex: x, columnIndex: y, sign: player.sign) {
                            uSelf.currentPlayerSign = uSelf.currentPlayerSign == .X ? .O : .X
                        }
                        // Update UI
                        NotificationCenter.default.post(name: .boardChanged, object: nil)
                        // And go to next move
                        uSelf.nextMove()
                    }
                    // Stop here
                    return
                }
            }
        }
        // The game ended
        currentPlayerSign = .empty
        NotificationCenter.default.post(name: .boardChanged, object: nil)
    }
    
    /// Make a player plays in the board
    internal func play(rowIndex: Int, columnIndex: Int, sign: Sign) -> Bool {
        if rowIndex >= 0 && rowIndex < 3 && columnIndex >= 0 && columnIndex < 3 && table[rowIndex][columnIndex] == .empty {
            table[rowIndex][columnIndex] = sign
            return true
        }
        return false
    }
    
    /// Check is there is a winner
    internal func win(table: [[Sign]]) -> Sign {
        // Row and column check
        for index in 0 ..< 3 {
            // Check if a column has a winner
            let column = column(table: table, columnIndex: index)
            if column != .empty {
                return column
            }
            // Check if a row has a winner
            let row = row(table: table, rowIndex: index)
            if row != .empty {
                return row
            }
        }
        // Diagonal check
        for index in 0 ..< 2 {
            // Check is a dia has a winner
            let dia = diagonal(table: table, diagonalIndex: index)
            if dia != .empty {
                return dia
            }
        }
        return .empty
    }
    
    /// Check if a line/column is full
    internal func column(table: [[Sign]], columnIndex: Int) -> Sign {
        let sign = table[0][columnIndex]
        var changed = false
        for index in 0 ..< 3 {
            if table[index][columnIndex] != sign {
                changed = true
            }
        }
        if changed {
            return .empty
        }
        return sign
    }
    
    /// Check if a row is full
    internal func row(table: [[Sign]], rowIndex: Int) -> Sign {
        let sign = table[rowIndex][0]
        var changed = false
        for index in 0 ..< 3 {
            if table[rowIndex][index] != sign {
                changed = true
            }
        }
        if changed {
            return .empty
        }
        return sign
    }
    
    /// Check if a diagonal is full
    internal func diagonal(table: [[Sign]], diagonalIndex: Int) -> Sign {
        var index = diagonalIndex == 0 ? 0 : 2
        let sign = table[index][0]
        var changed = false
        for x in 0 ..< 3 {
            index = diagonalIndex == 0 ? x : 2 - x
            if table[index][x] != sign {
                changed = true
            }
        }
        if changed {
            return .empty
        }
        return sign
    }
    
    /// Check if the board is full
    internal func full(table: [[Sign]]) -> Bool {
        for x in 0 ..< 3 {
            for y in 0 ..< 3 {
                if table[x][y] == .empty {
                    return false
                }
            }
        }
        return true
    }
}
