//
//  Player.swift
//  TicTacToe
//
//  Created by Nilisha Gupta on 11/01/23.
//

import Foundation

class Player {
    // MARK: - Variable Declarations
    var sign: Sign
    
    init(sign: Sign) {
        self.sign = sign
    }
    
    func play(game: Game, completion: @escaping (Int, Int) -> ()) {
        completion(0, 0)
    }
}
