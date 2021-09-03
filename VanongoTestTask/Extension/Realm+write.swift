//
//  Realm+write.swift
//  VanongoTestTask
//
//  Created by Maria Ugorets on 03.09.2021.
//

import RealmSwift

extension Realm {
    func writeToStorage(_ writingBlock: () -> Void) {
        do {
            try write(writingBlock)
        } catch {
            print("Failed by writing data to storage")
        }
    }
}
