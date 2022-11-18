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
    
    var savedRecipesService: SavedRecipesService!
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
        coreDataStack = CoreDataTestsStack()
        savedRecipesService = SavedRecipesService(coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        savedRecipesService = nil
        self.savedRecipes = []
    }
    
    func testCheckForDuplicateRecipesBeforeSaving() {
        savedRecipesService.saveRecipe(recipe: recipeForTest1)
        savedRecipesService.saveRecipe(recipe: recipeForTest2)
        
        savedRecipesService.getFavorites(completionHandler: { result in
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
        
        let isDuplicate = savedRecipesService.recipeIsAlreadySaved(url: recipeForTest1.url ?? "")
        
        XCTAssertTrue(isDuplicate)
    }
    
    func testSaveARecipeAsFavorite() {
        savedRecipesService.saveRecipe(recipe: recipeForTest1)
        
        XCTAssertEqual(recipeForTest1.title, "Steak Frites")
        XCTAssertEqual(recipeForTest1.subtitle, "Avec du ketchup")
        XCTAssertEqual(recipeForTest1.like, 33)
        XCTAssertEqual(recipeForTest1.time, 30)
        XCTAssertEqual(recipeForTest1.detailIngredients, ["pomme de terre", "viande hachée", "huile de friture"])
        XCTAssertEqual(recipeForTest1.uri, "www.marmiton.org")
        XCTAssertEqual(recipeForTest1.url, "https://www.marmiton.org")
    }
    
    func testFetchFavorites() {
        savedRecipesService.saveRecipe(recipe: recipeForTest1)
        savedRecipesService.saveRecipe(recipe: recipeForTest2)
        
        savedRecipesService.getFavorites(completionHandler: { result in
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
        XCTAssertEqual(savedRecipes[1].title, recipeForTest1.title)
    }
    
    func testRemoveARecipeFromFavorites() {
        savedRecipesService.saveRecipe(recipe: recipeForTest1)
        savedRecipesService.saveRecipe(recipe: recipeForTest2)
        
        do {
            try savedRecipesService.removeRecipe(uri: recipeForTest2.uri ?? "")
        } catch {
            print(error)
        }
        
        
        savedRecipesService.getFavorites(completionHandler: { result in
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
        savedRecipesService.saveRecipe(recipe: recipeForTest1)
        savedRecipesService.saveRecipe(recipe: recipeForTest2)
        
        do {
            try savedRecipesService.removeAllRecipes()
        } catch {
            print(error)
        }
        
        savedRecipesService.getFavorites(completionHandler: { result in
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
