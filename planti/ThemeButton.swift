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
        initalize(title: title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initalize(title: nil)
    }
    
    private func initalize(title: String?) {
        self.layer.cornerRadius = 14
        self.layer.borderWidth = 1.5
        self.layer.borderColor = Colors.themeGreen.cgColor
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        if (title != nil) {
            self.setTitle(title, for: .normal)
        }
        deactivate()
        self.contentEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        self.sizeToFit()
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
