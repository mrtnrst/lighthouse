//
//  Serialization.swift
//  lighthouse
//
//  Created by Martin on 5/6/17.
//  Copyright © 2017 builtby. All rights reserved.
//

import Alamofire

// MARK: Response Object Serialization
protocol ResponseObjectSerializable {
  init?(response: HTTPURLResponse, type: Any)
}

extension DataRequest {
  @discardableResult func responseObject<T: ResponseObjectSerializable>(
    queue: DispatchQueue? = nil,
    completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
    let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
      guard error == nil else { return .failure(NetworkError.network(error: error!)) }
      
      let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
      let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
      
      guard case let .success(jsonObject) = result else {
        return .failure(NetworkError.jsonSerialization(error: result.error!))
      }
      
      guard let response = response, let responseObject = T(response: response, type: jsonObject) else {
        return .failure(NetworkError.objectSerialization(reason: "JSON could not be processed: \(jsonObject)" ))
      }
      
      return .success(responseObject)
    }
    
    return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
  }
}
