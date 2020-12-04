//
//  ViewController.swift
//  iosExample
//
//  Created by GG on 28/09/2020.
//

import UIKit
import LabelExtension
import FontExtension
import DoubleExtension
import ColorExtension
import DateExtension
import TextFieldExtension
import UIViewControllerExtension
import Ampersand
import NSAttributedStringBuilder

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var stylesLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configurationURL = Bundle.main.url(forResource: "Poppins", withExtension: "json")!
        UIFont.registerApplicationFont(withConfigurationAt: configurationURL)
        
        // Do any additional setup after loading the view.
        label.set(text: "\(Double(12).readablePrice())\n\(DateFormatter.readableDateFormatter.string(from: Date()))",
                  for: .largeTitle,
                  fontScale: 1.3,
                  textColor: UIColor.init(hexString: "#16C8C9"))
        stylesLabel.adjustsFontForContentSizeCategory = true
        stylesLabel.numberOfLines = 0
        stylesLabel.attributedText = NSAttributedString() {
            AText("body")
                .font(.applicationFont(forTextStyle: .body))
            LineBreak()
            AText("callout")
                .font(.applicationFont(forTextStyle: .callout))
            LineBreak()
            AText("headline")
                .font(.applicationFont(forTextStyle: .headline))
            LineBreak()
            AText("subheadline")
                .font(.applicationFont(forTextStyle: .subheadline))
            LineBreak()
            AText("caption1")
                .font(.applicationFont(forTextStyle: .caption1))
            LineBreak()
            AText("caption2")
                .font(.applicationFont(forTextStyle: .caption2))
            LineBreak()
            AText("footnote")
                .font(.applicationFont(forTextStyle: .footnote))
            LineBreak()
            AText("largeTitle")
                .font(.applicationFont(forTextStyle: .largeTitle))
            LineBreak()
            AText("title1")
                .font(.applicationFont(forTextStyle: .title1))
            LineBreak()
            AText("title2")
                .font(.applicationFont(forTextStyle: .title2))
            LineBreak()
            AText("title3")
                .font(.applicationFont(forTextStyle: .title3))
            LineBreak()
        }
        InputView.primaryColor = .red
        textField.addKeyboardControlView(with: UIColor.init(hexString: "#16C8C9"), target: view, controls: [.close], buttonStyle: .callout)
        hideBackButtonText = true
    }
    
    @IBAction func push(_ sender: Any) {
        let ctrl = UIViewController()
        ctrl.view.backgroundColor = .red
        navigationController?.pushViewController(ctrl, animated: true)
    }
}

