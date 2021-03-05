//
//  APIHandler.swift
//  pryaniky
//
//  Created by Егор Потопахин on 04.03.2021.
//

import Alamofire
import Combine

class APIHandler {
        
    var statusCode = Int.zero
    
    func handleResponse<T: Decodable>(_ response: DataResponse<T, AFError>) -> Any? {
        switch response.result {
        case .success:
            return response.value
        case .failure:
            return nil
        }
    }
}
