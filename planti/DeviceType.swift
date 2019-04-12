//
//  DeviceType.swift
//  planti
//
//  Created by Yan Zhan on 4/12/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

struct DeviceType {
    static var hasTopNotch: Bool {
        if #available(iOS 11, *) {
            if let insets = UIApplication.shared.delegate?.window??.safeAreaInsets {
                if insets.top > 20 {
                    return true
                }
            }
        }
        
        return false
    }
}
