//
//  NotesStorage.swift
//  VanongoTestTask
//
//  Created by Maria Ugorets on 02.09.2021.
//

import Foundation
import RealmSwift

protocol OrdersStorage {
    func saveNote(_ note: String, byID id: Int)
    func getNoteByIndex(_ index: Int) -> String?
    func getAllNotes() -> [NoteObject]
}

final class OrdersStorageImp: OrdersStorage {
    let realm: Realm?
    lazy var data: Results<NoteObject>? = { self.realm?.objects(NoteObject.self) }()
    
    init(realm: Realm?) {
        self.realm = realm
    }
    
    func getAllNotes() -> [NoteObject] {
        guard let data = data else {
            return []
        }
        return Array(data)
    }
    
    func saveNote(_ note: String, byID id: Int) {
        realm?.writeToStorage {
            let newNote = NoteObject()
            newNote.text = note
            newNote.id = id
            self.realm?.add(newNote,update: .modified)
        }
    }
    
    func getNoteByIndex(_ index: Int) -> String? {
        guard let data = data else { return nil }
        guard data.count > index else {
            print("Was trying to get data by out of range")
            return nil
        }
        return data[index].text
    }
}
