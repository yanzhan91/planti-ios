//
//  Restaurant.swift
//  planti
//
//  Created by Zhiyi Yang on 2/16/19.
//  Copyright © 2019 planti. All rights reserved.
//

import Foundation

class Restaurant {
    var placeId: String
    var name: String
    var address: String
    var rating: Float
    var numRatings: Int
    var latitude: Double
    var longitude: Double
    var distance: Float
    var imageUrl : String
    
    init() {
        placeId = ""
        name = ""
        address = ""
        imageUrl = ""
        latitude = 0
        longitude = 0
        rating = 0
        numRatings = 0
        distance = -1
    }
    
    init(name: String, imageUrl: String, latitude: Double, longitude: Double, ratings: Float, numRatings: Int) {
        self.placeId = ""
        self.name = name
        self.address = ""
        self.imageUrl = imageUrl
        self.latitude = latitude
        self.longitude = longitude
        self.rating = ratings
        self.numRatings = numRatings
        self.distance = -1
    }
}
