//
//  UIView+Extensions.swift
//  mtx
//
//  Created by Mikhail Demidov on 10/4/16.
//  Copyright © 2016 Cityway. All rights reserved.
//

import ObjectiveC
import UIKit
import Foundation
import SnapKit

public extension UIView {
    
    func addSubview(_ sub: UIView, with insets: UIEdgeInsets = UIEdgeInsets.zero) {
        addSubview(sub)
        sub.translatesAutoresizingMaskIntoConstraints = false
        sub.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
        sub.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left).isActive = true
        sub.rightAnchor.constraint(equalTo: rightAnchor, constant: insets.right).isActive = true
        sub.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom).isActive = true
    }
    
}

public extension UIView {
    
    func pop(duration: Double, delay: Double = 0.0, dampingRatio: CGFloat = 0.65) {
        alpha = 0
        transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: dampingRatio) {
            self.alpha = 1
            self.transform = .identity
        }
        animator.startAnimation(afterDelay: delay)
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    static func loadFromNib<T: UIView>(name: String? = nil) -> T {
        let nib = name ?? String(describing: T.self)
        return Bundle.main.loadNibNamed(nib, owner: nil, options: nil)!.first! as! T
    }
    
    func findFirstSubview<T: UIView>(withType: T.Type) -> T? {
        if self is T {
            return self as? T
        }
        guard self.subviews.count != 0 else {
            return nil
        }
        for subview in self.subviews {
            let result = subview.findFirstSubview(withType: T.self)
            guard result == nil else {
                return result
            }
        }
        return nil
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let image = renderer.image { ctx in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    func fillWith(view: UIView, at index: Int = 0) {
        insertSubview(view, at: index)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

public extension UIView {
    func addShadow(roundCorners: Bool = true, shadowColor: CGColor? = UIColor(named: "shadow")?.cgColor, shadowOffset: CGSize = CGSize(width: 0, height: 4), shadowRadius: CGFloat = 4.0, shadowOpacity: Float = 0.2, useMotionEffect: Bool = false) {
        if roundCorners {
            layer.cornerRadius = min(frame.width, frame.height) / 2
        }
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        
        if useMotionEffect == true {
            addShadowMotion()
        }
    }
    
    func addShadowMotion() {
        let horizontalEffect = UIInterpolatingMotionEffect(
            keyPath: "layer.shadowOffset.width",
            type: .tiltAlongHorizontalAxis)
        horizontalEffect.minimumRelativeValue = 16
        horizontalEffect.maximumRelativeValue = -16
        
        let verticalEffect = UIInterpolatingMotionEffect(
            keyPath: "layer.shadowOffset.height",
            type: .tiltAlongVerticalAxis)
        verticalEffect.minimumRelativeValue = 16
        verticalEffect.maximumRelativeValue = -16
        
        let effectGroup = UIMotionEffectGroup()
        effectGroup.motionEffects = [ horizontalEffect,
                                      verticalEffect ]
        
        addMotionEffect(effectGroup)
    }
}


public extension UIView {
    
    func addCardBorder(with color: UIColor = UIColor.lightGray) {
        cornerRadius = 10
        layer.borderColor = color.cgColor
        layer.borderWidth = 1.0
    }
    
    func setAsDefaultCard(with color: UIColor = UIColor.lightGray, adddShadow: Bool = true) {
        addCardBorder(with: color)
        clipsToBounds = false
        if adddShadow {
            addShadow(roundCorners: false, shadowOffset: .zero, shadowOpacity: 0.25, useMotionEffect: true)
        }
    }
    
    func round(corners: UIRectCorner,
               cornerRadii: CGSize = CGSize(width: 5, height: 5),
               borderWidth: CGFloat? = nil,
               borderColor: CGColor? = nil,
               strokeStart: CGFloat = 0,
               strokeEnd: CGFloat = 1.0) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        if let width = borderWidth, let color = borderColor {
            let borderLayer = CAShapeLayer()
            borderLayer.path = mask.path // Reuse the Bezier path
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.strokeColor = color
            borderLayer.lineWidth = width
            borderLayer.frame = self.bounds
            borderLayer.strokeStart = strokeStart
            borderLayer.strokeEnd = strokeEnd
            self.layer.addSublayer(borderLayer)
        }
    }
    
    func setRoundedCorners(corners:UIRectCorner, radius: CGFloat) {
        let rect: CGRect = self.bounds;
        
        // Create the path
        let maskPath: UIBezierPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        // Create the shape layer and set its path
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = rect;
        maskLayer.path = maskPath.cgPath;
        
        // Set the newly created shape layer as the mask for the view's layer
        self.layer.mask = maskLayer;
    }
    
    func rotate(by angle: CGFloat, around point: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        transform = transform.rotated(by: angle)
    }
}

public extension CGFloat {
    
    func toRadians() -> CGFloat {
        return self / (180 * .pi)
    }
    
    func toDegrees() -> CGFloat {
        return self * (180 * .pi)
    }
}


public class DottedView: UIView {
    public var dotColor: UIColor = UIColor.white {
        didSet {
            setNeedsLayout()
        }
    }
    public var dashes: [NSNumber] = [10, 10] {
        didSet {
            setNeedsLayout()
        }
    }
    
    public enum Orientation {
        case vertical, horizontal
        
        func startPoint(in view: UIView) -> CGPoint {
            switch self {
            case .vertical:
                return CGPoint(x:view.bounds.midX, y:0)
            case .horizontal:
                return CGPoint(x:0, y:view.bounds.midY)
            }
        }
        
        func endPoint(in view: UIView) -> CGPoint {
            switch self {
            case .vertical:
                return CGPoint(x:view.bounds.midX, y:view.bounds.maxY)
            case .horizontal:
                return CGPoint(x:view.bounds.maxX, y:view.bounds.midY)
            }
        }
    }
    public var orientation: Orientation = .horizontal
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = dotColor.cgColor
        borderLayer.lineDashPattern = dashes
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        let path = CGMutablePath()
        path.addLines(between: [orientation.startPoint(in: self), orientation.endPoint(in: self)])
        borderLayer.path = path
        layer.addSublayer(borderLayer)
    }
}

protocol ViewRoundable {
    var roundedCorners: Bool { get set}
//    var borderColor:UIColor? { get set}
}

extension UIView: ViewRoundable {
    public var roundedCorners: Bool {
        get {
            return layer.cornerRadius > 0
        }
        
        set (val) {
            DispatchQueue.main.async { [weak self] in
                self?.clipsToBounds = true
                self?.layer.cornerRadius = val ? min(self?.frame.width ?? 0, self?.frame.height ?? 0) / 2.0 : 0
                self?.setNeedsLayout()
            }
        }
    }
//    
//    public var borderColor:UIColor? {
//        get {
//            if let color = layer.borderColor {
//                return UIColor(cgColor: color)
//            }
//            return nil
//        }
//        
//        set (val) {
//            layer.borderWidth = val != nil ? 2.0 : 0
//            layer.borderColor = val?.cgColor
//            setNeedsLayout()
//            //            DispatchQueue.main.async { [weak self] in
//            //                self?.setNeedsLayout()
//            //            }
//        }
//    }
    
}


public extension UIView {
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(corners: UIRectCorner, radius: CGFloat) {
        _ = _round(corners: corners, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }
    
}

public extension UIView {
    
    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
}


public extension UIView {
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat = 0, paddingLeft: CGFloat = 0, paddingBottom: CGFloat = 0, paddingRight: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: paddingTop))
        }
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: paddingLeft))
        }
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom))
        }
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -paddingRight))
        }
        if width > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: width))
        }
        if height > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: height))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    @discardableResult
    func anchorToSuperview() -> [NSLayoutConstraint] {
        return anchor(top: superview?.topAnchor, left: superview?.leftAnchor, bottom: superview?.bottomAnchor, right: superview?.rightAnchor)
    }
}

public extension UIView {
    
    class func autolayout() -> Self {
        let view = self.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    @discardableResult func autolayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult func add(in superView: UIView) -> Self {
        superView.addSubview(self)
        return self
    }
    
    @discardableResult func layout(constraints: (ConstraintMaker) -> Void) -> Self {
        self.snp.makeConstraints(constraints)
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult func updateLayout(constraints: (ConstraintMaker) -> Void) -> Self {
        self.snp.updateConstraints(constraints)
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult func remakeLayout(constraints: (ConstraintMaker) -> Void) -> Self {
        self.snp.remakeConstraints(constraints)
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func add(constraints: String, for views: [String: UIView]) {
        
        for (_,view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: constraints, options: [], metrics: nil, views: views))
    }
    
    func printSubviews(at index:Int = 0) {
        let tab = Array<String>(repeating: "--", count: index)
        print("\(tab.joined())-> \(self is UILabel) - \(self)")
        subviews.forEach { (subview) in
            subview.printSubviews(at: index + 1)
        }
    }
    
    func updateConstraints(animated: Bool = true, duration: Double = 0.5, useSpringWithDamping damping: CGFloat = 0.5, initialVelocity valocity: CGFloat = 0.5, _ animationBlock: @escaping (() -> Void)) {
        guard animated == true else {
            animationBlock()
            return
        }
        
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: damping, animations: animationBlock)
        layoutIfNeeded()
        animator.startAnimation()
    }
}

public extension UIStackView {
    func clear(from: Int = 0, to: Int? = nil) {
        arrangedSubviews[from..<(to == nil ? arrangedSubviews.count : to!)].forEach { (view) in
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}

public extension UIView {
    
    enum ComponentShape {
        case capsule
        case rounded(value: CGFloat)
        case square
        
        public func applyShape(on view: UIView) {
            view.clipsToBounds = true
            switch self {
            case .capsule: view.layer.cornerRadius = view.bounds.height / 2
            case .rounded(let value): view.layer.cornerRadius = value
            case .square: view.layer.cornerRadius = 0
            }
        }
    }
}

class ReadjustingStackView: UIStackView {

  /// To know the size of our margins without hardcoding them, we have an
  /// outlet to a leading space constraint to read the constant value.
  @IBOutlet var leadingConstraint: NSLayoutConstraint!

  required init(coder: NSCoder) {
    super.init(coder: coder)
    // We want to recalculate our orientation whenever the dynamic type settings
    // on the device change.
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(adjustOrientation),
      name: UIContentSizeCategory.didChangeNotification,
      object: nil
    )
  }

  /// This takes care of recalculating our orientation whenever our content or
  /// layout changes (such as due to device rotation, addition of more buttons
  /// to the stack view, etc).
  override func layoutSubviews() {
    adjustOrientation()
  }

  @objc
  func adjustOrientation() {
    // Always attempt to fit everything horizontally first
    axis = .horizontal
    alignment = .firstBaseline

    let desiredStackViewWidth = systemLayoutSizeFitting(
      UIView.layoutFittingCompressedSize
    ).width

    if let parent = superview {
      let availableWidth = parent.bounds.inset(by: parent.safeAreaInsets).width - (leadingConstraint.constant * 2.0)
      if desiredStackViewWidth > availableWidth {
        axis = .vertical
        alignment = .fill
      }
    }
  }
}

public extension UIView {
    
    // ->1
    enum Direction: Int {
        case topToBottom = 0
        case bottomToTop
        case leftToRight
        case rightToLeft
    }
    
    func startShimmeringAnimation(animationSpeed: Float = 1.4,
                                  direction: Direction = .leftToRight,
                                  repeatCount: Float = MAXFLOAT) {
        
        // Create color  ->2
        let lightColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1).cgColor
        let blackColor = UIColor.black.cgColor
        
        // Create a CAGradientLayer  ->3
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [blackColor, lightColor, blackColor]
        gradientLayer.frame = CGRect(x: -self.bounds.size.width, y: -self.bounds.size.height, width: 3 * self.bounds.size.width, height: 3 * self.bounds.size.height)
        
        switch direction {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        
        gradientLayer.locations =  [0.35, 0.50, 0.65] //[0.4, 0.6]
        self.layer.mask = gradientLayer
        
        // Add animation over gradient Layer  ->4
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = CFTimeInterval(animationSpeed)
        animation.repeatCount = repeatCount
        CATransaction.setCompletionBlock { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.layer.mask = nil
        }
        gradientLayer.add(animation, forKey: "shimmerAnimation")
        CATransaction.commit()
    }
    
    func stopShimmeringAnimation() {
        self.layer.mask = nil
    }
    
}

extension UISearchBar {
    public var textField: UITextField? {
        if #available(iOS 13, *) {
            return searchTextField
        }
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }

    func clearBackgroundColor() {
        guard let UISearchBarBackground: AnyClass = NSClassFromString("UISearchBarBackground") else { return }

        for view in subviews {
            for subview in view.subviews where subview.isKind(of: UISearchBarBackground) {
                subview.alpha = 0
            }
        }
    }

    public var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
    }

    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator = UIActivityIndicatorView(style: .gray)
                    newActivityIndicator.color = UIColor.gray
                    newActivityIndicator.startAnimating()
                    newActivityIndicator.backgroundColor = textField?.backgroundColor ?? UIColor.white
                    textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero

                    newActivityIndicator.center = CGPoint(x: leftViewSize.width - newActivityIndicator.frame.width / 2,
                                                          y: leftViewSize.height / 2)
                }
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }

    func changePlaceholderColor(_ color: UIColor) {
        guard let UISearchBarTextFieldLabel: AnyClass = NSClassFromString("UISearchBarTextFieldLabel"),
            let field = textField else {
            return
        }
        for subview in field.subviews where subview.isKind(of: UISearchBarTextFieldLabel) {
            (subview as! UILabel).textColor = color
        }
    }

    func setRightImage(normalImage: UIImage,
                       highLightedImage: UIImage) {
        showsBookmarkButton = true
        if let btn = textField?.rightView as? UIButton {
            btn.setImage(normalImage,
                         for: .normal)
            btn.setImage(highLightedImage,
                         for: .highlighted)
        }
    }
    
        func setLeftImage(_ image: UIImage,
                      with padding: CGFloat = 0,
                      tintColor: UIColor) {
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.tintColor = tintColor

        if padding != 0 {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fill
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            let paddingView = UIView()
            paddingView.translatesAutoresizingMaskIntoConstraints = false
            paddingView.widthAnchor.constraint(equalToConstant: padding).isActive = true
            paddingView.heightAnchor.constraint(equalToConstant: padding).isActive = true
            stackView.addArrangedSubview(paddingView)
            stackView.addArrangedSubview(imageView)
            textField?.leftView = stackView

        } else {
            textField?.leftView = imageView
        }
    }
}

extension UIImage {
    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }
}
