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
    @IBOutlet weak var veganSwitch: UISwitch!
    @IBOutlet weak var ovoSwitch: UISwitch!
    @IBOutlet weak var lactoSwitch: UISwitch!
    @IBOutlet weak var lactoOvoSwitch: UISwitch!
    @IBOutlet weak var pescSwitch: UISwitch!
    @IBOutlet weak var changeButton: ThemeButton!
    @IBOutlet weak var cancelButton: ThemeButton!
    
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
        self.changeButton.activate()
        self.cancelButton.deactivate()
        contentView.frame = self.bounds
    }
}
