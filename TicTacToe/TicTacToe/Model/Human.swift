//
//  Human.swift
//  TicTacToe
//
//  Created by Nilisha Gupta on 11/01/23.
//

import Foundation

class Human: Player {
    // MARK: - Variable Declarations
    var completion: ((Int, Int) -> ())?
    
    // Override player play function
    override func play(game: Game, completion: @escaping (Int, Int) -> ()) {
        self.completion = completion
    }
}
