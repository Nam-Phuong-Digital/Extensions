//
//  SwipeDataSource.swift
//  Cabinbook
//
//  Created by Dai Pham on 08/11/2023.
//  Copyright © 2023 Nam Phuong Digital. All rights reserved.
//

import UIKit

@available(iOS 13,*)
public class SwipeDataSource: UITableViewDiffableDataSource<Int, AnyHashable> {
    public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
