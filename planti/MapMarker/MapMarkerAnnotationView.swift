//
//  MapMarkerAnnotationView.swift
//  planti
//
//  Created by Yan Zhan on 5/20/19.
//  Copyright © 2019 planti. All rights reserved.
//

import MapKit

class MapMarkerAnnotationView: MKMarkerAnnotationView {

    // data
    weak var customCalloutView: MapMarker?
    
    var name: String?
    var numRatings: Int = 0
    var ratings: Float = 0
    var restaurantImage: UIImage?
    
    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    
    // MARK: - life cycle
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = true // 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = true // 1
    }
    
    // MARK: - callout showing and hiding
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected { // 2
            self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)
            
            if let newCustomCalloutView = loadPersonDetailMapView() {
                // fix location from top-left to its right place.
                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
                
                // set custom callout view
                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView
            }
        } else { // 3
            if customCalloutView != nil {
                self.customCalloutView!.removeFromSuperview()
            }
        }
    }
    
    private func loadPersonDetailMapView() -> MapMarker? { // 4
        let view = MapMarker(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        view.image.image = self.restaurantImage
        view.restaurantName.text = self.name
        view.ratingsView.numReviews.text = String(self.numRatings)
        view.ratingsView.setRatings(ratings: self.ratings)
        return view
    }
    
    override func prepareForReuse() { // 5
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
}
