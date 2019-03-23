//
//  LogoutDialog.swift
//  planti
//
//  Created by Zhiyi Yang on 3/5/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import GoogleSignIn

class LogoutDialog: UIView {
    
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var cancelButton: ThemeButton!
    @IBOutlet weak var logoutButton: ThemeButton!
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
        Bundle.main.loadNibNamed("LogoutDialogView", owner: self, options: nil)
        self.cancelButton.deactivate()
        self.logoutButton.activate()
        addSubview(self.contentView)
    }
}
