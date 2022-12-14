//
//  APIService.swift
//  Reciplease
//
//  Created by TomF on 28/09/2022.
//

import Foundation
import Alamofire

/// An enumeration for the API errors
enum APIError: Error {
    case data
    case badRequest
}

class APIService {
    
    // MARK: - Variables
    var session: SessionProtocol
    var ingredientsArray: [String] = []

    init(session: SessionProtocol) {
        self.session = session
    }
    
    /// Function used to build the url use on the getRecipes function
    /// - Returns: URL
    func makeURL(ingredients: [String]? = nil) -> URL {
        for ingredient in IngredientService.shared.ingredients {
            ingredientsArray.append(ingredient.name)
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.edamam.com"
        components.path = "/api/recipes/v2"
        components.queryItems = [
            URLQueryItem(name: "type", value: "public"),
            URLQueryItem(name: "app_id", value: Bundle.main.infoDictionary?["EDAMAM_APP_ID"] as? String),
            URLQueryItem(name: "app_key", value: Bundle.main.infoDictionary?["EDAMAM_API_KEY"] as? String),
            URLQueryItem(name: "time", value: "10-60"),
            URLQueryItem(name: "imageSize", value: "REGULAR"),
            URLQueryItem(name: "q", value: ingredientsArray.joined(separator: ","))
        ]
        
        guard let url = components.url else {
            return URL(string: "")!
        }
        
        return url
    }
    
    /// Function used to get the recipes
    /// - Parameter completion: A Result that gives a Recipes when success or an APIError when failure
    func getRecipes(ingredients: [String]? = nil, completion: @escaping (Result<Recipes, APIError>) -> Void) {
        session.request(url: makeURL()) { data, response, _ in
            guard let data = data else {
                completion(.failure(.data))
                return
            }
            
            guard response?.statusCode == 200 else {
                completion(.failure(.badRequest))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let recipes = try decoder.decode(Recipes.self, from: data)
                completion(.success(recipes))
            } catch {
                completion(.failure(.data))
            }
        }
    }
}
