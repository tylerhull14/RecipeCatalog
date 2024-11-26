//
//  Instruction.swift
//  RecipeCatalog
//
//  Created by Tyler Hull on 11/25/24.
//

import Foundation
import SwiftData

@Model
class Instruction {
    var order: Int
    var details: String
    @Relationship(deleteRule: .nullify) var recipe: Recipe?
    
    init(order: Int = 0, details: String = "") {
        self.order = order
        self.details = details
    }
}

// Add Hashable conformance
extension Instruction: Hashable {
    static func == (lhs: Instruction, rhs: Instruction) -> Bool {
        lhs.order == rhs.order && lhs.details == rhs.details
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(order)
        hasher.combine(details)
    }
}
