//
//  OptionsScrollView.swift
//  planti
//
//  Created by Zhiyi Yang on 2/23/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class OptionsScrollView: UIScrollView {
    
    private var customDelegate: OptionsScrollViewDelegate?
    override var delegate: UIScrollViewDelegate? {
        didSet { customDelegate = delegate as? OptionsScrollViewDelegate }
    }
    
    private var selected : ThemeButton?
    private var optionsButtonsDictionary : Dictionary = [Options: ThemeButton]()
    private var buttonsOptionsDictionary : Dictionary = [ThemeButton: Options]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize(option: .vegan)
    }
    
    init(frame: CGRect, option: Options) {
        super.init(frame: frame)
        initialize(option: option)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize(option: .vegan)
    }
    
    private func initialize(option: Options) {
        var leftSpacing = 5
        let topSpacing = 5
        var totalWidth = 5
        for option in Options.allCases {
            let button = ThemeButton.init(frame: CGRect(x: leftSpacing, y: topSpacing, width: 100, height: 40),
                                          title: option.rawValue)
            
            button.addTarget(self, action: #selector(preferenceButtonPressed), for: .touchUpInside)
            
            self.buttonsOptionsDictionary[button] = option
            self.optionsButtonsDictionary[option] = button
            
            self.addSubview(button)
            leftSpacing += Int(button.frame.width + 5)
            totalWidth += Int(button.frame.width + 5)
            
            if (self.selected == nil) {
                self.selected = button
                self.selected?.activate()
            }
        }
        self.contentSize = CGSize(width: totalWidth, height: 50)
    }
    
    @objc private func preferenceButtonPressed(sender: ThemeButton) {
        if (sender != self.selected) {
            self.selected?.deactivate()
            sender.activate()
            self.selected = sender
            self.customDelegate?.didChangeOption(self.buttonsOptionsDictionary[sender] ?? .vegan)
        }
    }
    
    public func setPreference(option: Options) {
        let button = self.optionsButtonsDictionary[option]
        if (button != self.selected) {
            self.selected?.deactivate()
            button!.activate()
            self.selected = button!
        }
        self.scrollRectToVisible(button!.frame, animated: true)
    }
    
    public func getPreference() -> Options {
        return self.buttonsOptionsDictionary[self.selected!] ?? .vegan
    }
}

protocol OptionsScrollViewDelegate: UIScrollViewDelegate {
    func didChangeOption(_ option: Options)
}
