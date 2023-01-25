//
//  MenuNetworkAPI.swift
//  EAT&FORK
//
//  Created by MacbookAir M1 FoodStory on 14/1/2566 BE.
//

import Foundation
import Alamofire

class MenuNetworkAPI: NSObject {
        
    static func getMenu(_ completion:@escaping (AFResult<[MenuResponse]>)-> Void) {
        let decoder = JSONDecoder()
        APIClient.performRequest(router: APIRouter.get(param: nil, path: nil), decoder: decoder,
                                 completion: completion)
    }
}
