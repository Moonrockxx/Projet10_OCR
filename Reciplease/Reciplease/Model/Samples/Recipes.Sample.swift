//
//  Recipes.Sample.swift
//  Reciplease
//
//  Created by TomF on 21/09/2022.
//

import Foundation

struct RecipesSamples {
    var title: String = ""
    var subtitle: String = ""
    var image: String = ""
    var likes: Int = 0
    var time: Int = 0
    var isFavorite: Bool = false
}

extension RecipesSamples {
    struct Samples {
        public var samples: [RecipesSamples] = [RecipesSamples(title: "Pizza",
                                          subtitle: "Mozzarella, Basil, Large tomate",
                                          image: "pasta-sample",
                                          likes: 2500,
                                          time: 3,
                                          isFavorite: false),
                                  RecipesSamples(title: "Quinoa Salad",
                                          subtitle: "Quinoa, Herbs, Chery tomatoes",
                                          image: "pasta-sample",
                                          likes: 1000,
                                          time: 10,
                                          isFavorite: false),
                                  RecipesSamples(title: "Pasta Salad",
                                          subtitle: "Pasta, Feta, Tomato",
                                          image: "pasta-sample",
                                          likes: 245,
                                          time: 60,
                                          isFavorite: false),
                                  RecipesSamples(title: "Tomato Soup",
                                          subtitle: "Carrot, Cream, Tomatoes, Basil",
                                          image: "pasta-sample",
                                          likes: 38,
                                          time: 30,
                                          isFavorite: false)]
    }
}
