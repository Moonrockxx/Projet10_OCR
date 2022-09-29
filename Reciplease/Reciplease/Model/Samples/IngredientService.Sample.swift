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
    
    private(set) var ingredients: [IngredientSamples] = []
    
    func add(ingredient: IngredientSamples) {
        ingredients.append(ingredient)
    }
    
    func remove(at index: Int) {
        ingredients.remove(at: index)
    }
    
    func removeAll() {
        ingredients = []
    }
}
