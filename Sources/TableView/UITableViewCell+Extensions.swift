//
//  UITableViewCell+Extensions.swift
//  mtx
//
//  Created by Mikhail Demidov on 10/4/16.
//  Copyright © 2016 Cityway. All rights reserved.
//

import UIKit
import SnapKit

public protocol CellRegistrable {
    var tableView: UITableView! { get }
    func register(cell: Identifiable.Type)
}

public extension CellRegistrable {
    func register(cell: Identifiable.Type) {
        let nib = UINib(nibName: cell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cell.identifier)
    }
}

public protocol CellDequeueable: CellRegistrable {
    func dequeue<T>(index: IndexPath, cell: Identifiable.Type) -> T where T: UITableViewCell
}

public extension CellDequeueable {
    func dequeue<T>(index: IndexPath, cell: Identifiable.Type = T.self) -> T where T: UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cell.identifier, for: index) as! T
    }
}


public extension UITableViewCell {
    func addDefaultSelectedBackground(_ color: UIColor = UIColor.white) {
        let view = UIView(frame: contentView.bounds)
        view.backgroundColor = color
        selectedBackgroundView = view
    }
}
