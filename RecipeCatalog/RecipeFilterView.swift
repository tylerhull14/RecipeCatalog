//
//  RecipeFilterView.swift
//  RecipeCatalog
//
//  Created by Tyler Hull on 11/25/24.
//

import SwiftUI
import SwiftData

struct RecipeFilterView: View {
    @Binding var selectedCategory: Category?
    @Binding var showingFavoritesOnly: Bool
    @Query private var categories: [Category]
    
    var body: some View {
        List {
            Section("Filters") {
                Toggle("Favorites Only", isOn: $showingFavoritesOnly)
                
                Picker("Category", selection: $selectedCategory) {
                    Text("All Categories").tag(nil as Category?)
                    ForEach(categories) { category in
                        Text(category.name).tag(category as Category?)
                    }
                }
            }
        }
        .navigationTitle("Filter Recipes")
    }
}
