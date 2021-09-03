//
//  String+Extension.swift
//  VanongoTestTask
//
//  Created by Maria Ugorets on 01.09.2021.
//

import Foundation

extension String {
    func localize() -> String {
        NSLocalizedString(self, comment: "")
    }
}
