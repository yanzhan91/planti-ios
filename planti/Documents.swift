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
    private var terms: String?
    
    class func shared() -> Documents {
        return documents
    }
    
    public func getTerms() -> String {
        if (self.terms == nil) {
            if let filepath = Bundle.main.path(forResource: "Terms", ofType: "txt") {
                do {
                    self.terms = try String(contentsOfFile: filepath)
                    return self.terms!
                } catch {
                    
                }
            }
            return "Something went wrong!"
        } else {
            return self.terms!
        }
    }
}
