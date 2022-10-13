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
    
    func makeURL(ingredients: [String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.edamam.com"
        components.path = "/api/recipes/v2"
        components.queryItems = [
            URLQueryItem(name: "type", value: "public"),
            URLQueryItem(name: "app_id", value: "b249e3df"),
            URLQueryItem(name: "app_key", value: "2aa7376e982fbc0f0f0f88c4b59ff6ae"),
            URLQueryItem(name: "time", value: "10-60"),
            URLQueryItem(name: "imageSize", value: "REGULAR"),
            URLQueryItem(name: "q", value: ingredients.map({$0.replacingOccurrences(of: " ", with: "%20")}).joined(separator: ","))
        ]
        
        guard let url = components.url else {
            return URL(string: "")!
        }
        
        return url
    }
    
    func getRecipes(ingredients: [String], completion: @escaping (Result<Recipes, APIError>) -> Void) {
        manager.request(makeURL(ingredients: ingredients))
            .validate(statusCode: 200..<299)
            .responseData { response in
                switch response.result {
                case .success(let recipes):
                    switch response.response?.statusCode {
                    case 200:
                        do {
                            let recipes = try JSONDecoder().decode(Recipes.self, from: recipes)
                            completion(.success(recipes))
                        } catch {
                            print(error)
                        }
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
