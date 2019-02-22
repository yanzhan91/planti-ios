//
//  OptionsPopupView.swift
//  planti
//
//  Created by Zhiyi Yang on 2/21/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class OptionsPopupView: UIView {
    
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
        Bundle.main.loadNibNamed("OptionsPopup", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight]
    }
    
    @IBAction func veganSwitch(_ sender: Any) {
    }
    
    @IBAction func ovoSwitch(_ sender: Any) {
    }
    
    @IBAction func lactoSwitch(_ sender: Any) {
    }
    
    @IBAction func lactoOvoSwitch(_ sender: Any) {
    }
    
    @IBAction func pesSwitch(_ sender: Any) {
    }
}
