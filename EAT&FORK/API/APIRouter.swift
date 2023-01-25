//
//  APIRouter.swift
//  EAT&FORK
//
//  Created by MacbookAir M1 FoodStory on 14/1/2566 BE.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
  case get(param: JSON? , path: String?)
  case post(param: JSON?, path: String?)
  case put(param: JSON?, path: String?)
  case delete(param: JSON?, path: String?)
  // MARK: - HTTPMethod
  private var method: Alamofire.HTTPMethod {
    switch self {
    case .post:
      return .post
    case .get:
      return .get
    case .put:
      return .put
    case .delete:
      return .delete
    }
  }
  // MARK: - Parameters
  private var parameters: Parameters? {
    switch self {
    case .get(let param, _):
      return param
    case .post(let param, _):
      return param
    case .put(let param, _):
      return param
    case .delete(let param, _):
      return param
    }
  }
  private var path: String {
    switch self {
    case .get(_ , let path):
      return path ?? ""
    case .post(_ , let path):
      return path ?? ""
    case .put(_, let path):
      return path ?? ""
    case .delete(_ , let path):
      return path ?? ""
    }
  }
  // MARK: - URLRequestConvertible
  func asURLRequest() throws -> URLRequest {
    var base = "https://63bd4463d6600623889f97ea.mockapi.io/menus"
    base += path
    let url = try base.asURL()
    var urlRequest = URLRequest(url: url)
    // HTTP Method
    urlRequest.httpMethod = method.rawValue
    // Common Headers
    urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
    //urlRequest.setValue(K.XApiKey.xAPIKeyCRM, forHTTPHeaderField: HTTPHeaderField.xAPIKey.rawValue)
    // Parameters
    if let parameters = parameters {
      do {
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
      } catch {
        throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
      }
    }
    return urlRequest
  }
}
