//
//  DefaultsKeys.swift
//  planti
//
//  Created by Zhiyi Yang on 3/2/19.
//  Copyright © 2019 planti. All rights reserved.
//

import Foundation

class DefaultsKeys {
    static let PREFERENCE = "preference"
    static let LAST_KNOWN_LOCATION_LATITUDE = "lastKnownLocationLatitude"
    static let LAST_KNOWN_LOCATION_LONGITUDE = "lastKnownLocationLongitude"
    
    static func setEncodedUserDefaults<T>(key: String, value: T) where T: Codable {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: key)
    }
    
    static func getEncodedUserDefaults<T>(key: String, defaultValue: T) -> T where T: Codable {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
            return defaultValue
        }
        
        // Use PropertyListDecoder to convert Data into Player
        guard let value = try? PropertyListDecoder().decode(T.self, from: data) else {
            return defaultValue
        }
        
        return value
    }
}
