//
//  AlamofireClient.swift
//  Reciplease
//
//  Created by TomF on 23/11/2022.
//

import Foundation
import Alamofire

class AlamofireClient: SessionProtocol {
    func request(url: URL, completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        AF.request(url).responseJSON { responseData in
            completionHandler(responseData.data, responseData.response, responseData.error)
        }
    }
}
