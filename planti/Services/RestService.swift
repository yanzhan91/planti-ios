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
    private final var scheme: String = "https"
    private final var host: String = "api.plantiapp.com"
    
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
    
    public func getRestaurants(option: Options, minLat: Double, minLng: Double, maxLat: Double, maxLng: Double, userLocation: CLLocationCoordinate2D, completion: @escaping ([Restaurant]?) -> ()) {
        print("Rest: getRestaurants \(option)")
        
        let url = buildUrl(path: "/planti-api/ui/getRestaurants", queries: [
            URLQueryItem(name: "option", value: String(option.number())),
            URLQueryItem(name: "minLatitude", value: String(minLat)),
            URLQueryItem(name: "minLongitude", value: String(minLng)),
            URLQueryItem(name: "maxLatitude", value: String(maxLat)),
            URLQueryItem(name: "maxLongitude", value: String(maxLng)),
            URLQueryItem(name: "userLatitude", value: String(userLocation.latitude)),
            URLQueryItem(name: "userLongitude", value: String(userLocation.longitude))
        ])
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        Alamofire.request(request)
            .validate()
            .responseArray { (response: DataResponse<[Restaurant]>) in
                guard response.result.isSuccess, let value = response.result.value else {
                    print("Error: \(String(describing: response.result.error))")
                    completion(nil)
                    return
                }
                
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                print("Value: \(value)")
                
                completion(value)
        }
    }
    
    public func getMenuItems(option: Options, chainId: String, completion: @escaping ([MenuItem]) -> Void) {
        print("Rest: getting menu items \(option) \(chainId)")
        let url = buildUrl(path: "/planti-api/ui/getMenuItems/", queries: [
            URLQueryItem(name: "chainId", value: chainId), URLQueryItem(name: "option", value: String(option.number()))])
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
    
    public func postMenuItem(restaurantName: String, menuItemName: String, email: String?, containsMeat:Bool, containsDiary: Bool, containsEgg: Bool, image: UIImage?, completion: @escaping () -> Void) {
        print("Rest: posting menu item \(restaurantName) \(menuItemName)")
        
        if (containsMeat) {
            completion()
            return
        }
        
        let url = buildUrl(path: "/planti-api/ui/menuItem/", queries: [])
        
        var parameters: [String : String] = [
            "restaurantName": restaurantName,
            "menuItemName": menuItemName,
            "diary": containsDiary ? "true" : "false",
            "egg": containsEgg ? "true" : "false"]
        
        if (email != nil) {
            parameters["email"] = email!
        }
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            
            if let data = image?.jpegData(compressionQuality: 0.01) {
                multipartFormData.append(data, withName: "file", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    completion()
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completion()
            }
        }
    }
    
    public func postMenuItemImage(id: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        print("Rest: posting menu item image \(id)")
        let url = buildUrl(path: "/planti-api/ui/menuItemImage/", queries: [])
        
        let parameters: [String : String] = ["id": id]
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            
            if let data = image?.jpegData(compressionQuality: 0.01) {
                multipartFormData.append(data, withName: "file", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    completion(true)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    public func reportError(menuItemId: String, chainId: String) {
        print("Rest: reporting error \(menuItemId)")
        let url = buildUrl(path: "/planti-api/ui/reportError", queries: [
            URLQueryItem(name: "id", value: menuItemId),
            URLQueryItem(name: "chainId", value: chainId)])
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
