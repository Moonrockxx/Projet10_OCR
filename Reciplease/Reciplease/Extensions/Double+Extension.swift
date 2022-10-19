//
//  Double+Extension.swift
//  Reciplease
//
//  Created by TomF on 13/10/2022.
//

import Foundation

extension Double {
    /// Function that transforms a date into a string
    /// - Parameter style: The units style of the given date
    /// - Returns: A String
    func timeAsString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = style
        return formatter.string(from: self) ?? ""
    }
}
