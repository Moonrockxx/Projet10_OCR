//
//  IngredientService.swift
//  Reciplease
//
//  Created by TomF on 13/10/2022.
//

import Foundation

enum IngredientError: Error {
    case doublon
}

class IngredientService {
    static let shared = IngredientService()
    
    private init() {}
    
    private(set) var ingredients: [Ingredients] = []
    var ingredientArray: [String] = []
    
    /// Function that adds ingredients to the ingredients and ingredientArray arrays
    /// - Parameter ingredient: An Ingredients object use for his name
    func add(ingredient: Ingredients) throws {
        guard ingredientArray.contains(ingredient.name) else {
            ingredients.append(ingredient)
            ingredientArray.append(ingredient.name)
            return
        }
        
        throw IngredientError.doublon
    }
    
    /// Function that removes an ingredient from the ingredients and ingredientArray arrays at a given position
    /// - Parameter index: The position of the ingredient to remove
    func remove(at index: Int) {
        ingredients.remove(at: index)
        ingredientArray.remove(at: index)
    }
    
    /// Function that clears ingredients and ingredientArray arrays
    func removeIngredients() {
        ingredients.removeAll()
        ingredientArray.removeAll()
    }
}
