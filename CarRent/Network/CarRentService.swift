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
    
}


extension CarRentService: TargetType {
    
  // 1
  public var baseURL: URL {
    return URL(string: "https://penzfeldobas.herokuapp.com")!
  }

  // 2
  public var path: String {
    switch self {
    case .login: return "/login/admin"
    }
  }

  // 3
  public var method: Moya.Method {
    switch self {
    case .login: return .get
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
