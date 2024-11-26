//
//  AddRecipeView.swift
//  RecipeCatalog
//
//  Created by Tyler Hull on 11/25/24.
//

import SwiftUI
import SwiftData

struct AddRecipeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // If recipe is nil, we're creating a new recipe
    var recipe: Recipe?
    
    // Form fields
    @State private var title = ""
    @State private var author = ""
    @State private var timeRequired = 30
    @State private var servings = 4
    @State private var expertiseRequired = "Beginner"
    @State private var caloriesPerServing = 0
    @State private var notes = ""
    @State private var ingredients: [IngredientFormItem] = [IngredientFormItem()]
    @State private var instructions: [InstructionFormItem] = [InstructionFormItem()]
    @State private var selectedCategories: Set<Category> = []
    
    // State for showing category sheet
    @State private var showingCategorySheet = false
    
    // Query for existing categories
    @Query private var categories: [Category]
    
    let expertiseLevels = ["Beginner", "Intermediate", "Advanced", "Expert"]
    
    var body: some View {
        Form {
            Section("Basic Information") {
                TextField("Title", text: $title)
                TextField("Author", text: $author)
                Stepper("Time Required: \(timeRequired) minutes", value: $timeRequired, in: 1...999)
                Stepper("Servings: \(servings)", value: $servings, in: 1...99)
                Picker("Expertise Required", selection: $expertiseRequired) {
                    ForEach(expertiseLevels, id: \.self) { level in
                        Text(level).tag(level)
                    }
                }
                Stepper("Calories per serving: \(caloriesPerServing)", value: $caloriesPerServing, in: 0...9999)
            }
            
            Section("Ingredients") {
                ForEach($ingredients) { $ingredient in
                    HStack {
                        TextField("Quantity", text: $ingredient.quantity)
                            .frame(width: 100)
                        TextField("Ingredient", text: $ingredient.name)
                        TextField("Notes", text: $ingredient.notes)
                            .frame(width: 100)
                    }
                }
                
                Button("Add Ingredient") {
                    ingredients.append(IngredientFormItem())
                }
            }
            
            Section("Instructions") {
                ForEach($instructions) { $instruction in
                    HStack {
                        Text("\(instruction.order).")
                            .frame(width: 30)
                        TextField("Step", text: $instruction.details)
                    }
                }
                
                Button("Add Step") {
                    let newOrder = instructions.count + 1
                    instructions.append(InstructionFormItem(order: newOrder))
                }
            }
            
            Section("Categories") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(selectedCategories), id: \.self) { category in
                            CategoryChip(category: category) {
                                selectedCategories.remove(category)
                            }
                        }
                        
                        Button(action: { showingCategorySheet = true }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
            
            Section("Notes (Optional)") {
                TextEditor(text: $notes)
                    .frame(height: 100)
            }
        }
        .navigationTitle(recipe == nil ? "New Recipe" : "Edit Recipe")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveRecipe()
                }
            }
        }
        .sheet(isPresented: $showingCategorySheet) {
            CategorySelectionView(selectedCategories: $selectedCategories)
        }
        .onAppear {
            if let recipe = recipe {
                // Load existing recipe data
                loadRecipeData(recipe)
            }
        }
    }
    
    private func loadRecipeData(_ recipe: Recipe) {
        title = recipe.title
        author = recipe.author
        timeRequired = recipe.timeRequired
        servings = recipe.servings
        expertiseRequired = recipe.expertiseRequired
        caloriesPerServing = recipe.caloriesPerServing
        notes = recipe.notes ?? ""
        
        // Load ingredients
        ingredients = recipe.ingredients.sorted(by: { $0.order < $1.order }).map { ingredient in
            IngredientFormItem(
                quantity: ingredient.quantity,
                name: ingredient.name,
                notes: ingredient.notes ?? ""
            )
        }
        
        // Load instructions
        instructions = recipe.instructions.sorted(by: { $0.order < $1.order }).map { instruction in
            InstructionFormItem(
                order: instruction.order,
                details: instruction.details
            )
        }
        
        // Load categories
        selectedCategories = Set(recipe.categories)
    }
    
    private func saveRecipe() {
        if let existingRecipe = recipe {
            // Update existing recipe
            existingRecipe.title = title
            existingRecipe.author = author
            existingRecipe.timeRequired = timeRequired
            existingRecipe.servings = servings
            existingRecipe.expertiseRequired = expertiseRequired
            existingRecipe.caloriesPerServing = caloriesPerServing
            existingRecipe.notes = notes.isEmpty ? nil : notes
            
            // Update ingredients
            existingRecipe.ingredients.forEach { modelContext.delete($0) }
            existingRecipe.ingredients = ingredients.enumerated().map { index, item in
                let ingredient = Ingredient(
                    quantity: item.quantity,
                    name: item.name,
                    notes: item.notes.isEmpty ? nil : item.notes,
                    order: index
                )
                return ingredient
            }
            
            // Update instructions
            existingRecipe.instructions.forEach { modelContext.delete($0) }
            existingRecipe.instructions = instructions.map { item in
                Instruction(order: item.order, details: item.details)  
            }
            
            // Update categories
            existingRecipe.categories = Array(selectedCategories)
            
        } else {
            // Create new recipe
            let newRecipe = Recipe(
                title: title,
                author: author,
                timeRequired: timeRequired,
                servings: servings,
                expertiseRequired: expertiseRequired,
                caloriesPerServing: caloriesPerServing,
                notes: notes.isEmpty ? nil : notes
            )
            
            // Add ingredients
            newRecipe.ingredients = ingredients.enumerated().map { index, item in
                let ingredient = Ingredient(
                    quantity: item.quantity,
                    name: item.name,
                    notes: item.notes.isEmpty ? nil : item.notes,
                    order: index
                )
                return ingredient
            }
            
            // Add instructions
            newRecipe.instructions = instructions.map { item in
                Instruction(order: item.order, details: item.details)
            }
            
            // Add categories
            newRecipe.categories = Array(selectedCategories)
            
            modelContext.insert(newRecipe)
        }
        
        dismiss()
    }
}

// Helper structs for form data
struct IngredientFormItem: Identifiable {
    let id = UUID()
    var quantity: String = ""
    var name: String = ""
    var notes: String = ""
}

struct InstructionFormItem: Identifiable {
    let id = UUID()
    var order: Int = 1
    var details: String = ""
}

// Category chip view
struct CategoryChip: View {
    let category: Category
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(category.name)
                .font(.subheadline)
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color.gray.opacity(0.2))
        )
    }
}
