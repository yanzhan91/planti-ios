//
//  MenuItem.swift
//  planti
//
//  Created by Yan Zhan on 3/27/19.
//  Copyright © 2019 planti. All rights reserved.
//

import ObjectMapper

class MenuItem : Mappable {
    var id: String?
    var placeId: String?
    var name: String?
    var imageUrl: String?
    var option: Int = 0
    var containsLabel: String?
    var posted: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        placeId <- map["placeId"]
        name <- map["name"]
        imageUrl <- map["imageUrl"]
        option <- map["option"]
        containsLabel <- map["containsLabel"]
        posted <- map["posted"]
    }
}
