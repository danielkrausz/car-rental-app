//
//  CodableResponses.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 10. 27..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import Foundation

struct CarRentServiceResponse<T: Codable>: Codable {
    let results: [T]
}
