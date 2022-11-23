//
//  FakeResponseData.swift
//  RecipleaseTests
//
//  Created by TomF on 23/11/2022.
//

import Foundation

class FakeResponseData {
    static let responseOK = HTTPURLResponse(url: URL(string: "https://www.apple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    static let responseKO = HTTPURLResponse(url: URL(string: "https://www.apple.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    
    static var recipesCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "recipes", withExtension: "json")!
        return try? Data(contentsOf: url)
    }
    
    static let incorrectData = "incorectDatas".data(using: .utf8)
}
