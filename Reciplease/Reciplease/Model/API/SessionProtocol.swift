//
//  SessionProtocol.swift
//  Reciplease
//
//  Created by TomF on 23/11/2022.
//

import Foundation

/// This protocol is used not to depend only on alamofire
protocol SessionProtocol {
    func request(url: URL, completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void)
}
