//
//  Documents.swift
//  planti
//
//  Created by Yan Zhan on 5/9/19.
//  Copyright © 2019 planti. All rights reserved.
//

import Foundation

class Documents {
    private static var documents = Documents()
    
    class func shared() -> Documents {
        return documents
    }
    
    public func getDocument(type: String) -> String {
        if let filepath = Bundle.main.path(forResource: type, ofType: "txt") {
            do {
                return try String(contentsOfFile: filepath)
            } catch {
                
            }
        }
        return "Something went wrong!"
    }
}
