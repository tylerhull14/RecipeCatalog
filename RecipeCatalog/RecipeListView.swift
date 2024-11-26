//
//  RecipeListView.swift
//  RecipeCatalog
//
//  Created by Tyler Hull on 11/25/24.
//

import SwiftUI
import SwiftData

struct RecipeListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var searchText = ""
    @State private var showingAddRecipe = false
    @State private var showingFilters = false
    @State private var selectedCategory: Category?
    @State private var showingFavoritesOnly = false
    @State private var sortOption = SortOption.title
    @State private var isLoading = false
    @State private var error: Error?
    
    // For iPad split view
    var selectedRecipe: Binding<Recipe?>?
    
    enum SortOption: String, CaseIterable {
        case title = "Title"
        case date = "Date"
        case time = "Time"
    }
    
    var sortDescriptor: SortDescriptor<Recipe> {
        switch sortOption {
        case .title:
            return SortDescriptor(\Recipe.title)
        case .date:
            return SortDescriptor(\Recipe.dateCreated, order: .reverse)
        case .time:
            return SortDescriptor(\Recipe.timeRequired)
        }
    }
    
    @Query(sort: [SortDescriptor(\Recipe.title)]) private var recipes: [Recipe]
    
    init(selectedRecipe: Binding<Recipe?>? = nil,
         searchText: String = "",
         selectedCategory: Category? = nil,
         showingFavoritesOnly: Bool = false,
         sortOption: SortOption = .title) {
        self.selectedRecipe = selectedRecipe
        self.sortOption = sortOption
        _recipes = Query(sort: [SortDescriptor(\Recipe.title)])
        _searchText = State(initialValue: searchText)
        _selectedCategory = State(initialValue: selectedCategory)
        _showingFavoritesOnly = State(initialValue: showingFavoritesOnly)
    }
    
    var filteredRecipes: [Recipe] {
        recipes.filter { recipe in
            let matchesSearch = searchText.isEmpty ||
                recipe.title.localizedCaseInsensitiveContains(searchText)
            let matchesFavorite = !showingFavoritesOnly || recipe.isFavorite
            let matchesCategory = selectedCategory == nil ||
                recipe.categories.contains(selectedCategory!)
            return matchesSearch && matchesFavorite && matchesCategory
        }
    }
    
    var sortedRecipes: [Recipe] {
        switch sortOption {
        case .title:
            return filteredRecipes.sorted { $0.title < $1.title }
        case .date:
            return filteredRecipes.sorted { $0.dateCreated > $1.dateCreated }
        case .time:
            return filteredRecipes.sorted { $0.timeRequired < $1.timeRequired }
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    LoadingView()
                } else if let error = error {
                    ErrorView(error: error) {
                        loadData()
                    }
                } else {
                    VStack {
                        Picker("Sort By", selection: $sortOption) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        
                        List(selection: selectedRecipe) {
                            ForEach(sortedRecipes) { recipe in
                                if horizontalSizeClass == .compact {
                                    NavigationLink {
                                        RecipeDetailView(recipe: recipe)
                                    } label: {
                                        RecipeRowView(recipe: recipe)
                                    }
                                } else {
                                    RecipeRowView(recipe: recipe)
                                }
                            }
                            .onDelete(perform: deleteRecipes)
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search recipes")
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingFilters = true }) {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddRecipe = true }) {
                        Label("Add Recipe", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddRecipe) {
                NavigationStack {
                    AddRecipeView()
                }
            }
            .sheet(isPresented: $showingFilters) {
                NavigationStack {
                    RecipeFilterView(
                        selectedCategory: $selectedCategory,
                        showingFavoritesOnly: $showingFavoritesOnly
                    )
                }
            }
        }
        .task {
            loadData()
        }
    }
    
    private func deleteRecipes(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(sortedRecipes[index])
            }
        }
    }
    
    private func loadData() {
        isLoading = true
        error = nil
        
        do {
            let descriptor = FetchDescriptor<Recipe>(sortBy: [sortDescriptor])
            _ = try modelContext.fetch(descriptor)
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
}
