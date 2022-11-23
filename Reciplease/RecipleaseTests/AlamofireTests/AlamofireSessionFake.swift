//
//  AlamofireSessionFake.swift
//  RecipleaseTests
//
//  Created by TomF on 19/11/2022.
//

import Foundation
import Alamofire
@testable import Reciplease

class AlamofireSessionFake: SessionProtocol {
    let response: FakeAlamofireResponse
    
    init(response: FakeAlamofireResponse) {
        self.response = response
    }
    
    func request(url: URL, completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        completionHandler(response.data, response.response, response.error)
    }
}
