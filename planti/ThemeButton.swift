//
//  ThemeButton.swift
//  planti
//
//  Created by Zhiyi Yang on 2/20/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class ThemeButton: UIButton {
    
    required init(frame: CGRect, title: String) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 18
        self.layer.borderWidth = 2.0
        self.layer.borderColor = Colors.themeGreen.cgColor
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        self.setTitle(title, for: .normal)
        deactivate()
        self.contentEdgeInsets = UIEdgeInsets(top: 9, left: 12, bottom: 9, right: 12)
        self.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func activate() {
        self.backgroundColor = Colors.themeGreen
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    public func deactivate() {
        self.backgroundColor = UIColor.white
        self.setTitleColor(Colors.themeGreen, for: .normal)
    }
    
}
