//
//  CategorySelectionView.swift
//  RecipeCatalog
//
//  Created by Tyler Hull on 11/25/24.
//

import SwiftUI
import SwiftData

struct CategorySelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCategories: Set<Category>
    
    @Query private var categories: [Category]
    @State private var newCategoryName = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(categories) { category in
                        HStack {
                            Text(category.name)
                            Spacer()
                            if selectedCategories.contains(category) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedCategories.contains(category) {
                                selectedCategories.remove(category)
                            } else {
                                selectedCategories.insert(category)
                            }
                        }
                    }
                    .onDelete(perform: deleteCategories)
                }
                
                Section("Add New Category") {
                    HStack {
                        TextField("Category name", text: $newCategoryName)
                        Button("Add") {
                            addCategory()
                        }
                        .disabled(newCategoryName.isEmpty)
                    }
                }
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func addCategory() {
        withAnimation {
            let category = Category(name: newCategoryName)
            modelContext.insert(category)
            newCategoryName = ""
        }
    }
    
    private func deleteCategories(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let category = categories[index]
                selectedCategories.remove(category)
                modelContext.delete(category)
            }
        }
    }
}
