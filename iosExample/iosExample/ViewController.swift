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

extension FontType: Fontable {
    public var font: UIFont {
        switch self {
        case .bigTitle: return .boldSystemFont(ofSize: 32.0)
        case .button: return .systemFont(ofSize: 14.0)
        default: return .systemFont(ofSize: 12.0)
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label.set(text: "\(Double(12).readablePrice())\n\(DateFormatter.readableDateFormatter.string(from: Date()))", for: FontType.bigTitle, textColor: UIColor.init(hexString: "#16C8C9"))
        
        textField.addKeyboardControlView(with: UIColor.init(hexString: "#16C8C9"), target: view, controls: [.close], buttonFont: FontType.button)
        
    }
}

