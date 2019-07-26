//
//  MenuItem.swift
//  planti
//
//  Created by Yan Zhan on 3/27/19.
//  Copyright © 2019 planti. All rights reserved.
//

import ObjectMapper

class MenuItem : Mappable {
    
    var id: String = ""
    var chainId: String?
    var menuItemName: String?
    var containsLabel: String?
    var postedBy: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        chainId <- map["chainId"]
        menuItemName <- map["menuItemName"]
        containsLabel <- map["containsLabel"]
        postedBy <- map["postedBy"]
    }
    
    public func getImageUrl() -> String {
        return "\(DefaultsKeys.S3_URL)menuItems/\(id).jpeg"
    }
}
