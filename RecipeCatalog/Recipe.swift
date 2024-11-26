//
//  Recipe.swift
//  RecipeCatalog
//
//  Created by Tyler Hull on 11/25/24.
//

import Foundation
import SwiftData

@Model
class Recipe {
    var title: String
    var author: String
    var dateCreated: Date
    var timeRequired: Int // in minutes
    var servings: Int
    var expertiseRequired: String
    var caloriesPerServing: Int
    var isFavorite: Bool
    var notes: String?
    
    // Relationships
    @Relationship(deleteRule: .cascade) var ingredients: [Ingredient]
    @Relationship(deleteRule: .cascade) var instructions: [Instruction]
    @Relationship(deleteRule: .nullify) var categories: [Category]
    
    init(title: String = "",
         author: String = "",
         timeRequired: Int = 0,
         servings: Int = 1,
         expertiseRequired: String = "Beginner",
         caloriesPerServing: Int = 0,
         notes: String? = nil) {
        self.title = title
        self.author = author
        self.dateCreated = Date()
        self.timeRequired = timeRequired
        self.servings = servings
        self.expertiseRequired = expertiseRequired
        self.caloriesPerServing = caloriesPerServing
        self.isFavorite = false
        self.notes = notes
        self.ingredients = []
        self.instructions = []
        self.categories = []
    }
}

// Add Hashable conformance
extension Recipe: Hashable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.title == rhs.title && lhs.dateCreated == rhs.dateCreated
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(dateCreated)
    }
}
