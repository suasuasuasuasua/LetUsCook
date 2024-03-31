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

    var Toast = Recipe(
        name: "Toast",
        photo: "",
        categories: [],
        prepTime: "1 minute",
        cookTime: "5 minutes",
        comments: "Just some toast"
    )

    var Cereal = Recipe(
        name: "Cereal",
        photo: "",
        categories: [],
        prepTime: "1 minutes",
        cookTime: "0 minutes",
        comments: "Just some cereal"
    )

    init() {
//        Toast.instructions = [
//            Instruction(
//                index: 0,
//                recipe: Toast,
//                text: "Put the toast in the toaster for 5 minutes"
//            ),
//        ]
//        Toast.instructions = [
//            Instruction(index: 1, recipe: Toast, text: "Enjoy!"),
//        ]
//
//        Cereal.instructions = [
//            Instruction(
//                index: 0,
//                recipe: Cereal,
//                text: "Put cereal into a bowl"
//            ),
//        ]
//        Cereal.instructions = [
//            Instruction(
//                index: 1,
//                recipe: Cereal,
//                text: "Put the milk into the same bowl"
//            ),
//        ]
//        Cereal.instructions = [
//            Instruction(index: 2, recipe: Cereal, text: "Enjoy!"),
//        ]
//        
        contents = [
            Toast,
            Cereal
        ]
    }
}
