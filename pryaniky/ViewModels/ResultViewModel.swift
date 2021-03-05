//
//  ResultViewModel.swift
//  pryaniky
//
//  Created by Егор Потопахин on 04.03.2021.
//

import Foundation
import SwiftUI
import Combine

class ResultViewModel: ObservableObject, Identifiable {
    @Published var isLoading = true
    @Published var response: Response?

    var getDataHandler = GetDataHandler()
    private var disposables: Set<AnyCancellable> = []
    
    private var isLoadingPublisher: AnyPublisher<Bool, Never> {
        getDataHandler.$isLoading
            .receive(on: RunLoop.main)
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    private var isLoadingData: AnyPublisher<Response?, Never> {
        getDataHandler.$dataResponse
            .receive(on: RunLoop.main)
            .map { response in
                guard let response = response else {
                    return nil
                }
                return response
            }
            .eraseToAnyPublisher()
    }
        
    init() {
        isLoadingPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &disposables)
        
        isLoadingData
            .receive(on: RunLoop.main)
            .assign(to: \.response, on: self)
            .store(in: &disposables)
        
        getData()
    }
    
    func getData() {
        getDataHandler.getBaseData()
    }
}
