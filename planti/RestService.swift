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
import MapKit

class RestService {
    
    private static var restService = RestService()
    private final var scheme: String = "http"
    private final var host: String = "planti-env.er36yiu2yy.us-east-1.elasticbeanstalk.com"
    
    class func shared() -> RestService {
        return restService
    }
    
    public func getSettings(completion: @escaping (Settings) -> Void) {
        
        var queries: [URLQueryItem] = []
        
        let uuid = UIDevice.current.identifierForVendor?.description
        if let deviceId = uuid {
            queries.append(URLQueryItem(name: "id", value: deviceId))
        }
        
        let url = buildUrl(path: "/planti-api/ui/getSettings", queries: queries)
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept": "application/json"
        ]
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseObject { (response: DataResponse<Settings>) in
                guard response.result.isSuccess, let value = response.result.value else {
                    print("Error: \(String(describing: response.result.error))")
                    completion(Settings())
                    return
                }
                
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                print("Value: \(value)")
                
                completion(value)
        }
    }
    
    public func postUser(option: Options?, settings: Settings?, completion: @escaping () -> Void) {
        
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
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept": "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
    
    public func getRestaurants(option: Options, location: CLLocationCoordinate2D, radius: Int,
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
            completion()
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
    
    func postMenuItem(name: String, menuItemName: String, containsMeat: Bool,
                      containsDiary: Bool, containsEgg: Bool, image: UIImage, completion: @escaping () -> Void) {
        
        print("Rest: posting menu item \(name) \(menuItemName)")
        let url = buildUrl(path: "/planti-api/ui/postMenuItem/", queries: [])
        
        var option: Int = 8
        if (containsMeat) {
            completion()
        } else {
            if (containsEgg && containsDiary) {
                option = 1
            } else if (containsEgg) {
                option = 3
            } else if (containsDiary) {
                option = 5
            }
        }
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(name.data(using: String.Encoding.utf8)!, withName: "restaurantName")
            multipartFormData.append(menuItemName.data(using: String.Encoding.utf8)!, withName: "name")
            multipartFormData.append("\(option)".data(using: String.Encoding.utf8)!, withName: "option")
            
            if let data = image.jpegData(compressionQuality: 1.0) {
                multipartFormData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
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
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    completion()
            }
        }
    }
    
    public func reportError(id: String, placeId: String) {
        print("Rest: reporting error \(id)")
        let url = buildUrl(path: "/planti-api/ui/reportError", queries: [
            URLQueryItem(name: "id", value: id),
            URLQueryItem(name: "placeId", value: placeId)])
        Alamofire.request(url, method: .post)
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
