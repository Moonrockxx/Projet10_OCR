//
//  RecipeDetailsViewController.swift
//  Reciplease
//
//  Created by TomF on 29/09/2022.
//

import UIKit
import SDWebImage

class RecipeDetailsViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var recipeDetailsTimeLabel: UILabel!
    @IBOutlet weak var recipeDetailLikeLabel: UILabel!
    @IBOutlet weak var recipeDetailImageAndTitleVIew: UIView!
    @IBOutlet weak var recipeDetailImage: UIImageView!
    @IBOutlet weak var recipeDetailTitle: UILabel!
    
    //MARK: Properties
    public var recipeDetails: RecipeDetail?
    
    let coreDataManager = CoreDataManager(managedObjectContext: CoreDataStack.sharedInstance.mainContext)
    
    lazy var favoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favoriteButtonTapped))
        button.tintColor = .white
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeView()
    }
    
    @objc func favoriteButtonTapped() {
        if coreDataManager.recipeIsAlreadySaved(url: recipeDetails?.url ?? "") {
            favoriteButton.image = UIImage(systemName: "star")
        } else {
            guard let recipe = self.recipeDetails else { return }
            coreDataManager.saveRecipe(recipe: recipe)
            favoriteButton.image = UIImage(systemName: "star.fill")
        }
    }
    
    /// Function use to create the view with the RecipeDetail object received
    func makeView() {
        navigationItem.title = "Reciplease"
        navigationItem.rightBarButtonItem = favoriteButton
        
        if coreDataManager.recipeIsAlreadySaved(url: recipeDetails?.url ?? "") {
            favoriteButton.image = UIImage(systemName: "star.fill")
        }
        
        self.recipeDetailTitle.text = recipeDetails?.title
        self.recipeDetailImage.sd_setImage(with: URL(string: recipeDetails?.image ?? ""))
        self.recipeDetailImage.contentMode = .scaleAspectFill
        self.recipeDetailLikeLabel.text = "\(recipeDetails?.like ?? 0)"
        self.recipeDetailsTimeLabel.text = ((recipeDetails?.time ?? 0) * 60).timeAsString(style: .abbreviated)
        
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
        guard let count = recipeDetails?.detailIngredients?.count else { return 0 }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientLineCell", for: indexPath)
        if let line = recipeDetails?.detailIngredients?[indexPath.row] {
            cell.textLabel?.text = "- " + line
            cell.textLabel?.textColor = UIColor.white
        }
        
        return cell
    }
}
