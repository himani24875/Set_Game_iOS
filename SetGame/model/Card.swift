//
//  Card.swift
//  SetGame
//
//  Created by Himani on 22/11/19.
//  Copyright © 2019 Himani. All rights reserved.
//

import Foundation

struct Card {
    var shape: Shape
    var noOfItems: Quantity
    var color: Color
    var shading: Shade
}

extension Card: Hashable {

    static func ==(lhs: Card, rhs: Card) -> Bool {
        return (lhs.noOfItems == rhs.noOfItems && lhs.shape == rhs.shape && lhs.shading == rhs.shading && lhs.color == rhs.color )
    }
}
