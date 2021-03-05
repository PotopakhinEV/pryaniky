//
//  GetDataHandler.swift
//  pryaniky
//
//  Created by Егор Потопахин on 04.03.2021.
//

import Combine
import Alamofire

class GetDataHandler: APIHandler {
    
    @Published var dataResponse: Response?
    @Published var isLoading = false
            
    func getBaseData() {
        isLoading = true
        
        let url = "https://pryaniky.com/static/json/sample.json"
        
        AF.request(url, method: .get).responseDecodable { [weak self] (response: DataResponse<Response, AFError>) in
            guard let weakSelf = self else { return }
            
            guard let response = weakSelf.handleResponse(response) as? Response else {
                weakSelf.isLoading = false
                return
            }
                            
            weakSelf.isLoading = false
            weakSelf.dataResponse = response
        }
    }
    
}
