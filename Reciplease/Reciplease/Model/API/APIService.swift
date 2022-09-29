//
//  APIService.swift
//  Reciplease
//
//  Created by TomF on 28/09/2022.
//

import Foundation
import Alamofire

enum APIError: Error {
    case decoding
    case server
    case network
    
    var description : String {
        switch self {
        case APIError.decoding:
            return "An error occured when decoding datas"
        case APIError.network:
            return "Network error"
        case APIError.server:
            return "Server error"
        }
    }
}

class APIService {
    static let shared = APIService()
    private let manager: Session
    
    init(manager: Session = Session.default) {
        self.manager = manager
    }
    
    func getRecipes(ingredients: [String], completion: @escaping (Result<Recipes, APIError>) -> Void) {
        
        let ingredientsList = ingredients.map({$0.replacingOccurrences(of: " ", with: "%20")}).joined(separator: ",")
        
        manager.request("https://api.edamam.com/api/recipes/v2?type=public&app_id=b249e3df&app_key=2aa7376e982fbc0f0f0f88c4b59ff6ae&time=10-60&imageSize=REGULAR&q=cheese,tomatoes,mustard")
            .validate(statusCode: 200..<299)
            .responseData { response in
                switch response.result {
                case .success(let recipes):
                    switch response.response?.statusCode {
                    case 200:
                        guard let recipes = try? JSONDecoder().decode(Recipes.self, from: recipes) else {
                            return
                        }
                        completion(.success(recipes))
                    case 400,404:
                        completion(.failure(.network))
                    case 500,502,503:
                        completion(.failure(.server))
                    default:
                        completion(.failure(.decoding))
                    }
                case .failure(_):
                    completion(.failure(.server))
                }
            }
    }
}
