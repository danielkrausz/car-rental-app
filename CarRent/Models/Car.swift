//
//  Cars.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 11. 18..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import Foundation

public struct Car: Codable {
    var carId: Int
    var licencePlate: String
    var brand: String
    var engineType: String
    var model: String
    var color: String
    var state: String
    var price: Double
    var currentKm: Double
    var station: Station
}
