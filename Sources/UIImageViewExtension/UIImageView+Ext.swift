//
//  UIImageView+Ext.swift
//  Berre
//
//  Created by GG on 15/07/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit
import AlamofireImage
import SnapKit

extension UIImageView {
    func downloadImage(from url: URL, placeholder: UIImage?, activityColor: UIColor = .blue) {
        let activity = UIActivityIndicatorView(style: .white)
        activity.color = activityColor
        activity.startAnimating()
        addSubview(activity)
        activity.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        af.setImage(withURL: url, cacheKey: url.absoluteString, placeholderImage: placeholder, completion:  { data in
            defer {
                activity.removeFromSuperview()
            }
            
            let replaceWithPlaceholder: (() -> Void) = {
                self.image = placeholder
            }
            switch data.result {
            case .success(let image): self.image = image
            default: replaceWithPlaceholder()
            }
        })
    }
}
