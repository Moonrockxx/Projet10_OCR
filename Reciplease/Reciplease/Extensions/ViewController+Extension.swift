//
//  ViewController+Extension.swift
//  Reciplease
//
//  Created by TomF on 28/09/2022.
//

import Foundation
import UIKit

extension UIViewController {
    /// Function that present an Alert
    /// - Parameters:
    ///   - title: The title of the Alert
    ///   - message: The message of the Alert
    ///   - handler: Use to dismiss an UIViewController when needed
    func presentAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: handler)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
