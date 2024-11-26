//
//  RecipeCatalogApp.swift
//  RecipeCatalog
//
//  Created by Tyler Hull on 11/25/24.
//

import SwiftUI
import SwiftData

@main
struct RecipeCatalogApp: App {
    let container: ModelContainer
    
    init() {
        do {
            let schema = Schema([
                Recipe.self,
                Ingredient.self,
                Instruction.self,
                Category.self
            ])
            
            let config = ModelConfiguration("RecipeDatabase")
            container = try ModelContainer(for: schema, configurations: config)
            
            // Initialize with sample data if needed
            let context = ModelContext(container)
            let descriptor = FetchDescriptor<Recipe>()
            let recipeCount = try context.fetch(descriptor)
            
            if recipeCount.isEmpty {
                SampleRecipes.addSampleData(to: context)
            }
            
        } catch {
            print("Error: \(error.localizedDescription)")
            fatalError("Could not configure ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
