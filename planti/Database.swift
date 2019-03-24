//
//  Database.swift
//  planti
//
//  Created by Zhiyi Yang on 2/16/19.
//  Copyright © 2019 planti. All rights reserved.
//

import Foundation

class Database {
    static func getRestaurants() -> [Restaurant] {
        return [
            Restaurant(name: "One", latitude: 41.882085, longitude: -87.640879, ratings: 4.3, numRatings: 1098),
            Restaurant(name: "Two", latitude: 41.881073300547996, longitude: -87.64162547155212, ratings: 3.2, numRatings: 14),
            Restaurant(name: "Three", latitude: 41.883012, longitude: -87.664991, ratings: 1.7, numRatings: 3002)
        ]
    }
}
