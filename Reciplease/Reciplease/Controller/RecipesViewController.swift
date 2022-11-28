//
//  RecipesViewController.swift
//  Reciplease
//
//  Created by TomF on 21/09/2022.
//

import UIKit
import SDWebImage

class RecipesViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Constants
    private let apiService = APIService(session: AlamofireClient() as SessionProtocol)
    let coreDataManager = CoreDataManager(managedObjectContext: CoreDataStack.shared.mainContext)
    
    // MARK: - Variables
    public var favoritesRecipes: [SavedRecipes] = [] {
        didSet {
            DispatchQueue.main.async {
                self.recipesTableView.reloadData()
            }
        }
    }
    
    var recipes: [RecipeDetail?] = [] {
        didSet {
            DispatchQueue.main.async {
                self.recipesTableView.reloadData()
            }
        }
    }
    
    var navigationIsOnFavorite: Bool {
        if navigationController?.tabBarController?.tabBar.selectedItem?.title == "Favorites" {
            return true
        } else {
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !navigationIsOnFavorite {
            do {
                try getRecipes()
            } catch let error as APIError {
                self.presentAlert(title: "An error occured", message: error.localizedDescription)
            } catch {
                self.presentAlert(title: "Error", message: "Unknown error")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if navigationIsOnFavorite {
            coreDataManager.getFavorites(completionHandler: { result in
                switch result {
                case .success(let recipes):
                    if recipes.isEmpty {
                        self.hideLoader()
                        self.showEmptyFavorites(error: "No favorites registred, add ingredients to get recipes that you can save as favorites to find them here")
                    } else {
                        self.favoritesRecipes = recipes
                        self.hideLoader()
                    }
                    
                case .failure(let error):
                    self.showEmptyFavorites(error: error.localizedDescription)
                }
            })
        }
        
    }
    
    /// This function is used when the favorites list is empty, she hides the loader and the table view to display an error message
    /// - Parameter error: A string that describe the error
    private func showEmptyFavorites(error: String) {
        self.loader.isHidden = true
        self.recipesTableView.isHidden = true
        
        self.errorLabel.isHidden = false
        self.errorLabel.text = error
    }
    
    /// This function is used to hide the loader and display the list of recipes/favorites
    func hideLoader() {
        self.loader.isHidden = true
        self.recipesTableView.isHidden = false
    }
    
    /// Function used to get the recipes and store them in the recipes array
    func getRecipes() throws {
        apiService.getRecipes { result in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let recipes):
                    let recipeArray = recipes.hits?.map({ $0.recipe?.toRecipe() })
                    
                    if let unwrappedRecipeArray = recipeArray {
                        if unwrappedRecipeArray.count == 0 {
                            strongSelf.presentAlert(title: "Something went wrong", message: "No recipes found", handler: { _ in
                                strongSelf.navigationController?.popViewController(animated: true)
                            })
                        } else {
                            strongSelf.recipes = unwrappedRecipeArray
                            strongSelf.hideLoader()
                        }
                    }
                case .failure(let error):
                    strongSelf.presentAlert(title: "Error", message: error.description, handler: { _ in
                        strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
}

extension RecipesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if navigationIsOnFavorite {
            return favoritesRecipes.count
        } else {
            return recipes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipesTableViewCell else {
            return UITableViewCell()
        }
        
        if navigationIsOnFavorite {
            guard indexPath.row < favoritesRecipes.count else {
                return cell
            }
            
            let favoriteRecipe = favoritesRecipes[indexPath.row]
            cell.configure(like: "\(favoriteRecipe.like)",
                           time: ((favoriteRecipe.time) * 60).timeAsString(style: .abbreviated),
                           title: favoriteRecipe.title,
                           subtitle: favoriteRecipe.subtitle,
                           image: favoriteRecipe.recipeImage,
                           uri: favoriteRecipe.uri)
            
            return cell
        } else {
            guard indexPath.row < recipes.count else {
                return cell
            }
            
            let recipe = recipes[indexPath.row]
            cell.configure(like: "\(recipe?.like ?? 0)",
                           time: ((recipe?.time ?? 0) * 60).timeAsString(style: .abbreviated),
                           title: recipe?.title,
                           subtitle: recipe?.subtitle,
                           image: recipe?.image,
                           uri: recipe?.uri)
            
            return cell
        }
    }
}

extension RecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if navigationIsOnFavorite {
            if indexPath.row < favoritesRecipes.count {
                let recipe = favoritesRecipes[indexPath.row]
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let detailsVC = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as! RecipeDetailsViewController
                detailsVC.favoriteRecipeDetails = recipe
                detailsVC.navigationIsOnFavorite = self.navigationIsOnFavorite
                detailsVC.previousTableView = self.recipesTableView
                
                self.navigationController?.pushViewController(detailsVC, animated: true)
            }
        } else {
            if indexPath.row < recipes.count {
                let recipe = recipes[indexPath.row]
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let detailsVC = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as! RecipeDetailsViewController
                detailsVC.recipeDetails = recipe
                detailsVC.navigationIsOnFavorite = self.navigationIsOnFavorite
                
                self.navigationController?.pushViewController(detailsVC, animated: true)
            }
        }
    }
}
