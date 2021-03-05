//
//  ImageView.swift
//  pryaniky
//
//  Created by Егор Потопахин on 04.03.2021.
//

import SwiftUI
import Combine

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageViewModel
    private let placeholder: Placeholder?
    
    init(url: URL, placeholder: Placeholder? = nil) {
        loader = ImageViewModel(url: url)
        self.placeholder = placeholder
    }

    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
            } else {
                placeholder
            }
        }
    }
}

struct ImageView: View {
    var url: String
    
    var body: some View {
        VStack(alignment: .center) {
            AsyncImage(
                url: URL(string: url)!,
                placeholder: Text("Загрузка изображения ...")
            ).aspectRatio(contentMode: .fit)
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(url: "https://pryaniky.com/static/img/logo-a-512.png")
    }
}
