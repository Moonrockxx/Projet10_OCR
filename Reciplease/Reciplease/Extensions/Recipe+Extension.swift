//
//  Recipe+Extension.swift
//  Reciplease
//
//  Created by TomF on 13/10/2022.
//

import Foundation

extension Recipe {
    /// Function used to transform a Recipes object to a RecipeDetail object
    /// - Returns: A RecipeDetails object
    func toRecipe() -> RecipeDetail {        
        var ingredientList: [String] = []
        
        guard let ingredientLines = self.ingredientLines else { return RecipeDetail() }
        
        for line in ingredientLines {
            ingredientList.append(line)
        }
        
        var instructionList: [String] = []
        
        guard let instructionLines = self.ingredients else { return RecipeDetail() }
        
        for line in instructionLines {
            instructionList.append(line.food ?? "")
        }
        
        return RecipeDetail(title: self.label,
                            subtitle: instructionList.joined(separator: ", "),
                            image: self.images?.regular?.url ?? "",
                            like: Int(self.yield ?? 0),
                            time: Double(self.totalTime ?? 0),
                            detailIngredients: ingredientList,
                            uri: uri,
                            url: url)
    }
}
