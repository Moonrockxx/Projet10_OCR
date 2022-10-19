//
//  String+Extension.swift
//  Reciplease
//
//  Created by TomF on 13/10/2022.
//

import Foundation

extension String {
    /// Function used to remove white spaces
    /// - Parameter characterSet: .whitespacesAndNewLines
    /// - Returns: A String
    func trimmingLeadingAndTrailingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        return trimmingCharacters(in: characterSet)
    }
}
