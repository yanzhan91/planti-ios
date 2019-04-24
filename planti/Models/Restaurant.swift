//
//  Restaurant.swift
//  planti
//
//  Created by Zhiyi Yang on 2/16/19.
//  Copyright © 2019 planti. All rights reserved.
//

import Foundation
import ObjectMapper

class Restaurant: Mappable {
    
    var placeId: String?
    var name: String?
    var address: String?
    var rating: Float = 0.0
    var numRatings: Int = 0
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var distance: Float = 0.0
    var imageUrl : String?
    var option : Int = 0
    
    required init?(map: Map) {

    }
    
    func mapping(map: Map) {
        placeId <- map["placeId"]
        name <- map["name"]
        address <- map["address"]
        imageUrl <- map["imageUrl"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        rating <- map["rating"]
        numRatings <- map["numRatings"]
        distance <- map["distance"]
        option <- map["option"]
    }
}
