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

    @IBAction func dismissKeyboard(_ sender: Any) {
        ingredientsTextField.resignFirstResponder()
    }
    
    @IBAction func clearList(_ sender: Any) {
        IngredientService.shared.removeAll()
        ingredientTableView.dataSource = nil
        ingredientTableView.reloadData()
    }
    
    @IBAction func addIngredient(_ sender: Any) {
        guard let ingredientNames = ingredientsTextField.text else { return }
        
        let array = ingredientNames.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespacesAndNewlines)) }
        array.forEach { name in
            let ingredient = IngredientSamples(name: name)
            self.ingredients.append(name)
            IngredientService.shared.add(ingredient: ingredient)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.ingredientTableView.reloadData()
            self.ingredientsTextField.text = ""
        }
    }
    
    @IBAction func goToRecipesList(_ sender: Any) {
        APIService.shared.getRecipes(ingredients: ingredients) { result in
            switch result {
            case .success(let recipes):
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "Reciplease", sender: recipes)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentAlert(title: "Error", message: error.description)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Reciplease" {
            let recipesVC = segue.description as? RecipesViewController
            let recipes = sender as? Recipes
            recipesVC?.recipes = recipes
        }
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

extension String {
    func trimmingLeadingAndTrailingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        return trimmingCharacters(in: characterSet)
    }
}
