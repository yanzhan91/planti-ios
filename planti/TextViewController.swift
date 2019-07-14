//
//  TextViewController.swift
//  planti
//
//  Created by Yan Zhan on 5/9/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import MarkdownKit

class TextViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    public var nameText: String?
    public var textviewText: String?
    public var markdownText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = nameText
        if textviewText != nil {
            self.textView.text = textviewText
        } else if markdownText != nil {
            let markdownParser = MarkdownParser()
            self.textView.attributedText = markdownParser.parse(markdownText!)
        }
        
        self.textView.isEditable = false
        self.textView.allowsEditingTextAttributes = false
//        self.textView.isUserInteractionEnabled = false
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
}
