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
    
    enum ButtonType {
        case SETTINGS
        case POST
    }
    
    func createOkAlert(title: String, message: String, buttonTitle: String, viewController: UIViewController, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let okAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        okAlert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: handler))
        return okAlert
    }
    
    func createActionAlert(title: String, message: String, buttonType: ButtonType, viewController: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        switch buttonType {
        case .SETTINGS:
            alert.addAction(createSettingsAction())
            break
        case .POST:
            alert.addAction(createPostAction(viewController: viewController))
            break
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alert
    }
    
    func createSettingsAction() -> UIAlertAction {
        return UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
    }
    
    func createPostAction(viewController: UIViewController) -> UIAlertAction {
        return UIAlertAction(title: "Post", style: .default) { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let rmvc = storyboard.instantiateViewController(withIdentifier: "postVC") as! PostViewController
            viewController.present(rmvc, animated: true, completion: nil)
        }
    }
}
