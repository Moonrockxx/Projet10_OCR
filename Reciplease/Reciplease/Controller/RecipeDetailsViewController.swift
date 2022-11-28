//
//  RecipeDetailsViewController.swift
//  Reciplease
//
//  Created by TomF on 29/09/2022.
//

import UIKit
import SDWebImage

class RecipeDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var recipeDetailsTimeLabel: UILabel!
    @IBOutlet weak var recipeDetailLikeLabel: UILabel!
    @IBOutlet weak var recipeDetailImageAndTitleVIew: UIView!
    @IBOutlet weak var recipeDetailImage: UIImageView!
    @IBOutlet weak var recipeDetailTitle: UILabel!
    
    // MARK: - Constants
    let coreDataManager = CoreDataManager(managedObjectContext: CoreDataStack.shared.mainContext)
    
    // MARK: - Varaibles
    public var recipeDetails: RecipeDetail?
    public var favoriteRecipeDetails: SavedRecipes?
    var navigationIsOnFavorite: Bool?
    var previousTableView: UITableView!
    lazy var favoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favoriteButtonTapped))
        button.tintColor = .white
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeView()
    }
    
    /// This function will display a web view of the recipe on the edamam website
    /// - Parameter sender: The button "Get directions"
    @IBAction func getDirections(_ sender: Any) {
        guard navigationIsOnFavorite ?? true else {
            if let url = URL(string: recipeDetails?.url ?? "") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else {
                    self.presentAlert(title: "Error", message: "Unable to display the page for this recipe")
                }
                
            }
            return
        }
        
        if let url = URL(string: favoriteRecipeDetails?.url ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                self.presentAlert(title: "Error", message: "Unable to display the page for this recipe")
            }
        }
    }
    
    /// The function will allow you to add a recipe to the favorites, first we will look if the navigation is in Favorites mode and then we check that the recipe is not already present in the database. Depending on the conditions, we add or remove the recipe from the favorites
    @objc func favoriteButtonTapped() {
        guard self.navigationIsOnFavorite ?? true else {
            if coreDataManager.recipeIsAlreadySaved(url: recipeDetails?.url ?? "") {
                removeRecipe(uri: recipeDetails?.uri ?? "")
                favoriteButton.image = UIImage(systemName: "star")
            } else {
                guard let recipe = self.recipeDetails else { return }
                coreDataManager.saveRecipe(recipe: recipe)
                favoriteButton.image = UIImage(systemName: "star.fill")
            }
            return
        }
        
        if coreDataManager.recipeIsAlreadySaved(url: favoriteRecipeDetails?.url ?? "") {
            removeRecipe(uri: favoriteRecipeDetails?.uri ?? "")
            favoriteButton.image = UIImage(systemName: "star")

            self.navigationController?.popViewController(animated: true)
            self.previousTableView.reloadData()
        }
    }
    
    /// This function is used to call the removeRecipe method of the CoreDataManager for remove a recipe from favorites
    /// - Parameter uri: A String that represents a URI for a given recipe
    func removeRecipe(uri: String) {
        do {
            try coreDataManager.removeRecipe(uri: uri)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Function use to create the view with the RecipeDetail object received
    func makeView() {
        guard let condition = self.navigationIsOnFavorite else { return }
        navigationItem.title = "Reciplease"
        navigationItem.rightBarButtonItem = favoriteButton
        
        if coreDataManager.recipeIsAlreadySaved(url: condition ? favoriteRecipeDetails?.url ?? "" : recipeDetails?.url ?? "") {
            favoriteButton.image = UIImage(systemName: "star.fill")
        }
        
        if condition {
            self.recipeDetailTitle.text = favoriteRecipeDetails?.title
            self.recipeDetailImage.sd_setImage(with: URL(string: favoriteRecipeDetails?.recipeImage ?? ""))
            self.recipeDetailImage.contentMode = .scaleAspectFill
            self.recipeDetailLikeLabel.text = "\(favoriteRecipeDetails?.like ?? 0)"
            self.recipeDetailsTimeLabel.text = ((favoriteRecipeDetails?.time ?? 0) * 60).timeAsString(style: .abbreviated)
        } else {
            self.recipeDetailTitle.text = recipeDetails?.title
            self.recipeDetailImage.sd_setImage(with: URL(string: recipeDetails?.image ?? ""))
            self.recipeDetailImage.contentMode = .scaleAspectFill
            self.recipeDetailLikeLabel.text = "\(recipeDetails?.like ?? 0)"
            self.recipeDetailsTimeLabel.text = ((recipeDetails?.time ?? 0) * 60).timeAsString(style: .abbreviated)
        }
        
        let gradient = CAGradientLayer()
        let startColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0).cgColor
        let endColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        gradient.frame = CGRectMake(0, 0, recipeDetailImage.frame.width + 30, recipeDetailImage.frame.height + 30)
        gradient.colors = [startColor, endColor]
        recipeDetailImage.layer.insertSublayer(gradient, at: 0)
    }
}

extension RecipeDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let condition = self.navigationIsOnFavorite else { return 0 }
        
        if condition {
            let detailIngredients = favoriteRecipeDetails?.ingredientLines?.components(separatedBy: ",")
            guard let count = detailIngredients?.count else { return 0 }
            return count
        } else {
            guard let count = recipeDetails?.detailIngredients?.count else { return 0 }
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientLineCell", for: indexPath)
        
        guard self.navigationIsOnFavorite ?? false else {
            if let line = recipeDetails?.detailIngredients?[indexPath.row] {
                cell.textLabel?.text = "- " + line
                cell.textLabel?.textColor = UIColor.white
            }
            
            return cell
        }
        
        let detailIngredients = favoriteRecipeDetails?.ingredientLines?.components(separatedBy: ",")
        if let line = detailIngredients?[indexPath.row] {
            cell.textLabel?.text = "- " + line
            cell.textLabel?.textColor = UIColor.white
        }
        
        return cell
    }
}
