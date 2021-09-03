//
//  OrderDetailModel.swift
//  VanongoTestTask
//
//  Created by Maria Ugorets on 01.09.2021.
//

import Foundation

protocol OrderDetailModel {
    func getData() -> String?
    func saveData(_ note: String)
}

final class OrderDetailModelImp: OrderDetailModel {
    private let storage: OrdersStorage
    private let id: Int
    private var noteText: String?
    
    init(id: Int, storage: OrdersStorage) {
        self.storage = storage
        self.id = id
    }
    
    func getData() -> String? {
        noteText = storage.getNoteByIndex(id)
        return noteText
    }

    func saveData(_ newNote: String) {
        noteText = newNote
        storage.saveNote(newNote, byID: id)
    }
}
