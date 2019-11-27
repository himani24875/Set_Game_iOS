//
//  Shape.swift
//  SetGame
//
//  Created by Himani on 25/11/19.
//  Copyright © 2019 Himani. All rights reserved.
//

import Foundation
import UIKit

enum Shape: Int {
    case square = 0, triangle, circle
    
    func getShape() -> String {
        switch self {
        case .square:
            return "■"
        case .circle:
            return "●"
        case .triangle:
            return "▲"
        }
    }
}

enum Shade: Int {
    case filled = 0, striped, outline
}

enum Color: Int {
    case red = 0, green, blue
        
    func getColor() -> UIColor {
        switch self {
        case .red:
            return UIColor.red
        case .blue:
            return UIColor.green
        case .green:
            return UIColor.blue
        }
    }
}

enum Quantity: Int {
    case one = 0, two, three
}





