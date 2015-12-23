//
//  CategoriesTable.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 17/12/15.
//  Copyright © 2015 RASOFT. All rights reserved.
//

import WatchKit

class CategoriesTable: NSObject {
    @IBOutlet var categoriaLabel: WKInterfaceLabel!
    var category: String? {
        didSet {
            if let category = category {
                categoriaLabel.setText(category)
            }
        }
    }

}
