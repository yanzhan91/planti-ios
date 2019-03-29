//
//  MenuItem.swift
//  planti
//
//  Created by Yan Zhan on 3/27/19.
//  Copyright © 2019 planti. All rights reserved.
//

class MenuItem {
    var name: String
    var entreeImage: String
    var containsLabel: String
    var posted: String
    
    init() {
        name = ""
        entreeImage = ""
        containsLabel = ""
        posted = ""
    }
    
    init(name: String, entreeImage: String, containsLabel:String, posted: String) {
        self.name = name
        self.entreeImage = entreeImage
        self.containsLabel = containsLabel
        self.posted = posted
    }
}
