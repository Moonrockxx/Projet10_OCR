//
//  AlamofireTests.swift
//  RecipleaseTests
//
//  Created by TomF on 21/11/2022.
//

import XCTest
import Alamofire
@testable import Reciplease

final class AlamofireTests: XCTestCase {
    
    var error: APIError!
    var ingredients: [String]? = ["mustard", "cheese", "tomatoes"]
    
    func testGetRecipesShouldPostFailedCompletionIfThereIsNoDataAtAll() {
        let session = AlamofireSessionFake(response: FakeAlamofireResponse(error: nil, data: nil, response: nil))
        let requestService = APIService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: self.ingredients) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test must fail with no data.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
    }
    
    func testGetRecipesShouldPostFailedCompletionIfABadRequestIsMade() {
        let session = AlamofireSessionFake(response: FakeAlamofireResponse(error: error, data: FakeResponseData.recipesCorrectData, response: FakeResponseData.responseKO))
        let requestService = APIService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: self.ingredients) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test must fail with bad response.")
                return
            }
            XCTAssertNotNil(error)
            XCTAssertEqual(error, APIError.badRequest)
            XCTAssertTrue(error.description == "Bad request")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testGetRecipesShouldPostFailedCompletionIfDatasAreIncorrect() {
        let session = AlamofireSessionFake(response: FakeAlamofireResponse(error: error, data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK))
        let requestService = APIService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: self.ingredients) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test must fail with incorrect data.")
                return
            }
            XCTAssertNotNil(error)
            XCTAssertEqual(error, APIError.data)
            XCTAssertTrue(error.description == "No Data")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testGetRecipesShouldPostSuccessCompletionIfNoErrorCorrectDataAndCorrectResponse() {
        let session = AlamofireSessionFake(response: FakeAlamofireResponse(error: error, data: FakeResponseData.recipesCorrectData, response: FakeResponseData.responseOK))
        let requestService = APIService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: self.ingredients) { result in
            guard case .success(let result) = result else {
                XCTFail("Test must succeed.")
                return
            }
            XCTAssertNotNil(result)
            XCTAssertTrue(result.hits?.first?.recipe?.label == "Welsh Rarebit with Roasted Tomatoes Recipe")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testGetRecipesShouldPostSuccessCompletionWithTheRealAlamofireClient() {
        let requestService = APIService(session: AlamofireClient() as SessionProtocol)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes() { result in
            guard case .success(let result) = result else {
                XCTFail("Test must succeed.")
                return
            }
            XCTAssertNotNil(result)
            XCTAssertTrue(result.hits?.first?.recipe?.label == "Naomi Duguid\'s Fried Noodles")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 7)
    }
}
