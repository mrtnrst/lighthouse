//
//  Router.swift
//  Lighthouse
//
//  Created by Martin on 5/6/17.
//  Copyright © 2017 builtby. All rights reserved.
//

import Alamofire

struct Location {
  let lat: String
  let long: String
}

enum NetworkError: Error {
  case network(error: Error)
  case jsonSerialization(error: Error)
  case objectSerialization(reason: String)
}

enum Endpoint: String {
  case current = "/"
}

enum Router: URLRequestConvertible {
  case get(parameters: Location, endpoint: Endpoint)
  
  static let baseURL = "https://api.darksky.net/forecast/<#ENTER DARKSKY APIKEY#>"
  
  var method: HTTPMethod {
    switch self {
    case .get:
      return .get
    }
  }
  
  var path: String {
    switch self {
    case .get(_, let endpoint):
      return endpoint.rawValue
    }
  }
  
  func asURLRequest() throws -> URLRequest {
    let url = try Router.baseURL.asURL()
    
    var urlRequest: URLRequest
    urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
    switch self {
    case .get(let parameters, _):
      urlRequest = URLRequest(url: url.appendingPathComponent(parameters.lat + "," + parameters.long))
    }
    
    return urlRequest
  }
}
