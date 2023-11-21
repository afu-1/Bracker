//
//  AppSettingsViewController.swift
//  Bracker
//
//  Created by Annie Fu on 11/19/23.
//
// Description: decides the settings of the app (dark mode and font size of book reviews)


import UIKit

class AppSettingsViewController: UIViewController {
    
    //dark mode outlets
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var darkModeLabel: UILabel!
    
    //font size outlets
    @IBOutlet weak var fontSizeLabel: UILabel!
    @IBOutlet weak var fontSizeSlider: UISlider!
    @IBOutlet weak var smallFontLabel: UILabel!
    @IBOutlet weak var mediumFontLabel: UILabel!
    @IBOutlet weak var largeFontLabel: UILabel!
    
    var delegate: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sets UI as dark mode and sets switch based on whether dark mode was selected or not
        if darkMode == true {
            overrideUserInterfaceStyle = .dark
            darkModeSwitch.setOn(true, animated: false)
        } else {
            overrideUserInterfaceStyle = .light
            darkModeSwitch.setOn(false, animated: false)
        }
        
        //sets font size slider at font size set beforehand
        fontSizeSlider.setValue(Float(fontSizeIndicator), animated: false)
    }
    
    //changes light/dark mode
    override func viewWillLayoutSubviews() {
        view.backgroundColor = .background
        darkModeLabel.textColor = UIColor(named: "labelColor")
        fontSizeLabel.textColor = UIColor(named: "labelColor")
        smallFontLabel.textColor = UIColor(named: "labelColor")
        mediumFontLabel.textColor = UIColor(named: "labelColor")
        largeFontLabel.textColor = UIColor(named: "labelColor")
    }
    
    //switch to set dark mode
    @IBAction func setDarkMode(_ sender: UISwitch) {
        //when dark mode is set on
        if darkModeSwitch.isOn {
            darkMode = true
            UIView.animate(withDuration: 10.0, delay: 5.0, options: .curveEaseIn, animations: {
                        self.overrideUserInterfaceStyle = .dark
                    })
        //when dark mode is off
        } else {
            darkMode = false
            UIView.animate(withDuration: 10.0, delay: 5.0, options: .curveEaseIn, animations: {
                        self.overrideUserInterfaceStyle = .light
                    })
        }
    }
    
    //slider to set font size
    @IBAction func sliderChange(_ sender: UISlider) {
        let fontValue: Int = lroundf(fontSizeSlider.value)
        fontSizeSlider.setValue(Float(fontValue), animated: false)
        fontSizeIndicator = fontValue
    }
    
    //button to segue back to main VC
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
