//
//  AlertService.swift
//  planti
//
//  Created by Zhiyi Yang on 6/19/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class AlertService {
    
    private static var alertService = AlertService()
    
    class func shared() -> AlertService {
        return alertService
    }
    
    func createOkAlert(title: String, message: String, buttonTitle: String, viewController: UIViewController, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let okAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        okAlert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: handler))
        return okAlert
    }
    
    func createSettingsAlert(title: String, message: String, buttonTitle: String, viewController: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alert
    }
}
