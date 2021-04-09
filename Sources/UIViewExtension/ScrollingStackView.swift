//
//  ScrollingStackView.swift
//
//  Created by Antonio Nunes on 05/08/2018.
//  Copyright © 2018 SintraWorks. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
import UIKit
import TextFieldExtension

public class ScrollingStackView: UIScrollView {
    private var stackView = UIStackView()
    private var axisConstraint: NSLayoutConstraint?
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = convert(keyboardScreenEndFrame, from: window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentInset = .zero
        } else {
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - safeAreaInsets.bottom, right: 0)
        }
        scrollIndicatorInsets = contentInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit(axis: .vertical)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(axis: .vertical)
    }
    
    public init(axis: NSLayoutConstraint.Axis = .vertical) {
        super.init(frame: CGRect.zero)
        commonInit(axis: axis)
    }
    
    public convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis = .vertical) {
        self.init(axis: axis)
        for subview in arrangedSubviews {
            stackView.addArrangedSubview(subview)
        }
    }
    
    private func commonInit(axis: NSLayoutConstraint.Axis) {
        embed(stackView)
        self.axis = axis
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing(_:)))
        addGestureRecognizer(tap)
    }
}

// MARK: - Pass-throughs to UIStackView
// MARK: Managing arranged subviews
extension ScrollingStackView {
    private func handleTextfield(for view: UIView) {
        guard let tf = view.findFirstSubview(withType: UITextField.self) else {
            return
        }
        tf.addKeyboardControlView(target: self, buttonStyle: .body)
    }
    public func addArrangedSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
        handleTextfield(for: view)
    }
    
    public var arrangedSubviews: [UIView] {
        return stackView.arrangedSubviews
    }
    
    public func insertArrangedSubview(_ view: UIView, at stackIndex: Int) {
        stackView.insertArrangedSubview(view, at: stackIndex)
        handleTextfield(for: view)
    }
    
    public func removeArrangedSubview(_ view: UIView) {
        stackView.removeArrangedSubview(view)
    }
}

// MARK: Configuring the layout
extension ScrollingStackView {
    public var alignment: UIStackView.Alignment {
        get { return stackView.alignment }
        set { stackView.alignment = newValue }
    }
    
    public var axis: NSLayoutConstraint.Axis {
        get { return stackView.axis }
        set {
            axisConstraint?.isActive = false // deactivate existing constraint, if any
            switch newValue as NSLayoutConstraint.Axis {
            case .vertical:
                axisConstraint = stackView.widthAnchor.constraint(equalTo: self.widthAnchor)
            case .horizontal:
                axisConstraint = stackView.heightAnchor.constraint(equalTo: self.heightAnchor)
            @unknown default:
                axisConstraint = stackView.heightAnchor.constraint(equalTo: self.heightAnchor)
            }
            axisConstraint?.isActive = true // activate new constraint
            stackView.axis = newValue
        }
    }
    
    public var isBaselineRelativeArrangement: Bool {
        get { return stackView.isBaselineRelativeArrangement }
        set { stackView.isBaselineRelativeArrangement = newValue }
    }
    
    public var distribution: UIStackView.Distribution {
        get { return stackView.distribution }
        set { stackView.distribution = newValue }
    }
    
    public var isLayoutMarginsRelativeArrangement: Bool {
        get { return stackView.isLayoutMarginsRelativeArrangement }
        set { stackView.isLayoutMarginsRelativeArrangement = newValue }
    }
    
    public var spacing: CGFloat {
        get { return stackView.spacing }
        set { stackView.spacing = newValue }
    }
}

// MARK: Adding space between items
@available(iOS 11.0, *)
extension ScrollingStackView {
    public func customSpacing(after arrangedSubview: UIView) -> CGFloat {
        return stackView.customSpacing(after: arrangedSubview)
    }
    
    public func setCustomSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) {
        stackView.setCustomSpacing(spacing, after: arrangedSubview)
    }
    
    public class var spacingUseDefault: CGFloat {
        return UIStackView.spacingUseDefault
    }
    
    public class var spacingUseSystem: CGFloat {
        return UIStackView.spacingUseSystem
    }
}

// MARK: - UIView overrides
extension ScrollingStackView {
    public override var layoutMargins: UIEdgeInsets {
        get { return stackView.layoutMargins }
        set { stackView.layoutMargins = newValue }
    }
    
    public override var directionalLayoutMargins: NSDirectionalEdgeInsets {
        get { return stackView.directionalLayoutMargins }
        set { stackView.directionalLayoutMargins = newValue }
    }
    
    public func clear(from: Int = 0, to: Int? = nil) {
        stackView.clear(from: from, to: to)
    }
}

public extension UIView {
    func embed(_ child: UIView) {
        child.translatesAutoresizingMaskIntoConstraints = false
        addSubview(child)
        let constraints = [
            child.leftAnchor.constraint(equalTo: self.leftAnchor),
            child.rightAnchor.constraint(equalTo: self.rightAnchor),
            child.topAnchor.constraint(equalTo: self.topAnchor),
            child.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ]
        NSLayoutConstraint.activate(constraints)
    }
}
