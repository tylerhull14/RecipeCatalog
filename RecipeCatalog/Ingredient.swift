//
//  Ingredient.swift
//  RecipeCatalog
//
//  Created by Tyler Hull on 11/25/24.
//

import Foundation
import SwiftData

@Model
class Ingredient {
    var quantity: String      // "1 C.", "½ tsp.", "to taste"
    var name: String         // Changed from 'description' to 'name'
    var notes: String?       // "finely chopped"
    var order: Int           // for sorting
    
    @Relationship(deleteRule: .nullify) var recipe: Recipe?
    
    init(quantity: String = "",
         name: String = "",
         notes: String? = nil,
         order: Int = 0) {
        self.quantity = quantity
        self.name = name
        self.notes = notes
        self.order = order
    }
}

// Add Hashable conformance
extension Ingredient: Hashable {
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.quantity == rhs.quantity &&
        lhs.name == rhs.name &&
        lhs.order == rhs.order
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(quantity)
        hasher.combine(name)
        hasher.combine(order)
    }
}
