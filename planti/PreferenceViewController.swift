//
//  PreferenceViewController.swift
//  planti
//
//  Created by Zhiyi Yang on 3/2/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class PreferenceViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var veganSwitch: UISwitch!
    @IBOutlet weak var ovoSwitch: UISwitch!
    @IBOutlet weak var lactoSwitch: UISwitch!
    @IBOutlet weak var lactoOvoSwitch: UISwitch!
    
    @IBOutlet weak var chooseButton: ThemeButton!
    @IBOutlet weak var optionsView: UIView!
    
    var option: Options = .vegan
    private var selectedSwitch: UISwitch?
    private var changingSwitch: Bool = false
    
    var delegate: PreferenceViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.chooseButton.activate()
        
        self.optionsView.layer.borderColor = Colors.themeGreen.cgColor
        self.optionsView.layer.borderWidth = 2.0
        
        switch self.option {
        case .vegan:
            self.selectedSwitch = veganSwitch
            break
        case .ovoVegetarian:
            self.selectedSwitch = ovoSwitch
            break
        case .lactoVegetarian:
            self.selectedSwitch = lactoSwitch
            break
        case .lactoOvoVegetarian:
            self.selectedSwitch = lactoOvoSwitch
            break
        }
        self.selectedSwitch?.setOn(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollView.contentSize = getScrollViewContentSize(scrollView: self.scrollView)
    }
    
    @IBAction func choose(_ sender: Any) {     
        let settings = Settings()
        RestService.shared().postUser(option: self.option, settings: settings, completion: {})
        self.delegate?.optionDidChange(option: self.option)
        dismiss(animated: true, completion: nil)
    }
    
    private func getScrollViewContentSize(scrollView: UIScrollView) -> CGSize {
        var contentRect = CGRect.zero
        
        for view in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        
        contentRect.size.height += 30
        contentRect.size.width = self.view.frame.width
        
        return contentRect.size
    }
    
    @IBAction func toggle(_ sender: UISwitch) {
        if (self.changingSwitch) {
            self.changingSwitch = false
        } else {
            if (sender != self.selectedSwitch) {
                switch sender.tag {
                case 0:
                    self.option = .vegan
                    break
                case 1:
                    self.option = .ovoVegetarian
                    break
                case 2:
                    self.option = .lactoVegetarian
                    break
                case 3:
                    self.option = .lactoOvoVegetarian
                    break
                default:
                    self.option = .vegan
                    break
                }
                
                sender.setOn(true, animated: true)
                self.selectedSwitch?.setOn(false, animated: true)
                self.selectedSwitch = sender
                self.changingSwitch = false
            } else {
                sender.setOn(!sender.isOn, animated: true)
                self.changingSwitch = true
            }
        }
    }
}

protocol PreferenceViewControllerDelegate {
    func optionDidChange(option: Options)
}
