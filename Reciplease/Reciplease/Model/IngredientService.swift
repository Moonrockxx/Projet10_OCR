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
    
    func add(ingredient: Ingredients) throws {
        guard ingredientArray.contains(ingredient.name) else {
            ingredients.append(ingredient)
            ingredientArray.append(ingredient.name)
            return
        }
        
        throw IngredientError.doublon
    }
    
    func remove(at index: Int) {
        ingredients.remove(at: index)
        ingredientArray.remove(at: index)
    }
    
    func removeIngredients() {
        ingredients.removeAll()
        ingredientArray.removeAll()
    }
}
