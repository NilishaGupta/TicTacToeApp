//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Nilisha Gupta on 11/01/23.
//

import UIKit

class GameViewController: UIViewController {
    // MARK: - Outlets Declaration
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var box1: UIImageView!
    @IBOutlet weak var box2: UIImageView!
    @IBOutlet weak var box3: UIImageView!
    @IBOutlet weak var box4: UIImageView!
    @IBOutlet weak var box5: UIImageView!
    @IBOutlet weak var box6: UIImageView!
    @IBOutlet weak var box7: UIImageView!
    @IBOutlet weak var box8: UIImageView!
    @IBOutlet weak var box9: UIImageView!
    @IBOutlet weak var playAgainButton: UIButton!
    
    // MARK: - Variable Declarations
    var game: Game?
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let players = [Computer(sign: .X), Human(sign: .O)].shuffled()
        game = Game(player1: players[0], player2: players[1])
        // Register for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(boardChanged(_:)), name: .boardChanged, object: nil)
        setupUI()
        // Everything is up, start the game
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let uSelf = self else { return }
            uSelf.game?.nextMove()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .boardChanged, object: nil)
    }
    
    // MARK: - Action Methods
    @objc func boardChanged(_ sender: Any) {
        updateUI()
    }
    
    @objc func clickOnImage(_ sender: UITapGestureRecognizer) {
        // Iterate the players
        for player in [game?.player1, game?.player2] {
            // Check if it's a human, and the current player
            if let human = player as? Human, game?.currentPlayerSign == human.sign, let img = sender.view as? UIImageView {
                // Determine the location
                let columnIndex = img.tag % 3
                let rowIndex = img.tag / 3
                // Play!
                DispatchQueue.global(qos: .background).async {
                    human.completion?(columnIndex, rowIndex)
                }
            }
        }
    }
    
    @IBAction func btnPlayAgainTapped(_ sender: UIButton) {
        // Create a new game with same players
        self.game = Game(player1: game?.player1 ?? Player(sign: .empty), player2: game?.player2 ?? Player(sign: .empty))
        updateUI()
        // Start game
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let uSelf = self else { return }
            uSelf.game?.nextMove()
        }
    }
}

// MARK: - UI setup methods
extension GameViewController {
    private func setupUI() {
        for box in [box1, box2, box3, box4, box5, box6, box7, box8, box9] {
            box?.layer.borderWidth = 2
            box?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickOnImage(_:))))
        }
        // Load the empty grid
        updateUI()
    }
    
    private func getPlayer(winnerSign: Sign = .empty) -> Player? {
        for player in [game?.player1, game?.player2] {
            if player?.sign == game?.currentPlayerSign || player?.sign == winnerSign {
                return player
            }
        }
        return nil
    }
    
    private func updateInstrutionUI(isGameNotEnded: Bool, currentPlayer: Player?, winnerSign: Sign = .empty) {
        // Differentiate human and computer in text
        if currentPlayer as? Computer != nil {
            instructionLabel.text = isGameNotEnded ? "Computer Turn" : "Game has ended!\nWinner: Computer \(winnerSign)"
        } else if currentPlayer as? Human != nil {
            instructionLabel.text = isGameNotEnded ? "Your Turn" : "Game has ended!\nWinner: Player \(winnerSign)"
        } else {
            instructionLabel.text = isGameNotEnded ? "Your Turn" : "Game has ended!\nIt's a tie"
        }
        playAgainButton.isHidden = isGameNotEnded
        
    }
    
    private func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let uSelf = self else { return }
            // Update infos label
            if let game = uSelf.game {
                if game.currentPlayerSign != .empty {
                    // Get the player object and update text
                    let current = uSelf.getPlayer()
                    uSelf.updateInstrutionUI(isGameNotEnded: true, currentPlayer: current)
                } else {
                    // Game has ended
                    let winnerSign = game.win(table: game.table)
                    // Get the player object and update text
                    let current = uSelf.getPlayer(winnerSign: winnerSign)
                    uSelf.updateInstrutionUI(isGameNotEnded: false, currentPlayer: current, winnerSign: winnerSign)
                }
                // Update images
                let boxes = [[uSelf.box1, uSelf.box4, uSelf.box7], [uSelf.box2, uSelf.box5, uSelf.box8], [uSelf.box3, uSelf.box6, uSelf.box9]]
                for row in 0 ..< 3 {
                    for column in 0 ..< 3 {
                        let box = boxes[row][column]
                        let sign = game.table[row][column]
                        if sign != .empty {
                            box?.image = UIImage(named: sign == .X ? "x" : "o")
                        } else {
                            box?.image = nil
                        }
                    }
                }
            }
        }
    }
}
