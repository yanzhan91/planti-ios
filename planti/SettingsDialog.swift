//
//  SettingsDialog.swift
//  planti
//
//  Created by Zhiyi Yang on 3/5/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class SettingsDialog: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var newMenuItems: UISwitch!
    @IBOutlet weak var newPromotions: UISwitch!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        Bundle.main.loadNibNamed("SettingsDialogView", owner: self, options: nil)
//        self.closeButton.activate()
        addSubview(self.contentView)
    }
}
