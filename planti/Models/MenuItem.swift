//
//  MenuItem.swift
//  planti
//
//  Created by Yan Zhan on 3/27/19.
//  Copyright © 2019 planti. All rights reserved.
//

class MenuItem {
    var id: String
    var placeId: String
    var name: String
    var imageUrl: String
    var containsLabel: String
    var posted: String
    
    init() {
        id = ""
        placeId = ""
        name = ""
        imageUrl = ""
        containsLabel = ""
        posted = ""
    }
    
    init(name: String, imageUrl: String, containsLabel:String, posted: String) {
        self.id = ""
        self.placeId = ""
        self.name = name
        self.imageUrl = imageUrl
        self.containsLabel = containsLabel
        self.posted = posted
    }
}
