//
//  APIError+Extension.swift
//  Reciplease
//
//  Created by TomF on 28/11/2022.
//

import Foundation

extension APIError {
    var description: String {
        switch self {
        case APIError.data:
            return "No Data"
        case APIError.badRequest:
            return "Bad request"
        }
    }
}
