//
//  RecipesViewController.swift
//  Reciplease
//
//  Created by TomF on 21/09/2022.
//

import UIKit

class RecipesViewController: UIViewController {

    @IBOutlet weak var recipesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RecipesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Recipes.Samples().samples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipesTableViewCell else {
            return UITableViewCell()
        }
        let recipe = Recipes.Samples().samples[indexPath.row]

        cell.configure(like: recipe.likes, time: recipe.time, title: recipe.title, subtitle: recipe.subtitle)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width + 50, height: cell.frame.height))
        let image = UIImage(named: recipe.image)
        imageView.image = image
        cell.backgroundView = UIView()
        cell.backgroundView!.addSubview(imageView)
        
        
        return cell
    }
}
