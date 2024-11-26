//
//  RecipeDetailView.swift
//  RecipeCatalog
//
//  Created by Tyler Hull on 11/25/24.
//

import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var recipe: Recipe
    @State private var isEditing = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Meta Information
                Group {
                    Text(recipe.title)
                        .font(.largeTitle)
                    
                    Text("By \(recipe.author)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Label("\(recipe.timeRequired) minutes", systemImage: "clock")
                        Spacer()
                        Label("\(recipe.servings) servings", systemImage: "person.2")
                        Spacer()
                        Label("\(recipe.caloriesPerServing) cal/serving", systemImage: "flame")
                    }
                    .foregroundColor(.secondary)
                    
                    Text("Expertise Level: \(recipe.expertiseRequired)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Categories
                if !recipe.categories.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(recipe.categories) { category in
                                Text(category.name)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(Color.gray.opacity(0.2))
                                    )
                            }
                        }
                    }
                }
                
                // Ingredients Section
                Section(header: Text("Ingredients").font(.headline)) {
                    ForEach(recipe.ingredients.sorted(by: { $0.order < $1.order })) { ingredient in
                        HStack {
                            Text("\(ingredient.quantity) \(ingredient.name)")
                            if let notes = ingredient.notes {
                                Text(notes)
                                    .italic()
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
                
                // Instructions Section
                Section(header: Text("Instructions").font(.headline)) {
                    ForEach(recipe.instructions.sorted(by: { $0.order < $1.order })) { instruction in
                        Text("\(instruction.order). \(instruction.details)")
                            .padding(.vertical, 4)
                    }
                }
                
                if let notes = recipe.notes {
                    Section(header: Text("Notes").font(.headline)) {
                        Text(notes)
                    }
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    isEditing = true
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    recipe.isFavorite.toggle()
                }) {
                    Image(systemName: recipe.isFavorite ? "star.fill" : "star")
                        .foregroundColor(recipe.isFavorite ? .yellow : .gray)
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            NavigationStack {
                AddRecipeView(recipe: recipe)
            }
        }
    }
}

// Helper extension for conditional modifiers
extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
