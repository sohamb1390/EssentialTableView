//
//  City.swift
//  SBEssentialTableView
//
//  Created by Soham Bhattacharjee on 26/06/16.
//  Copyright © 2016 Soham Bhattacharjee. All rights reserved.
//

import UIKit

class City: NSObject {

    var cityName: String?
    var annotation: String?
    var imageName: String?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    init(cityName: String!, annotation: String!, latitude: Double, longitude: Double, imageName: String!) {
        self.cityName = cityName ?? ""
        self.annotation = annotation ?? ""
        self.imageName = imageName ?? ""
        self.latitude = latitude
        self.longitude = longitude
        super.init()
    }
}
