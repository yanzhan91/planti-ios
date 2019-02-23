//
//  PostViewController.swift
//  planti
//
//  Created by Zhiyi Yang on 2/23/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var cameraUploadView: CameraUploadView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addDashedBorder()
    }
    
    private func addDashedBorder() {
        let border = CAShapeLayer()
        border.strokeColor = Colors.themeGreen.cgColor
        border.lineDashPattern = [2, 2]
        border.frame = self.cameraUploadView.bounds
        border.fillColor = nil
        border.path = UIBezierPath(rect: self.cameraUploadView.bounds).cgPath
        self.cameraUploadView.layer.addSublayer(border)
    }
}
