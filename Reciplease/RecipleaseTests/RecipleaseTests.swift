//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by TomF on 20/09/2022.
//

import XCTest
@testable import Reciplease

final class RecipleaseTests: XCTestCase {
    private var ingredients: [Ingredients] = []
    private var ingredientArray: [String] = []

    // MARK: - IngredientService
    func testGivenWeHaveIngredientArrays_WhenWeAddAnIngredient_ThenTheIngredientIsPresentInTheArrays() {
        let newIngredient = Ingredients(name: "Tomatoes")
        
        try? IngredientService.shared.add(ingredient: newIngredient)
        
        XCTAssertEqual(IngredientService.shared.ingredients.first?.name, "Tomatoes")
        XCTAssertEqual(IngredientService.shared.ingredientArray.first, "Tomatoes")
    }

    func testGivenWeHaveIngredientArrays_WhenWeAddAnIngredientAlreadyPresent_ThenTheFunctionThrowsAnError() {
        let newIngredient = Ingredients(name: "Tomatoes")
        
        try? IngredientService.shared.add(ingredient: newIngredient)
        
        XCTAssertThrowsError(try IngredientService.shared.add(ingredient: newIngredient))
    }
    
    func testGivenWeHaveIngredientArrays_WhenWeRemoveAllTheIngredients_TheTheArraysAreEmpty() {
        let newIngredient = Ingredients(name: "Tomatoes")
        
        try? IngredientService.shared.add(ingredient: newIngredient)
        
        IngredientService.shared.remove(at: 0)
        XCTAssertEqual(IngredientService.shared.ingredients.first?.name, nil)
        
    }
    
    func testGivenWeHaveIngredientArrays_WhenWeRemoveAllTheIngredients_ThenTheArrayIsEmpty() {
        IngredientService.shared.removeIngredients()
        XCTAssertEqual(IngredientService.shared.ingredients.first?.name, nil)
    }
}
