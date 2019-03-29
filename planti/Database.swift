//
//  Database.swift
//  planti
//
//  Created by Zhiyi Yang on 2/16/19.
//  Copyright © 2019 planti. All rights reserved.
//

import Foundation
import Alamofire

class Database {
    
    private static var database = Database()
    
    class func shared() -> Database {
        return database
    }
    
    public func getRestaurants(option: Options, completion: @escaping ([Restaurant]) -> Void) {
        guard let url = URL(string: "") else {
            completion(self.getTestRestaurants())
            return
        }
        Alamofire.request(url, method: .get, parameters: ["option": 1])
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
        guard let url = URL(string: "") else {
            completion(self.getTestMenuItems())
            return
        }
        Alamofire.request(url, method: .get, parameters: ["option": 1])
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
    
    private func getTestRestaurants() -> [Restaurant] {
        return [
            Restaurant(name: "One", image: "https://images.sftcdn.net/images/t_app-logo-l,f_auto,dpr_auto/p/a00b5514-9b26-11e6-8ccf-00163ec9f5fa/4091407790/restaurant-story-logo.png",
                       latitude: 41.882085, longitude: -87.640879, ratings: 4.3, numRatings: 1098),
            Restaurant(name: "Two", image: "https://images.sftcdn.net/images/t_app-logo-l,f_auto,dpr_auto/p/a00b5514-9b26-11e6-8ccf-00163ec9f5fa/4091407790/restaurant-story-logo.png",
                       latitude: 41.881073300547996, longitude: -87.64162547155212, ratings: 3.2, numRatings: 14),
            Restaurant(name: "Three", image: "https://images.sftcdn.net/images/t_app-logo-l,f_auto,dpr_auto/p/a00b5514-9b26-11e6-8ccf-00163ec9f5fa/4091407790/restaurant-story-logo.png",
                       latitude: 41.883012, longitude: -87.644991, ratings: 1.7, numRatings: 3002)
        ]
    }
    
    private func getTestMenuItems() -> [MenuItem] {
        var menuItems: [MenuItem] = []
        for i in 1...Int.random(in: 1...5) {
            menuItems.append(MenuItem(name: String(i), entreeImage: "https://images.sftcdn.net/images/t_app-logo-l,f_auto,dpr_auto/p/a00b5514-9b26-11e6-8ccf-00163ec9f5fa/4091407790/restaurant-story-logo.png",
                                      containsLabel: "Contains: egg, fish", posted: "02/26/2019 Posted by user"))
        }
        return menuItems
    }
}
