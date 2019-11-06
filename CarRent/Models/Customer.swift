//
//  Customer.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 10. 27..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import Foundation

struct Customer: Codable {
    var customerId: Int
    var firstName: String
    var lastName: String
    var emailAddress: String
    var enabled: Bool
    var phone: String
    var drivingLicenceFrontId: Int
    var drivingLicenceBackId: Int
    var profileImageId: Int
    var licenceCardNumber: String
    var expirationDate: String
}
