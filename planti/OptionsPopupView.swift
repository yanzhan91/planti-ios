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
    
    private var oldOption : Options = Options.vegan
    private var changingSwitches : Bool = false
    
    private var optionSelected : Options = Options.vegan
    private var optionsSwitchesDictionary : Dictionary = [Options: UISwitch]()
    private var SwitchesOptionsDictionary : Dictionary = [UISwitch: Options]()
    
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
        
        self.optionsSwitchesDictionary[.vegan] = self.veganSwitch
        self.optionsSwitchesDictionary[.ovoVegetarian] = self.ovoSwitch
        self.optionsSwitchesDictionary[.lactoVegetarian] = self.lactoSwitch
        self.optionsSwitchesDictionary[.lactoOvoVegetarian] = self.lactoOvoSwitch
        self.optionsSwitchesDictionary[.pescetarians] = self.pescSwitch
        
        self.SwitchesOptionsDictionary[self.veganSwitch] = .vegan
        self.SwitchesOptionsDictionary[self.ovoSwitch] = .ovoVegetarian
        self.SwitchesOptionsDictionary[self.lactoSwitch] = .lactoVegetarian
        self.SwitchesOptionsDictionary[self.lactoOvoSwitch] = .lactoOvoVegetarian
        self.SwitchesOptionsDictionary[self.pescSwitch] = .pescetarians
        
        contentView.frame = self.bounds
    }
    
    @IBAction func switchPressed(_ sender: Any) {
        if (!self.changingSwitches) {
            self.changingSwitches = true
            self.oldOption = self.optionSelected
        }
        
        setPreference(option: self.SwitchesOptionsDictionary[sender as! UISwitch]!)
    }
    
    public func setPreference(option: Options) {
        if (self.optionSelected != option) {
            self.optionsSwitchesDictionary[self.optionSelected]?.setOn(false, animated: true)
            self.optionSelected = option
        }
        
        self.optionsSwitchesDictionary[option]?.setOn(true, animated: true)
    }
    
    public func resetPreference() {
        self.changingSwitches = false;
        setPreference(option: self.oldOption)
    }
    
    @IBAction func changePressed(_ sender: Any) {
        self.changingSwitches = false;
        NotificationCenter.default.post(name: NSNotification.Name("preferencePopupChange"), object: nil, userInfo: ["option": self.optionSelected])
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.changingSwitches = false;
        resetPreference()
        NotificationCenter.default.post(name: NSNotification.Name("preferencePopupCancel"), object: nil)
    }
}
