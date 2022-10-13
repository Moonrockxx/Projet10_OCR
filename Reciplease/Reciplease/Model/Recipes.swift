//
//  Recipes.swift
//  Reciplease
//
//  Created by TomF on 28/09/2022.
//

import Foundation

struct Recipes: Codable {
    var from: Int?
    var to: Int?
    var count: Int?
    var links: Links?
    var hits: [Hit]?
    
    enum CodingKeys: String, CodingKey {
        case from
        case to
        case count
        case links = "_links"
        case hits
    }
}

struct Links: Codable {
    var next: Link?
}

struct Link: Codable {
    var href: String?
    var title: String?
}

struct Hit: Codable {
    var recipe: Recipe?
    var link: SelfLinks?
    
    enum CodingKeys: String, CodingKey {
        case recipe
        case link = "_links"
    }
}

struct SelfLinks: Codable {
    var selfLink: SelfLink?
    
    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
    }
}

struct SelfLink: Codable {
    var title: String?
    var href: String?
}

struct Recipe: Codable {
    var uri: String?
    var label: String?
    var image: String?
    var images: Images?
    var source: String?
    var url: String?
    var shareAs: String?
    var yield: Double?
    var dietLabels: [String]?
    var healthLabels: [String]?
    var cautions: [String]?
    var ingredientLines: [String]?
    var ingredients: [Ingredient]?
    var calories: Double?
    var totalWeight: Double?
    var totalTime: Double?
    var cuisineType: [String]?
    var mealType: [String]?
    var dishType: [String]?
}

struct Images: Codable {
    var thumbnail: Image?
    var small: Image?
    var regular: Image?
    var large: Image?
    
    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
        case large = "LARGE"
    }
}

struct Image: Codable {
    var url: String?
    var width: Int?
    var height: Int?
}

struct Ingredient: Codable {
    var text: String?
    var quantity: Double?
    var measure: String?
    var food: String?
    var weight: Double?
    var foodCategory: String?
    var foodId: String?
    var image: String?
}
