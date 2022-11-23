//
//  CoreDataTests.swift
//  RecipleaseTests
//
//  Created by TomF on 18/11/2022.
//

import XCTest
import CoreData
@testable import Reciplease

final class CoreDataTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    var coreDataStack: CoreDataStack!
    
    private var savedRecipes: [SavedRecipes] = []
    
    private var recipeForTest1: RecipeDetail = RecipeDetail(title: "Steak Frites",
                                                            subtitle: "Avec du ketchup",
                                                            image: "",
                                                            like: 33,
                                                            time: 30,
                                                            detailIngredients: ["pomme de terre", "viande hachée", "huile de friture"],
                                                            uri: "www.marmiton.org",
                                                            url: "https://www.marmiton.org")
    
    private var recipeForTest2: RecipeDetail = RecipeDetail(title: "Purée saucisse",
                                                            subtitle: "",
                                                            image: "",
                                                            like: 50,
                                                            time: 60,
                                                            detailIngredients: ["pomme de terre", "lait", "saucisses"],
                                                            uri: "www.cuisineaz.org",
                                                            url: "https://www.cuisineaz.org")
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack(modelName: "Reciplease", persistentStoreDescription: "/dev/null")
        coreDataManager = CoreDataManager()
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        coreDataManager = nil
        self.savedRecipes = []
    }
    
    func testCheckForDuplicateRecipesBeforeSaving() {
        try? coreDataManager.removeAllRecipes()
        coreDataManager.saveRecipe(recipe: recipeForTest1)
        coreDataManager.saveRecipe(recipe: recipeForTest2)
        
        coreDataManager.getFavorites(completionHandler: { result in
            switch result {
            case .success(let recipes):
                self.savedRecipes = recipes
            case .failure(let failure):
                print(failure)
            }
        })
        
        for i in savedRecipes {
            print("🤡 \(i.title ?? "")")
        }
        
        let isDuplicate = coreDataManager.recipeIsAlreadySaved(url: recipeForTest1.url ?? "")
        
        XCTAssertTrue(isDuplicate)
    }
    
    func testSaveARecipeAsFavorite() {
        try? coreDataManager.removeAllRecipes()
        coreDataManager.saveRecipe(recipe: recipeForTest1)

        XCTAssertEqual(recipeForTest1.title, "Steak Frites")
        XCTAssertEqual(recipeForTest1.subtitle, "Avec du ketchup")
        XCTAssertEqual(recipeForTest1.like, 33)
        XCTAssertEqual(recipeForTest1.time, 30)
        XCTAssertEqual(recipeForTest1.detailIngredients, ["pomme de terre", "viande hachée", "huile de friture"])
        XCTAssertEqual(recipeForTest1.uri, "www.marmiton.org")
        XCTAssertEqual(recipeForTest1.url, "https://www.marmiton.org")
    }
    
    func testFetchFavorites() {
        try? coreDataManager.removeAllRecipes()
    
        coreDataManager.saveRecipe(recipe: recipeForTest1)
        coreDataManager.saveRecipe(recipe: recipeForTest2)

        coreDataManager.getFavorites(completionHandler: { result in
            switch result {
            case .success(let recipes):
                self.savedRecipes = recipes
            case .failure(let failure):
                print(failure)
            }
        })

        for i in savedRecipes {
            print("💩 \(i.title ?? "")")
        }

        XCTAssertTrue(savedRecipes.count == 2)
    }
    
    func testRemoveARecipeFromFavorites() {
        try? coreDataManager.removeAllRecipes()
        coreDataManager.saveRecipe(recipe: recipeForTest1)
        coreDataManager.saveRecipe(recipe: recipeForTest2)
        
        do {
            try coreDataManager.removeRecipe(uri: recipeForTest2.uri ?? "")
        } catch {
            print(error)
        }
        
        
        coreDataManager.getFavorites(completionHandler: { result in
            switch result {
            case .success(let recipes):
                self.savedRecipes = recipes
            case .failure(let failure):
                print(failure)
            }
        })
        
        for i in savedRecipes {
            print("👻 \(i.title ?? "")")
        }
        
        XCTAssertTrue(savedRecipes.count == 1)
        XCTAssertEqual(savedRecipes[0].title, recipeForTest1.title)
    }
    
    func testRemoveAllRecipesInFavorites() {
        try? coreDataManager.removeAllRecipes()
        coreDataManager.saveRecipe(recipe: recipeForTest1)
        coreDataManager.saveRecipe(recipe: recipeForTest2)
        
        do {
            try coreDataManager.removeAllRecipes()
        } catch {
            print(error)
        }
        
        coreDataManager.getFavorites(completionHandler: { result in
            switch result {
            case .success(let recipes):
                self.savedRecipes = recipes
            case .failure(let failure):
                print(failure)
            }
        })
        
        for i in savedRecipes {
            print("👺 \(i.title ?? "")")
        }
        
        XCTAssertTrue(savedRecipes.isEmpty)
    }
}
