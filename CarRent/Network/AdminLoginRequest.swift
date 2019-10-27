//
//  LoginRequest.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 10. 27..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import Foundation
import Moya

public enum AdminLoginRequest {
  // 1
  static private let username = ""
  static private let password = ""

  // 2
  case login
}


extension AdminLoginRequest: TargetType {
  // 1
  public var baseURL: URL {
    return URL(string: "https://penzfeldobas.herokuapp.com")!
  }

  // 2
  public var path: String {
    switch self {
    case .login: return "/admin/login"
    }
  }

  // 3
  public var method: Moya.Method {
    switch self {
    case .login: return .get
    }
  }

  // 4
  public var sampleData: Data {
    return Data()
  }

  // 5
  public var task: Task {
    switch self {
    case .login:
        //TODO
        return .requestParameters(parameters: <#T##[String : Any]#>, encoding: <#T##ParameterEncoding#>)
    }
    
    return .requestPlain // TODO
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
