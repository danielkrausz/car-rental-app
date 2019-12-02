//
//  LoginRequest.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 10. 27..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import Foundation
import Moya

public enum CarRentService {
    //metadata endpoints
    case carStates
    //customer endpoints
    case login
    case customers
    case enable(customerId: Int)
    case disable(customerId: Int)
    //image endpoints
    case image(imageId: Int)
    //car endpoints
    case cars
    case registerCar(carData: [String:String])
    case stations
    //rent endpoints
    case unclosedRents
    case activeRents
    case acceptRent(rentId: Int)
    case requestPosition(rentId: Int)
}

extension CarRentService: TargetType {

  // 1
  public var baseURL: URL {
    return URL(string: "http://ec2-3-14-28-216.us-east-2.compute.amazonaws.com")!
  }

  // 2
  public var path: String {
    switch self {
    case .carStates: return "/info/values/car-states/"
    case .login: return "/login/admin/"
    case .customers: return "/customers/"
    case .enable(let customerId): return "/register/accept/\(customerId)"
    case .disable(let customerId): return "/register/decline/\(customerId)"
    case .image(let imageId): return "/image/\(imageId)"
    case .cars: return "/cars/"
    case .registerCar: return "/cars/register/"
    case .stations: return "/stations/"
    case .unclosedRents: return "/rents/unclosed"
    case .activeRents: return "/rents/active"
    case .acceptRent(let rentId): return "/rents/\(rentId)/accept"
    case .requestPosition(let rentId): return "/rents/\(rentId)/request-position"
    }
  }

  // 3
  public var method: Moya.Method {
    switch self {
    case .carStates, .login, .customers, .image, .cars, .stations, .unclosedRents, .activeRents: return .get
    case .enable, .disable, .registerCar, .acceptRent, .requestPosition: return .post
    }
  }

    public var sampleData: Data {
        return Data()
    }

  // 5
  public var task: Task {
    switch self {
    // swiftlint:disable:next line_length
    case .carStates, .login, .customers, .enable, .disable, .image, .cars, .stations, .unclosedRents, .activeRents, .acceptRent, .requestPosition:
        return .requestPlain
    case .registerCar(let carData):
        var multipartData = [MultipartFormData]()
        for (key, value) in carData {
            let formData = MultipartFormData(provider: .data(value.data(using: .utf8)!), name: key)
            multipartData.append(formData)
          }
        return .uploadMultipart(multipartData)
    }
  }

  // 6
  public var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }

  // 7
  public var validationType: ValidationType {
    return .successCodes
  }
}
