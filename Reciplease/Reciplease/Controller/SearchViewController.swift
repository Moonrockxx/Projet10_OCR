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
        guard let name = ingredientsTextField.text else { return }
        let ingredient = Ingredient(name: name)
        IngredientService.shared.add(ingredient: ingredient)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.ingredientTableView.reloadData()
            self.ingredientsTextField.text = ""
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
        cell.textLabel?.text = "- \(ingredient.name)"
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
