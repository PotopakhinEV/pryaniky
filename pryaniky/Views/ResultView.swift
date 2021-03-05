//
//  ResultView.swift
//  pryaniky
//
//  Created by Егор Потопахин on 04.03.2021.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel = ResultViewModel()
    @State var selectionValue: Int = -1
    
    @State var allertMessage: String = ""
    @State var showingAllert: Bool = false
    
    var body: some View {
        /**
            Прописываем set and get для Binding picker'a, так как значение исходное получаем из response
         */
        let selectedPicker = Binding<Int>(get: {
            if (self.selectionValue != -1) {
                return self.selectionValue
            } else if (viewModel.response?.selectedIndex != -1) {
                return viewModel.response?.selectedIndex ?? 0
            } else {
                return 0
            }
            
        }, set: {
            self.selectionValue = $0
            showingAllert(text: "Вы выбрали вариант номер \(self.selectionValue + 1)")
        })
        
        Group {
            if (viewModel.isLoading) {
                Text("Загрузка...")
                
            } else if (viewModel.response == nil)  {
                Text("Произошла ошибка загрузки данных.")
                
                Button(action: {viewModel.getData()}) {
                    Text("Попробовать снова")
                }
            } else {
                ForEach(viewModel.response?.view ?? [], id: \.self) { type in
                    switch  type {
                    case "hz":
                        Text(viewModel.response?.dataDictionary["hz"]?.text ?? "")
                            .onTapGesture(){
                                showingAllert(text: "Вы тыкнули на текст, однако...")
                            }
                        
                        
                    case "selector":
                        Picker(selection: selectedPicker, label: Text("Picker"), content: {
                            ForEach(((viewModel.response?.dataDictionary["selector"]?.variants)!), id: \.self) {data in
                                Text(data.text).tag(data.id! - 1)
                            }
                        })

                    case "picture" :
                        ImageView(url: viewModel.response?.dataDictionary["picture"]?.url ?? "")
                            .onTapGesture(){
                                showingAllert(text: "Не прикасайтесь к прянику, он слишком нежен...")
                            }
                        
                    default:
                        Text("Не опознанные данные")
                    }
                }
            }
        }
        .padding()
        
        .alert(isPresented: $showingAllert) {
            Alert(title: Text("Очень важное сообщение"), message: Text(self.allertMessage), dismissButton: .default(Text("Идем дальше!")))
               }
    }
    
    private func showingAllert(text: String) {
        self.allertMessage = text
        self.showingAllert = true
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(selectionValue: 0)
    }
}
