//
//  Database.swift
//  planti
//
//  Created by Zhiyi Yang on 2/16/19.
//  Copyright © 2019 planti. All rights reserved.
//

import Foundation
import Alamofire

class RestService {
    
    private static var restService = RestService()
    private var baseUrl: String = ""
    
    class func shared() -> RestService {
        return restService
    }
    
    public func postUser(option: Options?, settings: Settings?, lastKnownLocation: Location?) {
        guard let url = URL(string: "\(self.baseUrl)/postUser") else {
            return
        }

        var parameters : [String: Any] = [:]
        
        let uuid = UIDevice.current.identifierForVendor?.uuid
        if let deviceId = uuid {
            parameters["id"] = deviceId
        }
        
        if let option = option {
            parameters["option"] = option.number()
        }
        
        if let settings = settings {
            parameters["settings"] = settings
        }
        
        if let lastKnownLocation = lastKnownLocation {
            parameters["lastKnownLocation"] = lastKnownLocation
        }
        
        Alamofire.request(url, method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess, let value = response.result.value else {
                    print("Error: \(String(describing: response.result.error))")
                    return
                }
                
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                print("Value: \(value)")
        }
    }
    
    public func getRestaurants(option: Options, location: Location, radius: Int,
                               completion: @escaping ([Restaurant]) -> Void) {
        print("Rest: getRestaurants \(option) \(location) \(radius)")
        guard let url = URL(string: "\(self.baseUrl)/getRestaurants/\(option.number())/\(location.latitude)/\(location.longitude)\(radius)/") else {
            completion(self.getTestRestaurants())
            return
        }
        Alamofire.request(url, method: .get, parameters: ["option": option.rawValue,
                                                          "location": location,
                                                          "distance": radius])
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess, let value = response.result.value else {
                    print("Error: \(String(describing: response.result.error))")
                    completion([])
                    return
                }
                
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                print("Value: \(value)")
                
                completion(self.getTestRestaurants())
        }
    }
    
    public func getMenuItems(option: Options, placeId: String, completion: @escaping ([MenuItem]) -> Void) {
        print("Rest: getting menu items \(option) \(placeId)")
        guard let url = URL(string: "\(self.baseUrl)/getMenuItems/\(placeId)/\(option.number())") else {
            completion(self.getTestMenuItems())
            return
        }
        Alamofire.request(url, method: .get, parameters: ["placeId": placeId, "option": 1])
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess, let value = response.result.value else {
                    print("Error: \(String(describing: response.result.error))")
                    completion([])
                    return
                }
                
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                print("Value: \(value)")
                
                completion(self.getTestMenuItems())
        }
    }
    
    public func postMenuItem(placeId: String, menuItemName: String, containsMeat: Bool,
                             containsDiary: Bool, containsEgg: Bool, completion: @escaping () -> Void) {
        print("Rest: posting menu item \(placeId) \(menuItemName)")
        guard let url = URL(string: "\(self.baseUrl)/postMenuItem/") else {
            completion()
            return
        }
        
        var option: Int = 8
        if (containsMeat) {
            return
        } else {
            if (containsEgg && containsDiary) {
                option = 1
            } else if (containsEgg) {
                option = 3
            } else if (containsDiary) {
                option = 5
            }
        }
        
        Alamofire.request(url, method: .get, parameters: ["placeId": placeId,
                                                          "name": menuItemName,
                                                          "imageUrl": "",
                                                          "option": option])
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess, let value = response.result.value else {
                    print("Error: \(String(describing: response.result.error))")
                    completion()
                    return
                }
                
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                print("Value: \(value)")
                
                completion()
        }
    }
    
    public func reportError(id: String) {
        print("Rest: reporting error \(id)")
        guard let url = URL(string: "") else {
            return
        }
        Alamofire.request(url, method: .post, parameters: ["id": id])
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess, let value = response.result.value else {
                    print("Error: \(String(describing: response.result.error))")
                    return
                }
                
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                print("Value: \(value)")
        }
    }
    
    private func getTestRestaurants() -> [Restaurant] {
        return [
            Restaurant(name: "One", imageUrl: "https://images.sftcdn.net/images/t_app-logo-l,f_auto,dpr_auto/p/a00b5514-9b26-11e6-8ccf-00163ec9f5fa/4091407790/restaurant-story-logo.png",
                       latitude: 41.882085, longitude: -87.640879, ratings: 4.3, numRatings: 1098),
            Restaurant(name: "Two", imageUrl: "https://images.sftcdn.net/images/t_app-logo-l,f_auto,dpr_auto/p/a00b5514-9b26-11e6-8ccf-00163ec9f5fa/4091407790/restaurant-story-logo.png",
                       latitude: 41.881073300547996, longitude: -87.64162547155212, ratings: 3.2, numRatings: 14),
            Restaurant(name: "Three", imageUrl: "https://images.sftcdn.net/images/t_app-logo-l,f_auto,dpr_auto/p/a00b5514-9b26-11e6-8ccf-00163ec9f5fa/4091407790/restaurant-story-logo.png",
                       latitude: 41.883012, longitude: -87.644991, ratings: 1.7, numRatings: 3002)
        ]
    }
    
    private func getTestMenuItems() -> [MenuItem] {
        var menuItems: [MenuItem] = []
        for i in 1...Int.random(in: 1...5) {
            menuItems.append(MenuItem(name: String(i), imageUrl: "https://images.sftcdn.net/images/t_app-logo-l,f_auto,dpr_auto/p/a00b5514-9b26-11e6-8ccf-00163ec9f5fa/4091407790/restaurant-story-logo.png",
                                      containsLabel: "Contains: egg, fish", posted: "02/26/2019 Posted by user"))
        }
        return menuItems
    }
}
