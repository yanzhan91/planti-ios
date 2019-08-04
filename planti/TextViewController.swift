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
    public var htmlText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = nameText
        
        self.textView.allowsEditingTextAttributes = false
        self.textView.isEditable = false
        
        if textviewText != nil {
            self.textView.text = textviewText
        } else if htmlText != nil {
            if let attributedString = try? NSAttributedString(data: Data(htmlText!.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                self.textView.attributedText = attributedString
            }
        }
        
        self.textView.isEditable = false
        self.textView.allowsEditingTextAttributes = false
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
}
