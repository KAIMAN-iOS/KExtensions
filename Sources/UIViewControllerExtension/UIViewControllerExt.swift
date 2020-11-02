//
//  UIViewControllerExr.swift
//  FindABox
//
//  Created by jerome on 16/09/2019.
//  Copyright © 2019 Jerome TONNELIER. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    func addSelectionFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    func addNotificationFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func addImpactFeedback() {
        let generator = UIImpactFeedbackGenerator()
        generator.impactOccurred()
    }
    
    static func loadFromStoryboard<T: UIViewController>(identifier: String? = nil, storyboardName: String? = nil) -> T {
        let classIdentifier = identifier ?? String(describing: T.self)
        let storyboard = UIStoryboard(name: storyboardName ?? classIdentifier, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: classIdentifier) as! T
    }
    
    static func loadFromNib<T: UIViewController>(nibName: String? = nil) -> T {
        let classIdentifier = nibName ?? String(describing: T.self)
        return T(nibName: classIdentifier, bundle: nil)
    }
    
    
    func showShareViewController(with items: [Any],
                                 excludedActivityTypes: [UIActivity.ActivityType] = [.addToReadingList, .assignToContact, .copyToPasteboard, .openInIBooks, .saveToCameraRoll]) {
        let shareController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        shareController.excludedActivityTypes = excludedActivityTypes
        
        present(shareController, animated: true, completion: {
        })
        
        shareController.completionWithItemsHandler = { (activity, success, items, error) in
        }
    }
}

public extension UIViewController {
    var hideBackButtonText: Bool   {
        set {
            if newValue {
                if #available(iOS 14.0, *) {
                    navigationItem.backButtonDisplayMode = .minimal
                } else {
                    navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
                }
            } else {
                if #available(iOS 14.0, *) {
                    navigationItem.backButtonDisplayMode = .default
                } else {
                    navigationItem.backBarButtonItem = nil
                }
            }
        }
        
        get {
            if #available(iOS 14.0, *) {
                return navigationItem.backButtonDisplayMode != .minimal
            } else {
                return navigationItem.backBarButtonItem == nil
            }
        }
    }
}
