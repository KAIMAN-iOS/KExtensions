//
//  UILabel+Ext.swift
//  CovidApp
//
//  Created by jerome on 26/03/2020.
//  Copyright © 2020 Jerome TONNELIER. All rights reserved.
//

import UIKit
import NSAttributedStringBuilder
import StringExtension
import FontExtension
import Ampersand

public extension UIColor {
    static var defaultShadowColor: UIColor = UIColor.black.withAlphaComponent(0.3)
}


public extension NSShadow {
    static func defaultShadow(with color: UIColor = UIColor.defaultShadowColor) -> NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = color
        shadow.shadowBlurRadius = 5.0
        shadow.shadowOffset = CGSize(width: 2, height: 2)
        return shadow
    }
}

public extension UITextField {
    func set(text: String?, for textStyle: UIFont.TextStyle, fontScale: CGFloat = 1.0, textColor: UIColor = UIColor.black, backgroundColor: UIColor = .clear, useShadow: Bool = false) {
        guard let attr = text?.asAttributedString(for: textStyle, fontScale:fontScale, textColor: textColor, backgroundColor: backgroundColor) else { return }
        if useShadow {
            attributedText = AText.init(attr.string, attributes: attr.attributes(at: 0, effectiveRange: nil)).shadow(color: UIColor.defaultShadowColor, radius: 5.0, x: 2, y: 2).attributedString
        } else {
            attributedText = attr
        }
    }
}

public extension UILabel {
    func set(text: String?, for textStyle: UIFont.TextStyle, fontScale: CGFloat = 1.0, textColor: UIColor = UIColor.black, backgroundColor: UIColor = .clear, useShadow: Bool = false) {
        guard let attr = text?.asAttributedString(for: textStyle, fontScale:fontScale, textColor: textColor, backgroundColor: backgroundColor) else { return }
        if useShadow {
            attributedText = AText.init(attr.string, attributes: attr.attributes(at: 0, effectiveRange: nil)).shadow(color: UIColor.defaultShadowColor, radius: 5.0, x: 2, y: 2).attributedString
        } else {
            attributedText = attr
        }
    }
}

public class TappableLabel: UILabel {
    public var tapCompletions: [String: (() -> Void)] = [:]
    
    public func addTapCompletion(for text: String, completion: @escaping (() -> Void)) {
        tapCompletions[text] = completion
    }
    
    public func removeTapCompletion(for text: String) {
        tapCompletions[text] = nil
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    private func commonInit() {
        print("🤞 commonInit")
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnLabel(_:))))
        isUserInteractionEnabled = true
    }
    
    @objc public func didTapOnLabel(_ gesture: UITapGestureRecognizer) {
        print("🤞 didTapOnLabel")
        guard let text = self.text else { return }
        tapCompletions.forEach { tappableString, completion in
            let range = (text as NSString).range(of: tappableString)
            if gesture.didTapAttributedTextInLabel(label: self, inRange: range) {
                completion()
            }
        }
    }
}

public extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        var indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        indexOfCharacter = indexOfCharacter + 4
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

