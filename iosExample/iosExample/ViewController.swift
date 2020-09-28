//
//  ViewController.swift
//  iosExample
//
//  Created by GG on 28/09/2020.
//

import UIKit
import Label

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label.set(text: "Test label", for: .bigTitle, textColor: .purple)
    }


}

