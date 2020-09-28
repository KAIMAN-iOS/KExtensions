//
//  UITextField+Extension.swift
//  Moovizy
//
//  Created by jerome on 11/04/2018.
//  Copyright © 2018 CITYWAY. All rights reserved.
//

import UIKit
import Foundation
import SnapKit
import StringExtension
import FontExtension

@objc public protocol TextFieldNavigationDelegate: class {
    func nextTextField()
    func previousTextField()
}

public extension UITextField {
    func hightlight(_ term: String) {
        var attr: NSMutableAttributedString?
        if let text = text  {
            attr = NSMutableAttributedString(string: text, attributes: [.font : font as Any, .foregroundColor : textColor as Any])
        } else if let txt = attributedText {
            attr = NSMutableAttributedString(attributedString: txt)
        }
        term.split(separator: " ").forEach { str in
            if let range = attr?.string.range(of: str, options: [.diacriticInsensitive, .caseInsensitive]), let nsRange = attr?.string.nsRange(from: range) {
                attr?.addAttributes([.font : font?.bold() as Any, .foregroundColor : UIColor.red], range: nsRange)
            }
        }
        attributedText = attr
    }
}

public extension UILabel {
    func hightlight(_ term: String) {
        var attr: NSMutableAttributedString?
        if let text = text  {
            attr = NSMutableAttributedString(string: text, attributes: [.font : font as Any, .foregroundColor : textColor as Any])
        } else if let txt = attributedText {
            attr = NSMutableAttributedString(attributedString: txt)
        }
        term.split(separator: " ").forEach { str in
            if let range = attr?.string.range(of: str, options: [.diacriticInsensitive, .caseInsensitive]), let nsRange = attr?.string.nsRange(from: range) {
                attr?.addAttributes([.font : font?.bold() as Any, .foregroundColor : UIColor.red], range: nsRange)
            }
        }
        attributedText = attr
    }
}

public class InputView: UIView {
    public static var primaryColor: UIColor = .white
    public enum KeyboardControl {
        case navigation(TextFieldNavigationDelegate), close
    }
    
    init(frame: CGRect, backgroundColor: UIColor = .white) {
        super.init(frame: frame)
        self.backgroundColor = backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .white
    }
    
    func add(controls: [KeyboardControl] = [.close], target: UIView, buttonFont: Fontable) {
        for control in controls {
            switch control {
            case .close:
                let closeButton = UIButton()
                closeButton.setAttributedTitle("close".local().asAttributedString(for: buttonFont, textColor: InputView.primaryColor), for: .normal)
                addSubview(closeButton)
                closeButton.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.right.equalTo(self.snp.rightMargin)
                }
                closeButton.addTarget(target, action: #selector(endEditing(_:)), for: .touchUpInside)
                
            case .navigation(let delegate):
                let previousButton = UIButton()
                previousButton.setAttributedTitle("△".local().asAttributedString(for: buttonFont, textColor: InputView.primaryColor), for: .normal)
                addSubview(previousButton)
                previousButton.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.left.equalTo(self.snp.leftMargin)
                }
                
                previousButton.addTarget(delegate, action: #selector(TextFieldNavigationDelegate.previousTextField), for: .touchUpInside)
                
                let nextButton = UIButton()
                nextButton.setAttributedTitle("▽".local().asAttributedString(for: buttonFont, textColor: InputView.primaryColor), for: .normal)
                addSubview(nextButton)
                nextButton.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.left.equalTo(previousButton.snp.rightMargin).offset(25)
                }
                nextButton.addTarget(delegate, action: #selector(TextFieldNavigationDelegate.nextTextField), for: .touchUpInside)
            }
        }
    }
}

public extension UITextField {
    func addKeyboardControlView(with backgroundColor: UIColor = UIColor.lightGray, target: UIView, controls: [InputView.KeyboardControl] = [.close], buttonFont: Fontable)  {
        inputAccessoryView = self.inputView(with: backgroundColor, target: target, controls: controls, buttonFont: buttonFont)
    }
}

public extension UITextView {
    func addKeyboardControlView(with backgroundColor: UIColor = UIColor.lightGray, target: UIView, controls: [InputView.KeyboardControl] = [.close], buttonFont: Fontable)  {
        inputAccessoryView = self.inputView(with: backgroundColor, target: target, controls: controls, buttonFont: buttonFont)
    }
}

public extension UIView {
    func inputView(with backgroundColor: UIColor = UIColor.lightGray, target: UIView, controls: [InputView.KeyboardControl] = [.close], buttonFont: Fontable) -> InputView  {
        let view = InputView(frame: CGRect(origin: .zero, size: CGSize(width: UIApplication.shared.statusBarFrame.width, height: 40)), backgroundColor: backgroundColor)
        view.add(controls: controls, target: target, buttonFont: buttonFont)
        return view
    }
}

