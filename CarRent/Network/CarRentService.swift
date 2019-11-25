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
  // 1
  // 2
  case login
  case customers
  case enable(customerId: Int)
  case disable(customerId: Int)
  case image(imageId: Int)
  case cars
  case unclosedRents

}

extension CarRentService: TargetType {

  // 1
  public var baseURL: URL {
    return URL(string: "http://ec2-3-14-28-216.us-east-2.compute.amazonaws.com")!
  }

  // 2
  public var path: String {
    switch self {
    case .login: return "/login/admin/"
    case .customers: return "/customers/"
    case .enable(let customerId): return "/register/accept/\(customerId)"
    case .disable(let customerId): return "/register/decline/\(customerId)"
    case .image(let imageId): return "/image/\(imageId)"
    case .cars: return "/cars/"
    case .unclosedRents: return "/rents/unclosed"
    }
  }

  // 3
  public var method: Moya.Method {
    switch self {
    case .login: return .get
    case .customers: return .get
    case .enable: return .post
    case .disable: return .post
    case .image: return .get
    case .cars: return .get
    case .unclosedRents: return .get
    }
  }

    public var sampleData: Data {
        return Data()
    }

  // 5
  public var task: Task {
    switch self {
    case .login, .customers, .enable, .disable, .image, .cars, .unclosedRents:
        return .requestPlain
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
