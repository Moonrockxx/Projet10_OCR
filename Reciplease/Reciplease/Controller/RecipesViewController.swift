//
//  RecipesViewController.swift
//  Reciplease
//
//  Created by TomF on 21/09/2022.
//

import UIKit
import SDWebImage

class RecipesViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!

    
    //MARK: Variables
    let coreDataManager = CoreDataManager(managedObjectContext: CoreDataStack.sharedInstance.mainContext)
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
        self.getRecipes()
        if navigationIsOnFavorite {
            coreDataManager.getFavorites(completionHandler: { result in
                switch result {
                case .success(let favorites):
                    self.favoritesRecipes = favorites
                case .failure(let error):
                    self.showEmptyFavorites(error: error.title)
                }
            })
        }
    }
    
    private func showEmptyFavorites(error: String) {
//        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.recipesTableView.isHidden = true
            
            self.errorLabel.isHidden = false
            self.errorLabel.text = error
//        }
    }
    
    /// Function used to get the recipes and store them in the recipes array
    func getRecipes() {
        APIService.shared.getRecipes { result in
            switch result {
            case .success(let recipes):
                let recipes = recipes.hits?.map({ $0.recipe?.toRecipe() })
                
                if recipes?.count == 0 {
                    self.presentAlert(title: "Something went wrong", message: "No recipes found", handler: { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                } else {
                    self.recipes = recipes ?? []
                    self.loader.isHidden = true
                    self.recipesTableView.isHidden = false
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentAlert(title: "Error", message: error.description, handler: { _ in
                        self.navigationController?.popViewController(animated: true)
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
