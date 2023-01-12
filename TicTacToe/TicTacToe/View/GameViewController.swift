//
//  NotificationExtension.swift
//  TicTacToe
//
//  Created by Nilisha Gupta on 11/01/23.
//

import UIKit

class GameViewController: UIViewController {
    // MARK: - Variable Declarations
    var game: Game?
    let box1 = UIImageView()
    let box2 = UIImageView()
    let box3 = UIImageView()
    let box4 = UIImageView()
    let box5 = UIImageView()
    let box6 = UIImageView()
    let box7 = UIImageView()
    let box8 = UIImageView()
    let box9 = UIImageView()
    let instructionLabel = UILabel()
    let playAgainButton = UIButton()
    
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
    
    @objc func again(_ sender: UIButton) {
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
            box.layer.borderWidth = 1
        }
        
        // Add elements to view
        view.addSubview(box1)
        view.addSubview(box2)
        view.addSubview(box3)
        view.addSubview(box4)
        view.addSubview(box5)
        view.addSubview(box6)
        view.addSubview(box7)
        view.addSubview(box8)
        view.addSubview(box9)
        view.addSubview(instructionLabel)
        view.addSubview(playAgainButton)
        
        // Setup box 1
        box1.translatesAutoresizingMaskIntoConstraints = false
        box1.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box1.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box1.rightAnchor.constraint(equalTo: box2.leftAnchor).isActive = true
        box1.bottomAnchor.constraint(equalTo: box4.topAnchor).isActive = true
        box1.tag = 0
        box1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickOnImage(_:))))
        box1.isUserInteractionEnabled = true
        
        // Setup box 2
        box2.translatesAutoresizingMaskIntoConstraints = false
        box2.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box2.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box2.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
        box2.bottomAnchor.constraint(equalTo: box5.topAnchor).isActive = true
        box2.tag = 1
        box2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickOnImage(_:))))
        box2.isUserInteractionEnabled = true
        
        // Setup box 3
        box3.translatesAutoresizingMaskIntoConstraints = false
        box3.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box3.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box3.leftAnchor.constraint(equalTo: box2.rightAnchor).isActive = true
        box3.bottomAnchor.constraint(equalTo: box6.topAnchor).isActive = true
        box3.tag = 2
        box3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickOnImage(_:))))
        box3.isUserInteractionEnabled = true
        
        // Setup box 4
        box4.translatesAutoresizingMaskIntoConstraints = false
        box4.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box4.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box4.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor, constant: -20).isActive = true
        box4.rightAnchor.constraint(equalTo: box5.leftAnchor).isActive = true
        box4.tag = 3
        box4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickOnImage(_:))))
        box4.isUserInteractionEnabled = true
        
        // Setup box 5
        box5.translatesAutoresizingMaskIntoConstraints = false
        box5.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box5.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box5.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
        box5.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor, constant: -20).isActive = true
        box5.tag = 4
        box5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickOnImage(_:))))
        box5.isUserInteractionEnabled = true
        
        // Setup box 6
        box6.translatesAutoresizingMaskIntoConstraints = false
        box6.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box6.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box6.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor, constant: -20).isActive = true
        box6.leftAnchor.constraint(equalTo: box5.rightAnchor).isActive = true
        box6.tag = 5
        box6.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickOnImage(_:))))
        box6.isUserInteractionEnabled = true
        
        // Setup box 7
        box7.translatesAutoresizingMaskIntoConstraints = false
        box7.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box7.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box7.rightAnchor.constraint(equalTo: box8.leftAnchor).isActive = true
        box7.topAnchor.constraint(equalTo: box4.bottomAnchor).isActive = true
        box7.tag = 6
        box7.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickOnImage(_:))))
        box7.isUserInteractionEnabled = true
        
        // Setup box 8
        box8.translatesAutoresizingMaskIntoConstraints = false
        box8.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box8.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box8.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
        box8.topAnchor.constraint(equalTo: box5.bottomAnchor).isActive = true
        box8.tag = 7
        box8.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickOnImage(_:))))
        box8.isUserInteractionEnabled = true
        
        // Setup box 9
        box9.translatesAutoresizingMaskIntoConstraints = false
        box9.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box9.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1/3).isActive = true
        box9.leftAnchor.constraint(equalTo: box8.rightAnchor).isActive = true
        box9.topAnchor.constraint(equalTo: box6.bottomAnchor).isActive = true
        box9.tag = 8
        box9.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickOnImage(_:))))
        box9.isUserInteractionEnabled = true
        
        // Setup infos
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
        instructionLabel.bottomAnchor.constraint(equalTo: box2.topAnchor, constant: -30).isActive = true
        instructionLabel.font = UIFont.boldSystemFont(ofSize: 26)
        instructionLabel.numberOfLines = 2
        instructionLabel.textAlignment = .center
        instructionLabel.adjustsFontSizeToFitWidth = true
        
        // Setup again
        playAgainButton.translatesAutoresizingMaskIntoConstraints = false
        playAgainButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
        playAgainButton.topAnchor.constraint(equalTo: box8.bottomAnchor, constant: 30).isActive = true
        playAgainButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        playAgainButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playAgainButton.layer.cornerRadius = 4
        playAgainButton.clipsToBounds = true
        playAgainButton.setTitle("Play again", for: .normal)
        playAgainButton.setTitleColor(.white, for: .normal)
        playAgainButton.backgroundColor = .black
        playAgainButton.addTarget(self, action: #selector(again(_:)), for: .touchUpInside)
        
        // Load the empty grid
        updateUI()
    }
    
    private func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let uSelf = self else { return }
            // Update infos label
            if let game = uSelf.game {
                if game.currentPlayerSign != .empty {
                    // Get the player object
                    var current: Player?
                    for player in [game.player1, game.player2] {
                        if player.sign == game.currentPlayerSign {
                            current = player
                        }
                    }
                    // Differentiate human and computer in text
                    if current as? Computer != nil {
                        uSelf.instructionLabel.text = "Computer Turn"
                    } else {
                        uSelf.instructionLabel.text = "Your Turn"
                    }
                    uSelf.playAgainButton.isHidden = true
                } else {
                    // Game has ended
                    let winnerSign = game.win(table: game.table)
                    var current: Player?
                    for player in [game.player1, game.player2] {
                        if player.sign == winnerSign {
                            current = player
                        }
                    }
                    // Differentiate human and computer in text
                    if current as? Computer != nil {
                        uSelf.instructionLabel.text =  "Game has ended!\nWinner: Computer \(winnerSign)"
                    } else if current as? Human != nil {
                        uSelf.instructionLabel.text = "Game has ended!\nWinner: Player \(winnerSign)"
                    } else {
                        uSelf.instructionLabel.text = "Game has ended!\nIt's a tie"
                    }
                    uSelf.playAgainButton.isHidden = false
                }
                
                // Update images
                let boxes = [[uSelf.box1, uSelf.box4, uSelf.box7], [uSelf.box2, uSelf.box5, uSelf.box8], [uSelf.box3, uSelf.box6, uSelf.box9]]
                
                for row in 0 ..< 3 {
                    for column in 0 ..< 3 {
                        let box = boxes[row][column]
                        let sign = game.table[row][column]
                        if sign != .empty {
                            box.image = UIImage(named: sign == .X ? "x" : "o")
                        } else {
                            box.image = nil
                        }
                    }
                }
            }
        }
    }
}
