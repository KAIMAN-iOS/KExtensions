//
//  UIImageView+Ext.swift
//  Berre
//
//  Created by GG on 15/07/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit
import Nuke

extension UIImageView {
    func downloadImage(from url: URL, identifier: String? = nil, placeholder: UIImage?, activityColor: UIColor = UIColor.blue) {
        
        let activity = UIActivityIndicatorView(style: .white)
        activity.color = activityColor
        activity.startAnimating()
        addSubview(activity)
        activity.center = center
        DataLoader.sharedUrlCache.diskCapacity = 200
        DataLoader.sharedUrlCache.memoryCapacity = 100
        
        Nuke.loadImage(with: url, options: ImageLoadingOptions(placeholder: placeholder), into: self, completion:  { result in
            defer {
                activity.removeFromSuperview()
            }
            switch result {
            case .success: DataLoader.sharedUrlCache.cachedResponse(for: ImageRequest(url: url).urlRequest)
                
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
