//
//  ViewController+Extension.swift
//  Reciplease
//
//  Created by TomF on 28/09/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(vc: UIViewController?, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
            if vc is RecipesViewController {
                self.navigationController?.popViewController(animated: true)
            }
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
