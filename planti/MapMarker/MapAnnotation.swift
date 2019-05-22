//
//  MapAnnotation.swift
//  planti
//
//  Created by Yan Zhan on 5/21/19.
//  Copyright © 2019 planti. All rights reserved.
//

import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    var index: Int = 0
    var name: String?
    var ratings: Float = 0
    var numRatings: Int = 0
    var image: UIImage?
    var coordinate: CLLocationCoordinate2D
    
    init(index: Int, name: String, ratings: Float, numRatings: Int, image: UIImage, coordinate: CLLocationCoordinate2D) {
        self.index = index
        self.name = name
        self.ratings = ratings
        self.numRatings = numRatings
        self.image = image
        self.coordinate = coordinate
        super.init()
    }
}
