//
//  ViewController.swift
//  iosExample
//
//  Created by GG on 28/09/2020.
//

import UIKit
import Label
import Font

extension FontType {
    public var font: UIFont {
        switch self {
        case .bigTitle: return .boldSystemFont(ofSize: 32.0)
        default: return .systemFont(ofSize: 12.0)
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label.set(text: "Test label", for: .bigTitle, textColor: .purple)
    }
}

