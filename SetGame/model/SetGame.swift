//
//  SetGame.swift
//  SetGame
//
//  Created by Himani on 22/11/19.
//  Copyright © 2019 Himani. All rights reserved.
//

import Foundation

struct SetGame {
    private(set) var cards = [Card]()
    private(set) var matchedCards = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var currentSelectionIsMatch: Bool?
    var score = 0
    private var indicesOfMatchedCards = [Int]()
    
    var hintCard = [Int]()
    
    private(set) var board = [Card]() {
        didSet {
            assert(board.count <= 24, "Set.board: board cannot contain more than 24 cards")
        }
    }
    
    init() {
        cards = createDeck()
        var shuffled = [Card]()
        
        for _ in cards.indices {
            let randomNo = cards.count.arc4Random
            shuffled.append(cards.remove(at: randomNo))
        }
        
        cards = shuffled
        dealCards(noOfCards: 12)
    }
    
    func canDealMoreCards() -> Bool {
        let matchesThatCanBeRemoved = board.filter { matchedCards.contains($0) }
        let occupiedSpacesOnBoard = board.count - matchesThatCanBeRemoved.count
        let freeSpacesOnBoard = 24 - occupiedSpacesOnBoard
        let cardsRemaining = cards.count
        
        return cardsRemaining != 0 && freeSpacesOnBoard >= 3
    }
    
    mutating func chooseCard(index: Int) {
        if index > board.count - 1 {
            return
        }
        let chosenCard = board[index]
        if matchedCards.contains(chosenCard) {
            return
        }
        
        if selectedCards.contains(chosenCard) {
            score -= 1
            selectedCards.remove(at: selectedCards.firstIndex(of: chosenCard)!)
        } else {
            if !matchedCards.contains(chosenCard) {
                selectedCards.append(chosenCard)
            }
        }
        
        if selectedCards.count == 3 {
            if doesMakeSet(selectedCard: selectedCards) {
                score += 3
                currentSelectionIsMatch = true
                for card in selectedCards {
                    if let index = board.firstIndex(of: card) {
                        indicesOfMatchedCards.append(index)
                    }
                }
                matchedCards += selectedCards
                selectedCards = []
                dealCards()
            } else {
                currentSelectionIsMatch = false
                score -= 5
            }
        } else if selectedCards.count > 3 {
            selectedCards = []
            selectedCards.append(chosenCard)
        } else {
            currentSelectionIsMatch = nil
        }
    }
    
    mutating func dealCards(noOfCards: Int = 3) {
//        if noOfCards + board.count > 24 {
//            board = board.filter {
//                !matchedCards.contains($0)
//            }
//        }
        if cards.count >= noOfCards {
            if indicesOfMatchedCards.count > 0 {
                for index in indicesOfMatchedCards {
                    board[index] = cards.remove(at: cards.startIndex)
                }
                
                indicesOfMatchedCards = []
            } else {
                let range = 0..<noOfCards
                board.append(contentsOf: cards[range])
                cards.removeSubrange(range)
            }
        }
    }
    
    mutating func createDeck() -> [Card] {
        var newDeck = [Card]()
        
        for i in 0..<81 {
            var ar = Array(String(i, radix: 3))
            let shape = ar.count > 3 ? Shape(rawValue: Int(String(ar.remove(at: 0)))!) : Shape(rawValue: 0)
            let quantity = ar.count > 2 ? Quantity(rawValue: Int(String(ar.remove(at: 0)))!) : Quantity(rawValue: 0)
            let color = ar.count > 1 ? Color(rawValue: Int(String(ar.remove(at: 0)))!) : Color(rawValue: 0)
            let shade = ar.count > 0 ? Shade(rawValue: Int(String(ar.remove(at: 0)))!) : Shade(rawValue: 0)
            
            let card = Card(shape: shape!, noOfItems: quantity!, color: color!, shading: shade!)
//            print(card.shape, card.noOfItems, card.color, card.shading)
            newDeck.append(card)
        }
        
        return newDeck
    }
    
    private func doesMakeSet(selectedCard: [Card]) -> Bool {
        let color = Set(selectedCard.map{ $0.color }).count
        let shape = Set(selectedCard.map{ $0.shape }).count
        let number = Set(selectedCard.map{ $0.noOfItems }).count
        let fill = Set(selectedCard.map{ $0.shading }).count
        
        return color != 2 && shape != 2 && number != 2 && fill != 2
    }
    
    mutating func hint() {
        hintCard.removeAll()
        for i in 0..<board.count {
            for j in (i + 1)..<board.count {
                for k in (j + 1)..<board.count {
                    let hints = [board[i], board[j], board[k]]
                    if doesMakeSet(selectedCard: hints) {
                        hintCard += [i, j, k]
                    }
                }
            }
        }
    }
}

extension Int {
    var arc4Random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self - 1)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self - 1))))
        } else {
            return 0
        }
    }
}
