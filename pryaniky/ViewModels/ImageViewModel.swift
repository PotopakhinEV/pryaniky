//
//  ImageViewModel.swift
//  pryaniky
//
//  Created by Егор Потопахин on 04.03.2021.
//

import Foundation
import SwiftUI
import Combine

class ImageViewModel: ObservableObject {
    @Published var image: UIImage?
    private let url: URL
    private var cancellable: AnyCancellable?
    
    init(url: URL) {
        self.url = url
    }
    
    deinit {
        cancellable?.cancel()
    }

    func load() {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

