//
//  Location.swift
//  planti
//
//  Created by Yan Zhan on 4/3/19.
//  Copyright © 2019 planti. All rights reserved.
//

class Location : Codable {
    var latitude: Double
    var longitude: Double
    
    init() {
        self.latitude = 0
        self.longitude = 0
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude;
        self.longitude = longitude;
    }
}
