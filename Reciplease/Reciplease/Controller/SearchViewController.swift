//
//  SearchViewController.swift
//  Reciplease
//
//  Created by TomF on 20/09/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var addIngredientButton: UIButton!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var clearIngredientListButton: UIButton!
    
    private var ingredients: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueReciplease" {
            _ = segue.destination as? RecipesViewController
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        ingredientsTextField.resignFirstResponder()
    }
    
    @IBAction func clearList(_ sender: Any) {
        IngredientService.shared.removeIngredients()
        ingredientTableView.reloadData()
    }
    
    @IBAction func addIngredient(_ sender: Any) {
        guard let ingredientName = ingredientsTextField.text else {
            presentAlert(title: "Error", message: "Field can't be blank")
            return
        }

        let ingredient = Ingredients(name: ingredientName)
        
        do {
            try IngredientService.shared.add(ingredient: ingredient)
        } catch IngredientError.doublon {
            presentAlert(title: "Error", message: "You can't add an ingredient twice")
        } catch {
            presentAlert(title: "Error", message: "Adding the ingredient failed")
        }
        
        self.ingredientTableView.reloadData()
        self.ingredientsTextField.text = ""
    }
    
    @IBAction func goToRecipesList(_ sender: Any) {
        self.performSegue(withIdentifier: "SegueReciplease", sender: ingredients)
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IngredientService.shared.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        let ingredient = IngredientService.shared.ingredients[indexPath.row]
        cell.textLabel?.text = "- \(ingredient.name.trimmingLeadingAndTrailingSpaces())"
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            IngredientService.shared.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


