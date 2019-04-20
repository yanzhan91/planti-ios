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
    var option: Int
    var containsLabel: String
    var posted: String
    
    init() {
        id = "757658675687"
        placeId = ""
        name = ""
        imageUrl = ""
        option = 8
        containsLabel = ""
        posted = ""
    }
    
    init(name: String, imageUrl: String, containsLabel:String, posted: String) {
        self.id = ""
        self.placeId = ""
        self.name = name
        self.imageUrl = imageUrl
        self.option = 8
        self.containsLabel = containsLabel
        self.posted = posted
    }
}
