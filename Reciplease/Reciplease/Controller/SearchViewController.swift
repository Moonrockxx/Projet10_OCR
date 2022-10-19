//
//  SearchViewController.swift
//  Reciplease
//
//  Created by TomF on 20/09/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var addIngredientButton: UIButton!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var clearIngredientListButton: UIButton!
    
    //MARK: Variables
    private var ingredients: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Function that prepare a segue
    /// - Parameters:
    ///   - segue: The segue targeted
    ///   - sender: An any sender
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueReciplease" {
            _ = segue.destination as? RecipesViewController
        }
    }
    
    /// Function used to dismiss the keyboard when the screen is tapped
    /// - Parameter sender: An any sender
    @IBAction func dismissKeyboard(_ sender: Any) {
        ingredientsTextField.resignFirstResponder()
    }
    
    /// Function used to clear the table view when the clear button is tapped
    /// - Parameter sender: An any sender
    @IBAction func clearList(_ sender: Any) {
        IngredientService.shared.removeIngredients()
        ingredientTableView.reloadData()
    }
    
    /// Function used to add an ingredient to the IngredientService ingredient and ingredientArray arrays, returns an error in case of empty textfield or duplicate ingredient, updates the view table and resets the textfield.
    /// - Parameter sender: An any sender
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
    
    /// Triggers the segue targeted
    /// - Parameter sender: An any sender
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


