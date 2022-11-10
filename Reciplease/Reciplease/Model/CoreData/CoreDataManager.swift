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
    
    func getFavorites(recipes: [SavedRecipes]) -> [SavedRecipes] {
        let request: NSFetchRequest = SavedRecipes.fetchRequest()
        do {
            var favoriteRecipes = recipes
            favoriteRecipes = try managedObjectContext.fetch(request)
            return favoriteRecipes
        } catch {
            print("Fetch favorites recipes failes with error : \(error.localizedDescription)")
            return []
        }
    }
    
    func removeRecipe(url: String) throws {
        let fetchRequest: NSFetchRequest<SavedRecipes>
        fetchRequest = SavedRecipes.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url)
        let result = try? managedObjectContext.fetch(fetchRequest)
        if let savedRecipe = result?.first {
            managedObjectContext.delete(savedRecipe)
            do {
                try managedObjectContext.save()
            } catch {
                print(error.localizedDescription)
            }
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
