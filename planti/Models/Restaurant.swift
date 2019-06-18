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
    
    var id: String?
    var chainId: String = ""
    var restaurantName: String?
    var address: String?
    var rating: Float = 0.0
    var numRatings: Int = 0
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var distance: Float = 0.0
    
    required init?(map: Map) {

    }
    
    init() {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        chainId <- map["chainId"]
        restaurantName <- map["restaurantName"]
        address <- map["address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        rating <- map["rating"]
        numRatings <- map["numRatings"]
        distance <- map["distance"]
    }
    
    public func getImageUrl() -> String {
        return "\(DefaultsKeys.S3_URL)\(chainId).jpeg"
    }
}
