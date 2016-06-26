//
//  CellModel.swift
//  3DTouchCell
//
//  Created by Soham Bhattacharjee on 26/06/16.
//  Copyright © 2016 Soham Bhattacharjee. All rights reserved.
//

import UIKit

class CellModel: NSObject {

    var imageName: String?
    var title: String?
    init(imageName: String, title: String) {
        self.imageName = imageName ?? ""
        self.title = title ?? ""
    }
}
