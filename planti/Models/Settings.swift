//
//  Settings.swift
//  planti
//
//  Created by Yan Zhan on 4/3/19.
//  Copyright © 2019 planti. All rights reserved.
//

import ObjectMapper

class Settings : Mappable {

    var newMenuItems: Bool = false
    var newPromotions: Bool = false
    
    required init?(map: Map) {
        
    }
    
    init() {
    }
    
    func mapping(map: Map) {
        self.newMenuItems <- map["newMenuItems"]
        self.newPromotions <- map["newPromotions"]
    }
    
    init(newMenuItems: Bool, newPromotions: Bool) {
        self.newMenuItems = newMenuItems
        self.newPromotions = newPromotions
    }
    
    public func toDictionary() -> Dictionary<String, Bool> {
        return ["newMenuItems": self.newMenuItems, "newPromotions": self.newPromotions]
    }
}
