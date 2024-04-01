//
//  SampleRecipes.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/31/24.
//

import Foundation

@MainActor
class SampleRecipes {
    var contents: [Recipe] = []

    init() {
        let ToastInstructions = [
            Instruction(text: "Put the toast in the toaster for 5 minutes"),
            Instruction(text: "Enjoy!"),
        ]
        let ToastIngredients = [
            Ingredient(name: "Bread"),
        ]

        let CerealInstructions = [
            Instruction(text: "Put cereal into a bowl"),
            Instruction(text: "Put the milk into the same bowl"),
            Instruction(text: "Enjoy!"),
        ]
        let CerealIngredients = [
            Ingredient(name: "Cereal"),
            Ingredient(name: "Milk"),
        ]

        let Toast = Recipe(
            name: "Toast",
            categories: [],
            prepTime: "1 minute",
            cookTime: "5 minutes",
            comments: "Just some toast",
            ingredients: ToastIngredients,
            instructions: ToastInstructions
        )

        let Cereal = Recipe(
            name: "Cereal",
            categories: [],
            prepTime: "1 minutes",
            cookTime: "0 minutes",
            comments: "Just some cereal",
            ingredients: CerealIngredients,
            instructions: CerealInstructions
        )

        contents = [
            Toast,
            Cereal,
        ]
    }
}
