//
//  RecipeDetailsViewController.swift
//  Reciplease
//
//  Created by TomF on 29/09/2022.
//

import UIKit
import SDWebImage

class RecipeDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIView!
    public var hit: Hit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension RecipeDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = hit?.recipe?.ingredientLines?.count else {
            return 0
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientLineCell", for: indexPath)
        let ingredient = hit?.recipe?.ingredientLines?[indexPath.row]
        cell.textLabel?.text = ingredient
        
        return cell
    }
}
