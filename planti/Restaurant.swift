//
//  Restaurant.swift
//  planti
//
//  Created by Zhiyi Yang on 2/16/19.
//  Copyright © 2019 planti. All rights reserved.
//

import Foundation

class Restaurant {
    var name: String?
    var latitude: Double
    var longitude: Double
    
    init() {
        name = ""
        latitude = 0
        longitude = 0
    }
    
    init(name: String?, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
