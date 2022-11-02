//
//  CoreDataManager.swift
//  Reciplease
//
//  Created by TomF on 02/11/2022.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext = CoreDataStack.sharedInstance.mainContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func saveRecipe(recipe: RecipeDetail) {
        let entity = SavedRecipes(context: managedObjectContext)
        entity.title = recipe.title
        entity.subtitle = recipe.subtitle
        entity.recipeImage = recipe.image
        entity.like = Int64(recipe.like ?? 0)
        entity.time = recipe.time ?? 0
        entity.ingredientLines = recipe.detailIngredients?.joined(separator: ", ")
        entity.uri = recipe.uri
        entity.url = recipe.url
        
        do {
            try CoreDataStack.sharedInstance.mainContext.save()
        } catch {
            print(error)
        }
    }
    
    func removeRecipe() {
        // deletion logic
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Unable to remove this recipe")
        }
    }
    
    func recipeIsAlreadySaved(url: String) -> Bool {
        let request: NSFetchRequest<SavedRecipes> = SavedRecipes.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)
        
        guard let recipes = try? managedObjectContext.fetch(request) else { return false }
        
        if recipes.isEmpty {
            return false
        } else {
            return true
        }
    }
}
