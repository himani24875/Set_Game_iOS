//
//  ViewController.swift
//  SetGame
//
//  Created by Himani on 22/11/19.
//  Copyright © 2019 Himani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game = SetGame()
            
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var deal3MoreCardsLabel: UIButton!
    @IBOutlet weak var gameScoreLabel: UILabel!
    @IBOutlet weak var setMatchStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
        
    private func updateViewFromModel() {
        
        gameScoreLabel.text = "Your Score is: \(game.score)"
        
        if let isMatch = game.currentSelectionIsMatch {
            setMatchStatusLabel.text = isMatch ? "It's a Match!!" : "Not a Match"
        } else {
            setMatchStatusLabel.text = ""
        }
        
        cardButtons.forEach {
            $0.hide()
        }
       
        for index in game.board.indices {
            let card = game.board[index]
            let text = getAttributedString(for: card)
            cardButtons[index].setAttributedTitle(text, for: .normal)
            cardButtons[index].isEnabled = true
            if game.selectedCards.contains(card) {
                cardButtons[index].layer.backgroundColor = UIColor.yellow.cgColor
            } else if game.matchedCards.contains(card) {
                cardButtons[index].hide()
            } else {
                showCard(at: index)
            }
        }
        deal3MoreCardsLabel.isUserInteractionEnabled = game.canDealMoreCards()
        deal3MoreCardsLabel.layer.backgroundColor = game.canDealMoreCards() ? UIColor.purple.cgColor : UIColor.systemGray.cgColor
    }
    
    private func getAttributedString(for card: Card) -> NSAttributedString {
        let symbol = card.shape.getShape()
        let text = String(repeating: symbol, count: card.noOfItems.rawValue + 1)
        let color = card.color.getColor()
        
        var attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: -3,
            .foregroundColor: color,
            .strokeColor: color
        ]
        
        switch card.shading {
        case .filled:
            break
        case .striped:
            attributes[.foregroundColor] = color.withAlphaComponent(0.25)
        case .outline:
            attributes[.foregroundColor] = color.withAlphaComponent(0)
            attributes[.strokeWidth] = 3
        }
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    private func showCard(at index: Int) {
        cardButtons[index].layer.backgroundColor = UIColor.clear.cgColor
        cardButtons[index].layer.borderWidth = 1.0
        cardButtons[index].layer.borderColor = UIColor.orange.cgColor
        cardButtons[index].layer.cornerRadius = 8.0
        
        cardButtons[index].isEnabled = true
    }
    
    //MARK:- BUTTON ACTION
    @IBAction func deal3MoreCards(_ sender: Any) {
        game.dealCards(noOfCards: 3)
        updateViewFromModel()
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        game = SetGame()
        updateViewFromModel()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let index = cardButtons.firstIndex(of: sender) {
            game.chooseCard(index: index)
            updateViewFromModel()
        }
    }
}

extension UIButton {
    func hide() {
        self.layer.backgroundColor = UIColor.white.cgColor
        self.setTitle(nil, for: .normal)
        self.setAttributedTitle(nil, for: .normal)
        self.layer.borderWidth = 0.0
        self.isEnabled = false
    }
}

