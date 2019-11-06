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

}

extension CarRentService: TargetType {

  // 1
  public var baseURL: URL {
    return URL(string: "http://ec2-3-14-28-216.us-east-2.compute.amazonaws.com")!
//    return URL(string: "https://2b95ebf2-d9ec-4229-b25f-d7346dc40934.mock.pstmn.io")!
  }

  // 2
  public var path: String {
    switch self {
    case .login: return "/login/admin/"
    case .customers: return "/customers/"
    }
  }

  // 3
  public var method: Moya.Method {
    switch self {
    case .login: return .get
    case .customers: return .get
    }
  }

    public var sampleData: Data {
        return Data()
    }

  // 5
  public var task: Task {
    switch self {
    case .login:
        return .requestPlain
    case .customers:
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
