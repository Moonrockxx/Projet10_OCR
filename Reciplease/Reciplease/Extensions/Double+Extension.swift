//
//  Double+Extension.swift
//  Reciplease
//
//  Created by TomF on 13/10/2022.
//

import Foundation

extension Double {
    func timeAsString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = style
        return formatter.string(from: self) ?? ""
    }
}
