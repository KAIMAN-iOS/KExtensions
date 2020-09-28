//
//  Array+Ext.swift
//  Oui Chef
//
//  Created by GG on 07/09/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import Foundation
public extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
