//
//  Database.swift
//  planti
//
//  Created by Zhiyi Yang on 2/16/19.
//  Copyright © 2019 planti. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class RestService {
    
    private static var restService = RestService()
    private final var scheme: String = "http"
    private final var host: String = "planti-env.er36yiu2yy.us-east-1.elasticbeanstalk.com"
    
    class func shared() -> RestService {
        return restService
    }
    
    public func postUser(option: Options?, settings: Settings?, lastKnownLocation: Location?) {
        
        let url = buildUrl(path: "/planti-api/ui/postUser", queries: [])
        
        var parameters : [String: Any] = [:]
        
        let uuid = UIDevice.current.identifierForVendor?.description
        if let deviceId = uuid {
            parameters["id"] = deviceId
        }
        
        if let option = option {
            parameters["option"] = option.number()
        }
        
        if let settings = settings {
            parameters["settings"] = settings.toDictionary()
        }
        
        if let lastKnownLocation = lastKnownLocation {
            parameters["latitude"] = lastKnownLocation.latitude
            parameters["longitude"] = lastKnownLocation.longitude
        }
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept": "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
        print("Rest: getRestaurants \(option) \(location.latitude) \(location.longitude) \(radius)")
        
        
        let url = buildUrl(path: "/planti-api/ui/getRestaurants", queries: [
            URLQueryItem(name: "option", value: String(option.number())),
            URLQueryItem(name: "latitude", value: String(location.latitude)),
            URLQueryItem(name: "longitude", value: String(location.longitude)),
            URLQueryItem(name: "radius", value: String(radius))
        ])
        
        Alamofire.request(url, method: .get, parameters: nil)
            .validate()
            .responseArray { (response: DataResponse<[Restaurant]>) in
                guard response.result.isSuccess, let value = response.result.value else {
                    print("Error: \(String(describing: response.result.error))")
                    completion([])
                    return
                }
                
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                print("Value: \(value)")
                
                completion(value)
        }
    }
    
    public func getMenuItems(option: Options, placeId: String, completion: @escaping ([MenuItem]) -> Void) {
        print("Rest: getting menu items \(option) \(placeId)")
        let url = buildUrl(path: "/planti-api/ui/getMenuItems/", queries: [
            URLQueryItem(name: "placeId", value: placeId), URLQueryItem(name: "option", value: String(option.number()))])
        Alamofire.request(url, method: .get)
            .validate()
            .responseArray { (response: DataResponse<[MenuItem]>) in
                guard response.result.isSuccess, let value = response.result.value else {
                    print("Error: \(String(describing: response.result.error))")
                    completion([])
                    return
                }
                
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                print("Value: \(value)")
                
                completion(value)
        }
    }
    
    public func postMenuItem(name: String, menuItemName: String, containsMeat: Bool,
                             containsDiary: Bool, containsEgg: Bool, completion: @escaping () -> Void) {
        print("Rest: posting menu item \(name) \(menuItemName)")
        let url = buildUrl(path: "/planti-api/ui/postMenuItem/", queries: [])
        
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
        
        Alamofire.request(url, method: .post, parameters: ["restaurantName": name,
                                                          "name": menuItemName,
                                                          "imageUrl": "",
                                                          "option": option], encoding: JSONEncoding.default)
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
    
    private func buildUrl(path: String, queries: [URLQueryItem]) -> URL {
        var url = URLComponents()
        url.scheme = self.scheme
        url.host = self.host
        url.path = path
        url.queryItems = queries
        return try! url.asURL()
    }
}
