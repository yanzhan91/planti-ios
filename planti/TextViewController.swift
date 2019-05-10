//
//  TextViewController.swift
//  planti
//
//  Created by Yan Zhan on 5/9/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    public var nameText: String?
    public var textviewText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = nameText
        self.textView.text = textviewText
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
}
