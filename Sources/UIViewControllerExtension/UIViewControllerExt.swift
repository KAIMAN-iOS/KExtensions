//
//  UIViewControllerExr.swift
//  FindABox
//
//  Created by jerome on 16/09/2019.
//  Copyright © 2019 Jerome TONNELIER. All rights reserved.
//

import UIKit
import Photos
import StringExtension
import SnapKit

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

extension UIAlertController.Style {
    // ipad allow .actionSheet only presented for some concrete controls (and cashes otherwise!)
    // whereas iphone can present .actionSheet unconditionally.
    // .safeActionSheet returns .alert for systems that do not support .actionSheet unconditionally.
    // if in doubt, always prefer .safeActionSheet over .actionSheet
    public static var safeActionSheet: UIAlertController.Style {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .alert
        } else {
            return .actionSheet
        }
    }
}

public extension UIViewController {
    func presentImagePickerChoice(mediaTypes: [String] = ["public.image"],
                                  delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate,
                                  tintColor: UIColor?,
                                  presentCompletion: ((UIImagePickerController?, PHAuthorizationStatus?) -> Void)? = nil) {
        let hasCameraCapability = UIImagePickerController.isSourceTypeAvailable(.camera)
        let hasLibraryCapability = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        
        // none allowed > settings
        guard hasCameraCapability || hasLibraryCapability else {
            showSettingsDialog(tintColor: tintColor)
            presentCompletion?(nil, .denied)
            return
        }
        
        guard hasCameraCapability,
              hasLibraryCapability else {
            showImagePicker(with: UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary,
                            mediaTypes: mediaTypes,
                            tintColor: tintColor,
                            delegate: delegate,
                            presentCompletion: presentCompletion)
            return
        }
        
        let actionSheet = UIAlertController(title: "Choose an image".local(), message: nil, preferredStyle: .safeActionSheet)
        
        actionSheet.view.tintColor = tintColor
        actionSheet.addAction(UIAlertAction(title: "From Library".local(), style: .default, handler: { [weak self] _ in
            self?.showImagePicker(with: .photoLibrary, mediaTypes: mediaTypes, tintColor: tintColor, delegate: delegate, presentCompletion: presentCompletion)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Take picture".local(), style: .default, handler: { [weak self] _ in
            self?.showImagePicker(with: .camera, mediaTypes: mediaTypes, tintColor: tintColor, delegate: delegate)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel".local(), style: .cancel, handler: { _ in
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showImagePicker(with type: UIImagePickerController.SourceType,
                         mediaTypes: [String],
                         tintColor: UIColor?,
                         delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate,
                         presentCompletion: ((UIImagePickerController?, PHAuthorizationStatus?) -> Void)? = nil) {
        let showPicker: () -> (Void) = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let picker = UIImagePickerController()
                picker.sourceType = type
                picker.mediaTypes = mediaTypes
                picker.delegate = delegate
                picker.navigationItem.rightBarButtonItem?.tintColor = .red
                presentCompletion?(picker, nil)
                self.present(picker, animated: true) {
                }
            }
        }
        
        switch type {
            case .camera:
                let status = AVCaptureDevice.authorizationStatus(for: .video)
                switch status {
                    case .authorized: showPicker()
                    case .notDetermined:
                        AVCaptureDevice.requestAccess(for: .video) { granted in
                            if granted {
                                showPicker()
                            } else {
                                self.openAppSettings()
                            }
                        }
                    default: openAppSettings()
                }
                
            default:
                let status = PHPhotoLibrary.authorizationStatus()
                switch status {
                    case .notDetermined:
                        PHPhotoLibrary.requestAuthorization({ status in
                            if status == .authorized {
                                showPicker()
                            } else {
                                self.openAppSettings()
                            }
                        })
                        
                    case .authorized: showPicker()
                        
                    default:
                        showSettingsDialog(tintColor: tintColor)
                        presentCompletion?(nil, status)
                }
        }
    }
    
    private func showSettingsDialog(tintColor: UIColor?) {
            let actionSheet = UIAlertController(title: "Authorization denied".local(), message: nil, preferredStyle: .safeActionSheet)
            actionSheet.view.tintColor = tintColor
            actionSheet.addAction(UIAlertAction(title: "Change your settings".local(), style: .cancel, handler: { _ in
                self.openAppSettings()
            }))
            
            present(actionSheet, animated: true, completion: nil)
    }
    
    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url) else {
                assertionFailure("Not able to open App privacy settings")
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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

extension UIViewController {
    public func add(_ child: UIViewController, snapCompletion: (ConstraintMaker) -> Void) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
        child.view.snp.makeConstraints(snapCompletion)
    }
    
    public func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
