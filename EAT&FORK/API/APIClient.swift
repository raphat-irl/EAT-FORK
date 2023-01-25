//
//  APIClient.swift
//  EAT&FORK
//
//  Created by MacbookAir M1 FoodStory on 14/1/2566 BE.
//

import Alamofire
import Foundation

enum PerformRequestValidateEnum {
  case code200To299
  case code200To499
  func getStatusCodeRange() -> Array<Int> {
    switch self {
    case .code200To299:
      return Array(200...299)
    case .code200To499:
      return Array(200...499)
    }
  }
}
class APIClient {
  @discardableResult
  static func performRequest<T:Decodable>(validateStatusCodeCase: PerformRequestValidateEnum = .code200To299, router:URLRequestConvertible, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (AFResult<T>)->Void) -> DataRequest {
    return AF.request(router).validate(statusCode: PerformRequestValidateEnum.code200To499.getStatusCodeRange()).responseDecodable (decoder: decoder){
      (response: AFDataResponse<T>) in completion(response.result)
    }
  }
}

