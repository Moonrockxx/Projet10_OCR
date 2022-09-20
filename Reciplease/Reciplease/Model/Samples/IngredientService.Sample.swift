//
//  IngredientService.Sample.swift
//  Reciplease
//
//  Created by TomF on 20/09/2022.
//

import Foundation

class IngredientService {
    static let shared = IngredientService()
    
    private init() {}
    
    private(set) var ingredients: [Ingredient] = []
    
    func add(ingredient: Ingredient) {
        ingredients.append(ingredient)
    }
    
    func remove(at index: Int) {
        ingredients.remove(at: index)
    }
}
