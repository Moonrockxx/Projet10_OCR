//
//  CoreDataManager.swift
//  Reciplease
//
//  Created by TomF on 02/11/2022.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    func saveRecipe(recipe: RecipeDetail)
    func getFavorites(completionHandler: @escaping (Result<[SavedRecipes], CoreDataManager.CDErrors>) -> Void)
    func removeRecipe(uri: String) throws
    func removeAllRecipes() throws
    func recipeIsAlreadySaved(url: String) -> Bool
}

class CoreDataManager: CoreDataManagerProtocol {
    
    // MARK: - Enum
    enum CDErrors: Error {
        case noData
    }
    
    // MARK: - Constants
    let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    /// This function is used to save the recipe in CoreData and as favorite
    /// - Parameter recipe: A RecipeDetails object that will be saved
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
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print(error)
        }
    }
    
    /// This function is used to get the favorites recipes
    /// - Parameter completionHandler: A type Result that takes a SavedRecipes array and CDErrors
    func getFavorites(completionHandler: @escaping (Result<[SavedRecipes], CDErrors>) -> Void) {
        let request: NSFetchRequest = SavedRecipes.fetchRequest()
        do {
            let favoriteRecipes = try managedObjectContext.fetch(request)
            return completionHandler(.success(favoriteRecipes))
        } catch {
            print("Fetch favorites recipes failes with error : \(error.localizedDescription)")
            return completionHandler(.failure(.noData))
        }
    }
    
    /// This function is used to remove a recipe from CoreData and favorites
    /// - Parameter uri: A String that represents the URI of a given recipes
    func removeRecipe(uri: String) throws {
        let fetchRequest: NSFetchRequest<SavedRecipes> = SavedRecipes.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uri == %@", uri)
        
        let result = try? managedObjectContext.fetch(fetchRequest)
        if let savedRecipe = result?.first(where: { $0.uri == uri }) {
            managedObjectContext.delete(savedRecipe)
            do {
                try managedObjectContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// This function remove all recipes from CoreData and favorites
    func removeAllRecipes() throws {
        let fetchRequest: NSFetchRequest<SavedRecipes> = SavedRecipes.fetchRequest()
        let result = try? managedObjectContext.fetch(fetchRequest)
        
        if let results = result {
            for i in results {
                managedObjectContext.delete(i)
            }
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    /// This function check if the recipe is already saved
    /// - Parameter url: A String that represents the URL of a given recipe
    /// - Returns: A boolean. True if the recipe is already saved, false if she isn't
    func recipeIsAlreadySaved(url: String) -> Bool {
        let request: NSFetchRequest<SavedRecipes> = SavedRecipes.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)
        
        guard let recipes = try? managedObjectContext.fetch(request) else { return false }
        
        return !recipes.isEmpty
    }
}
