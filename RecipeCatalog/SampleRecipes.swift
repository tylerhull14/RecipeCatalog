//
//  SampleRecipes.swift
//  RecipeCatalog
//
//  Created by Tyler Hull on 11/25/24.
//

import Foundation
import SwiftData

struct SampleRecipes {
    static func addSampleData(to modelContext: ModelContext) {
        // Add sample categories
        let breakfast = Category(name: "Breakfast")
        let dessert = Category(name: "Dessert")
        let mainDish = Category(name: "Main Dish")
        
        modelContext.insert(breakfast)
        modelContext.insert(dessert)
        modelContext.insert(mainDish)
        
        // Sample recipe 1: Pancakes
        let pancakes = Recipe(
            title: "Classic Pancakes",
            author: "Chef John",
            timeRequired: 30,
            servings: 4,
            expertiseRequired: "Beginner",
            caloriesPerServing: 250,
            notes: "Make sure not to overmix the batter!"
        )
        
        pancakes.ingredients = [
            Ingredient(quantity: "1½ cups", name: "all-purpose flour"),
            Ingredient(quantity: "3½ tsp", name: "baking powder"),
            Ingredient(quantity: "¼ tsp", name: "salt"),
            Ingredient(quantity: "1 tbsp", name: "sugar"),
            Ingredient(quantity: "1¼ cups", name: "milk"),
            Ingredient(quantity: "1", name: "egg"),
            Ingredient(quantity: "3 tbsp", name: "butter", notes: "melted")
        ]
        
        pancakes.instructions = [
            Instruction(order: 1, details: "Mix flour, baking powder, salt, and sugar in a bowl."),
            Instruction(order: 2, details: "Whisk milk, egg, and melted butter in another bowl."),
            Instruction(order: 3, details: "Combine wet and dry ingredients, whisking until just mixed."),
            Instruction(order: 4, details: "Heat a griddle or pan over medium heat."),
            Instruction(order: 5, details: "Pour ¼ cup batter for each pancake."),
            Instruction(order: 6, details: "Cook until bubbles form, flip and cook other side.")
        ]
        
        pancakes.categories = [breakfast]
        modelContext.insert(pancakes)
        
        // Sample recipe 2: Chocolate Cake
        let chocolateCake = Recipe(
            title: "Classic Chocolate Cake",
            author: "Pastry Chef Sarah",
            timeRequired: 60,
            servings: 8,
            expertiseRequired: "Intermediate",
            caloriesPerServing: 350,
            notes: "For extra moistness, add an extra egg yolk!"
        )
        
        chocolateCake.ingredients = [
            Ingredient(quantity: "2 cups", name: "all-purpose flour"),
            Ingredient(quantity: "2 cups", name: "sugar"),
            Ingredient(quantity: "¾ cup", name: "unsweetened cocoa powder"),
            Ingredient(quantity: "2 tsp", name: "baking soda"),
            Ingredient(quantity: "1 tsp", name: "baking powder"),
            Ingredient(quantity: "1 tsp", name: "salt"),
            Ingredient(quantity: "2", name: "eggs"),
            Ingredient(quantity: "1 cup", name: "milk"),
            Ingredient(quantity: "½ cup", name: "vegetable oil"),
            Ingredient(quantity: "2 tsp", name: "vanilla extract"),
            Ingredient(quantity: "1 cup", name: "boiling water", notes: "very hot")
        ]
        
        chocolateCake.instructions = [
            Instruction(order: 1, details: "Preheat oven to 350°F (175°C). Grease and flour two 9-inch cake pans."),
            Instruction(order: 2, details: "In a large bowl, combine flour, sugar, cocoa, baking soda, baking powder, and salt."),
            Instruction(order: 3, details: "Add eggs, milk, oil, and vanilla to dry ingredients. Mix well with an electric mixer on medium speed."),
            Instruction(order: 4, details: "Stir in boiling water. The batter will be very thin."),
            Instruction(order: 5, details: "Pour into prepared pans."),
            Instruction(order: 6, details: "Bake for 30-35 minutes, until a toothpick inserted comes out clean."),
            Instruction(order: 7, details: "Cool in pans for 10 minutes, then remove and cool completely on wire racks.")
        ]
        
        chocolateCake.categories = [dessert]
        modelContext.insert(chocolateCake)
        
        // Sample recipe 3: Spaghetti Bolognese
        let spaghettiBolognese = Recipe(
            title: "Spaghetti Bolognese",
            author: "Chef Mario",
            timeRequired: 45,
            servings: 6,
            expertiseRequired: "Beginner",
            caloriesPerServing: 450,
            notes: "Let the sauce simmer longer for deeper flavor"
        )
        
        spaghettiBolognese.ingredients = [
            Ingredient(quantity: "1 lb", name: "spaghetti"),
            Ingredient(quantity: "1 lb", name: "ground beef"),
            Ingredient(quantity: "1", name: "onion", notes: "finely chopped"),
            Ingredient(quantity: "3 cloves", name: "garlic", notes: "minced"),
            Ingredient(quantity: "2 cans", name: "crushed tomatoes"),
            Ingredient(quantity: "2 tbsp", name: "olive oil"),
            Ingredient(quantity: "1 tsp", name: "dried basil"),
            Ingredient(quantity: "1 tsp", name: "dried oregano"),
            Ingredient(quantity: "to taste", name: "salt and pepper"),
            Ingredient(quantity: "½ cup", name: "Parmesan cheese", notes: "grated")
        ]
        
        spaghettiBolognese.instructions = [
            Instruction(order: 1, details: "Heat olive oil in a large pot over medium heat."),
            Instruction(order: 2, details: "Add onion and garlic, sauté until softened."),
            Instruction(order: 3, details: "Add ground beef and cook until browned."),
            Instruction(order: 4, details: "Add tomatoes, basil, oregano, salt, and pepper."),
            Instruction(order: 5, details: "Simmer sauce for 30 minutes."),
            Instruction(order: 6, details: "Meanwhile, cook spaghetti according to package directions."),
            Instruction(order: 7, details: "Serve sauce over pasta, topped with Parmesan cheese.")
        ]
        
        spaghettiBolognese.categories = [mainDish]
        modelContext.insert(spaghettiBolognese)
    }
}
