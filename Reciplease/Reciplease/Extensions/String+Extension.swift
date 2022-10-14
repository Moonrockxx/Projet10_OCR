//
//  String+Extension.swift
//  Reciplease
//
//  Created by TomF on 13/10/2022.
//

import Foundation

extension String {
    func trimmingLeadingAndTrailingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        return trimmingCharacters(in: characterSet)
    }
}
