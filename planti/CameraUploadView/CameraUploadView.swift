//
//  CameraUploadView.swift
//  planti
//
//  Created by Zhiyi Yang on 2/23/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class CameraUploadView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        Bundle.main.loadNibNamed("CameraUploadView", owner: self, options: nil)
        self.contentView.frame = self.bounds
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = Colors.themeGreen.cgColor
        addSubview(self.contentView)
    }
    
    @IBAction func cameraPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("postCamera"), object: nil)
    }
}
