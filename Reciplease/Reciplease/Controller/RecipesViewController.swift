//
//  RecipesViewController.swift
//  Reciplease
//
//  Created by TomF on 21/09/2022.
//

import UIKit
import SDWebImage

class RecipesViewController: UIViewController {

    @IBOutlet weak var recipesTableView: UITableView!
    public var recipes: Recipes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueRecipeDetail" {
            let detailVC = segue.destination as? RecipeDetailsViewController
            let hit = sender as? Hit
            detailVC?.hit = hit
        }
    }
}

extension RecipesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.recipes?.hits?.count else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipesTableViewCell else {
            return UITableViewCell()
        }
        
        let recipe = recipes?.hits?[indexPath.row]
        cell.configure(like: Int.random(in: 1..<5000),
                       time: recipe?.recipe?.totalTime ?? 0,
                       title: recipe?.recipe?.label ?? "N/A",
                       subtitle: recipe?.recipe?.ingredientLines?.joined(separator: ", ") ?? "N/A")
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width + 50, height: cell.frame.height))
        imageView.sd_setImage(with: URL(string: recipe?.recipe?.images?.regular?.url ?? ""))
        imageView.contentMode = .scaleAspectFill
        
        let gradient = CAGradientLayer()
        gradient.frame = imageView.bounds
        let startColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        let endColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        gradient.colors = [startColor, endColor]
        imageView.layer.insertSublayer(gradient, at: 0)
        
        cell.backgroundView = UIView()
        cell.backgroundView!.addSubview(imageView)
        
        return cell
    }
}

extension RecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueRecipeDetail", sender: recipes?.hits?[indexPath.row])
    }
}
