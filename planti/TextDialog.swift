//
//  TextDialog.swift
//  planti
//
//  Created by Zhiyi Yang on 3/4/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class TextDialog: UIView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var closeButton: ThemeButton!
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
        Bundle.main.loadNibNamed("TextDialogView", owner: self, options: nil)
        self.closeButton.activate()
        addSubview(self.contentView)
    }
}
