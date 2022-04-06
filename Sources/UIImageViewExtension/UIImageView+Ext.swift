//
//  UIImageView+Ext.swift
//  Berre
//
//  Created by GG on 15/07/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit
import Nuke
import SnapKit

public extension UIImageView {
    func downloadImage(from url: URL, identifier: String? = nil, placeholder: UIImage?, activityColor: UIColor = UIColor.blue) -> ImageTask? {
        
        let activity = UIActivityIndicatorView(style: .white)
        activity.hidesWhenStopped = true
        activity.color = activityColor
        activity.startAnimating()
        addSubview(activity)
        activity.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        DataLoader.sharedUrlCache.diskCapacity = 200
        DataLoader.sharedUrlCache.memoryCapacity = 100
        
        return Nuke.loadImage(with: url, options: ImageLoadingOptions(placeholder: placeholder), into: self, completion:  { result in
            DispatchQueue.main.async {
                activity.stopAnimating()
                activity.removeFromSuperview()
                // sometimes it is not removed from superview :-/ 
                self.subviews.compactMap({ $0 as? UIActivityIndicatorView }).first?.removeFromSuperview()
            }
            
            switch result {
            case .success(let image):
                DataLoader.sharedUrlCache.cachedResponse(for: ImageRequest(url: url).urlRequest)
                self.image = image.image
                
            default:
                if let cache = DataLoader.sharedUrlCache.cachedResponse(for: ImageRequest(url: url).urlRequest),
                   let image = UIImage(data: cache.data) {
                    self.image = image
                } else {
                    self.image = placeholder
                }
            }
        })
    }
}
