//
//  Computer.swift
//  TicTacToe
//
//  Created by Nilisha Gupta on 11/01/23.
//

import Foundation

class Computer: Player {
    // Override player play function
    override func play(game: Game, completion: @escaping (Int, Int) -> ()) {
        let deadline: DispatchTime = .now() + 1
        let (x, y) = bestMove(game: game, table: game.table, sign: sign).0
        DispatchQueue.global(qos: .background).asyncAfter(deadline: deadline) {
            completion(x, y)
        }
    }
    
    /// Select the best possibility of game
    internal func bestMove(game: Game, table: [[Sign]], sign: Sign) -> ((Int, Int), Int) {
        // Get the sign of ennemy
        let other = sign == .O ? Sign.X : Sign.O
        // Create an array for moves
        var moves = [((Int, Int), Int)]()
        // Iterate the table to find all moves
        for column in 0 ..< 3 {
            for row in 0 ..< 3 {
                // If the cell is free
                if table[column][row] == .empty {
                    // We copy the table in which we will test
                    var copy = table.map {
                        $0.map {
                            $0 == Sign.empty ? Sign.empty : $0 == Sign.X ? Sign.X : Sign.O
                        }
                    }
                    copy[column][row] = sign
                    // And we get the result
                    let win = game.win(table: copy)
                    let score: Int
                    // If the table is full
                    if win == .empty && game.full(table: copy) {
                        score = 0
                    } else if win == sign {
                        // If it allows to win, score is 1
                        score = 1
                    } else {
                        // Else it is the opposite of the oponent best score (0 or -1)
                        score = 0 - bestMove(game: game, table: copy, sign: other).1
                    }
                    let result = ((column, row), score)
                    // if the score is 1 we return the result
                    if score == 1 {
                        return result
                    }
                    // Else we add the result in the array and we continue
                    moves.append(result)
                }
            }
        }
        // We suffle the moves
        moves.shuffle()
        return moves[0]
    }
}
