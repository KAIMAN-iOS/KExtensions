//
//  StringExt.swift
//  FindABox
//
//  Created by jerome on 15/09/2019.
//  Copyright © 2019 Jerome TONNELIER. All rights reserved.
//

import UIKit
import NSAttributedStringBuilder
import FontExtension
import Ampersand

public extension String {
    func local() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func asAttributedString(for style: UIFont.TextStyle,
                            traits: [UIFontDescriptor.SymbolicTraits]? = nil,
                            fontScale: CGFloat = 1.0,
                            textColor: UIColor = UIColor.black,
                            backgroundColor: UIColor = .clear,
                            underline: NSUnderlineStyle? = nil) -> NSAttributedString {
        let font = traits == nil ? UIFont.applicationFont(forTextStyle: style) : UIFont.applicationFont(forTextStyle: style).withTraits(traits: traits!)
        let attr = AText(self)
            .font(font.withSize(font.pointSize * fontScale))
            .foregroundColor(textColor)
            .backgroundColor(backgroundColor)
            .attributedString
        
        return underline != nil ? AText.init(attr.string, attributes: attr.attributes(at: 0, effectiveRange: nil)).underline(underline!).attributedString : attr
    }
    
    func asAttributedString(for fontSize: CGFloat,
                            weight: UIFont.Weight = .regular,
                            textColor: UIColor = UIColor.black,
                            backgroundColor: UIColor = .clear,
                            underline: NSUnderlineStyle? = nil) -> NSAttributedString {
        let font = UIFont.applicationFont(ofSize: fontSize, weight: weight)
        let attr = AText(self)
            .font(font)
            .foregroundColor(textColor)
            .backgroundColor(backgroundColor)
            .attributedString
        
        return underline != nil ? AText.init(attr.string, attributes: attr.attributes(at: 0, effectiveRange: nil)).underline(underline!).attributedString : attr
    }
    
    var isValidEmail: Bool {
        guard !self.lowercased().hasPrefix("mailto:") else { return false }
        guard let emailDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return false }
        let matches = emailDetector.matches(in: self, options: NSRegularExpression.MatchingOptions.anchored, range: NSRange(location: 0, length: self.count))
        guard matches.count == 1 else { return false }
        return matches[0].url?.scheme == "mailto"
    }
    
    func call() {
        let set = CharacterSet(charactersIn: "+*#0123456789")
        if let url = URL(string: "telprompt:\(self.components(separatedBy: set.inverted).joined())") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

public extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange {
        guard let from = range.lowerBound.samePosition(in: utf16),
              let to = range.upperBound.samePosition(in: utf16) else { return NSRange() }
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }
}

public extension String {
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
}
public extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
