//
//  OrderListModel.swift
//  VanongoTestTask
//
//  Created by Maria Ugorets on 02.09.2021.
//

import Foundation

protocol OrderListModel {
    func cellsCount() -> Int
    func cellTitle(_ index: Int) -> String
    func userDidTapAddButton()
    func userDidTapOnOrder(_ id: Int)
}

final class OrderListModelImp: OrderListModel {
    private let storage: OrdersStorage
    weak var viewController: OrderListView?
    private var notes: [NoteObject]
    
    init(storage: OrdersStorage) {
        self.storage = storage
        notes = storage.getAllNotes()
    }
    
    func cellsCount() -> Int {
        notes.count
    }
    
    func cellTitle(_ index: Int) -> String {
        return "Order".localize() + " \(index + 1)"
    }

    
    func userDidTapAddButton() {
        storage.saveNote("", byID: notes.count)
        notes = storage.getAllNotes()
        viewController?.updateList()
    }
    func userDidTapOnOrder(_ index: Int) {
        let note = notes[index]
        showDetailsView(note.id)
    }
    
    private func showDetailsView(_ id: Int) {
        let model = OrderDetailModelImp(id: id, storage: storage)
        viewController?.showDetailsWithModel(model)
    }
}
