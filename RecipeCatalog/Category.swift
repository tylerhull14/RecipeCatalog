//
//  Category.swift
//  RecipeCatalog
//
//  Created by Tyler Hull on 11/25/24.
//

import Foundation
import SwiftData

@Model
class Category {
    var name: String
    @Relationship(deleteRule: .nullify) var recipes: [Recipe]
    
    init(name: String = "") {
        self.name = name
        self.recipes = []
    }
}

// Add Hashable conformance
extension Category: Hashable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
