//
//  Settings.swift
//  planti
//
//  Created by Yan Zhan on 4/3/19.
//  Copyright © 2019 planti. All rights reserved.
//

class Settings : Codable {
    var newMenuItems: Bool
    var newPromotions: Bool
    
    init() {
        newMenuItems = true
        newPromotions = true
    }
    
    init(newMenuItems: Bool, newPromotions: Bool) {
        self.newMenuItems = newMenuItems
        self.newPromotions = newPromotions
    }
    
    public func toDictionary() -> Dictionary<String, Bool> {
        return ["newMenuItems": self.newMenuItems, "newPromotions": self.newPromotions]
    }
}
