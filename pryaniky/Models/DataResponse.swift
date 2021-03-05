//
//  DataResponse.swift
//  pryaniky
//
//  Created by Егор Потопахин on 04.03.2021.
//

import Foundation
import SwiftUI
/**
    Данные для отображения в picker
 */
struct variants: Decodable, Hashable {
    var id: Int?
    var text: String
}

/**
    общая структура данных
 */
struct result: Decodable {
    var data: data?
    var name: String?
}
/**
    Структура хранит:
    - url, если это изображение
    - selectedId и variants если это picker
    - text если это текстовый блок и картинка
 */
struct data: Decodable {
    var url: String?
    var selectedId: Int?
    var text: String?
    var variants: [variants]?
}

/**
    Класс парсит JSON с сервера
 */
class Response: Decodable {
    // массив для хранения данных
    var data: [result]?
    // массив для списка отображения данных
    var view: [String]?
    
    //словарь по типу тип данны : значение
    var dataDictionary: [String: data] = [:]
    
    var selectedIndex: Int = -1
    
    enum CodingKeys: String, CodingKey {
        case data
        case view
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //парсим
        data = try? container.decode([result].self, forKey: .data) as [result]
        view = try? container.decode([String].self, forKey: .view) as [String]
        
        generateDictionar()
    }
    /**
        функция создает из массива словарь для picker'а
     */
    private func  generateDictionar() {
        for res in data! {
            dataDictionary[res.name ?? ""] = res.data
            
            if ((res.name == "selector") && (res.data?.selectedId != nil)) {
                self.selectedIndex = (res.data?.selectedId)!
            }
        }
    }
}
