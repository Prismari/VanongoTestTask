//
//  NoteObject.swift
//  VanongoTestTask
//
//  Created by Maria Ugorets on 02.09.2021.
//

import Foundation
import RealmSwift

class NoteObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var text = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
