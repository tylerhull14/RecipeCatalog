//
//  ContentView.swift
//  RecipeCatalog
//
//  Created by Tyler Hull on 11/25/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selectedRecipe: Recipe?
    
    var body: some View {
        if horizontalSizeClass == .compact {
            // iPhone layout
            RecipeListView()
        } else {
            // iPad layout with split view
            NavigationSplitView {
                RecipeListView(selectedRecipe: $selectedRecipe)
            } detail: {
                if let recipe = selectedRecipe {
                    RecipeDetailView(recipe: recipe)
                } else {
                    Text("Select a Recipe")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
