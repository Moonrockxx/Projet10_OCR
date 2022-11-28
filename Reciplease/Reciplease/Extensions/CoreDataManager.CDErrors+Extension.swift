//
//  CoreDataManager.CDErrors+Extension.swift
//  Reciplease
//
//  Created by TomF on 28/11/2022.
//

import Foundation
import CoreData

extension CoreDataManager.CDErrors {
    var title: String {
        switch self {
        case .noData:
            return "No datas found in your favorites"
        }
    }
}
