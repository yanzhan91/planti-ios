//
//  Options.swift
//  planti
//
//  Created by Zhiyi Yang on 2/19/19.
//  Copyright © 2019 planti. All rights reserved.
//

enum Options : String, CaseIterable {
    case vegan = "Vegan"
    case ovoVegetarian = "Ovo-Vegetarian"
    case lactoVegetarian = "Lacto-Vegetarian"
    case lactoOvoVegetarian = "Lacto-Ovo Vegetarian"
    
    public func number() -> Int {
        switch self {
        case .vegan:
            return 1
        case .lactoVegetarian:
            return 2
        case .ovoVegetarian:
            return 3
        case .lactoOvoVegetarian:
            return 4
        }
    }
}
