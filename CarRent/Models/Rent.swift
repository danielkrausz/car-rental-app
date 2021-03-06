//
//  Rents.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 11. 25..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import Foundation

struct Rent: Codable {
    var rentId: Int
    var carId: Int
    var plannedStartTime: String
    var plannedEndTime: String
    var startStationId: Int
    var startStationName: String
    var endStationName: String
    var endStationId: Int
    var actualStartTime: String
    var actualEndTime: String?
    var state: String
    var mine: Bool
    var carModel: String
    var carBrand: String
    var positions: [Position]?
    var imageIdsBefore: [Int]
    var imageIdsAfter: [Int]
}
