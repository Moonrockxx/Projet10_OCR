//
//  RecipesViewController.swift
//  Reciplease
//
//  Created by TomF on 21/09/2022.
//

import UIKit
import SDWebImage

class RecipesViewController: UIViewController {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var recipesTableView: UITableView!
    
    var recipes: [RecipeDetail?] = [] {
        didSet {
            DispatchQueue.main.async {
                self.recipesTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRecipes()
    }
    
    func getRecipes() {
        APIService.shared.getRecipes { result in
            switch result {
            case .success(let recipes):
                let recipes = recipes.hits?.map({ $0.recipe?.toRecipe() })
                guard recipes?.count == 0 else {
                    self.recipes = recipes ?? []
                    self.loader.isHidden = true
                    self.recipesTableView.isHidden = false
                    return
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentAlert(vc: self, title: "Error", message: error.description)
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
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipesTableViewCell else {
            return UITableViewCell()
        }
        
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

extension RecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < recipes.count {
            let recipe = recipes[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailsVC = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as! RecipeDetailsViewController
            detailsVC.recipeDetails = recipe
            
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}
