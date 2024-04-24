//
//  RecipeView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import PhotosUI
import SwiftData
import SwiftUI

struct RecipeView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var isDeleting = false
    @State private var isShowingImage: Bool = true
    var recipe: Recipe?

    var body: some View {
        if let recipe {
            RecipeContent(recipe: recipe)
                .inspector(
                    isPresented: $isShowingImage
                ) {
                    InspectorView(recipe: recipe)
                }
                .toolbar {
                    ToolbarItem(placement: .destructiveAction) {
                        // Delete the recipe
                        Button {
                            isDeleting = true
                        } label: {
                            Label("Delete", systemImage: "minus")
                        }
                    }
                    ToolbarItemGroup {
                        // Toggle the image inspector on the right
                        Button {
                            isShowingImage.toggle()
                        } label: {
                            Label("Show Image", systemImage: "sidebar.right")
                        }
                    }
                }
                // When the alert boolean is set, show the delete context
                .confirmationDialog(
                    // TODO: maybe I should move it to the trash instead?
                    "Are you sure you want to delete the recipe permanently?",
                    isPresented: $isDeleting,
                    presenting: recipe
                ) { recipe in
                    Button(role: .destructive) {
                        withAnimation {
                            delete(recipe)
                        }
                    } label: {
                        Text("Delete")
                    }
                    Button("Cancel", role: .cancel) {}
                } message: { _ in
                    // TODO: but what if it could be undone?
                    // Maybe send to the trash instead
                    Text("You cannot undo this action.")
                }
                .padding()
        } else {
            ContentUnavailableView(
                "Select a recipe!",
                systemImage: "fork.knife"
            )
        }
    }

    private func delete(_ recipe: Recipe) {
        navigationContext.selectedRecipe = nil
        modelContext.delete(recipe)
    }
}

extension RecipeView {
    private struct RecipeContent: View {
        // https://stackoverflow.com/questions/61437905/swiftui-list-is-not-showing-any-items
        @Environment(\.defaultMinListRowHeight) var minRowHeight
        @Bindable var recipe: Recipe

        let creationDate = Date()

        var body: some View {
            ScrollView {
                VStack(spacing: 20.0) {
                    NameView(recipe: recipe)
                    HStack(alignment: .top, spacing: 24.0) {
                        TimeView(recipe: recipe)
                        Divider()
                        CommentsView(recipe: recipe)
                    }
                }

                Divider()

                VStack {
                    InstructionsView(recipe: recipe)
//                    IngredientsView(recipe: recipe)
                }
                .frame(minHeight: minRowHeight * 10)
            }
        }
    }

    private struct NameView: View {
        @Bindable var recipe: Recipe

        @Query(sort: \Recipe.name) private var recipes: [Recipe]
        private var recipeNames: [String] {
            recipes.map { $0.name }
        }

        @State var name: String
        @State private var error: String = ""

        init(recipe: Recipe) {
            self.recipe = recipe
            name = recipe.name
        }

        var body: some View {
            NameBody()
                // Update the text field on the recipe whenever the recipe
                // changes. We do this instead of .onAppear because that happens
                // only when the view itself changes
                .onChange(of: recipe) {
                    name = recipe.name
                }
                .onChange(of: name) {
                    if name.isEmpty {
                        error = "Name cannot be empty!"
                    } else {
                        error = ""
                        recipe.name = name.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                    }
                }
        }

        @ViewBuilder
        private func NameBody() -> some View {
            TextField("", text: $name)
                .font(.title)
            if !error.isEmpty {
                Text("\(error)")
                    .font(.subheadline)
                    .foregroundStyle(.red)
            }
        }
    }

    private struct TimeView: View {
        @Bindable var recipe: Recipe
        @State var prepTime: String
        @State var cookTime: String

        init(recipe: Recipe) {
            self.recipe = recipe
            prepTime = recipe.prepTime
            cookTime = recipe.cookTime
        }

        var body: some View {
            VStack(alignment: .leading) {
                Text("Preparation Time")
                    .font(.headline)
                TextField("", text: $prepTime)
                    .onChange(of: prepTime) {
                        recipe.prepTime = prepTime
                    }
                    .font(.subheadline)
                Text("Cooking Time")
                    .font(.headline)
                TextField("", text: $cookTime)
                    .onChange(of: cookTime) {
                        recipe.cookTime = cookTime
                    }
                    .font(.subheadline)
            }
            .onChange(of: recipe) {
                prepTime = recipe.prepTime
                cookTime = recipe.cookTime
            }
        }
    }

    private struct CommentsView: View {
        @Bindable var recipe: Recipe
        @State var comments: String

        init(recipe: Recipe) {
            self.recipe = recipe
            comments = recipe.comments
        }

        var body: some View {
            VStack(alignment: .leading) {
                Text("Comments")
                    .font(.headline)
                TextField("", text: $comments)
                    .onChange(of: comments) {
                        recipe.comments = comments
                    }
                    .font(.subheadline)
            }
            .onChange(of: recipe) {
                comments = recipe.comments
            }
        }
    }

    private struct InstructionsView: View {
        @Bindable var recipe: Recipe
        @State var instructions: [Instruction]

        init(recipe: Recipe) {
            self.recipe = recipe
            instructions = recipe.instructions

            // Give a sample instruction by default -- remember to link it
            if instructions.isEmpty {
                let sampleInstruction = Instruction(text: "Step 1...")
                recipe.updateInstructions(withInstructions: [sampleInstruction])

                instructions = recipe.instructions
            }
        }

        var body: some View {
            Text("Instructions")
                .font(.title)
            Form {
                ForEach($instructions, id: \.self) { instruction in
                    TextField(
                        "",
                        text: instruction.text
                    )
                    .onSubmit {
                        let instructionTexts = instructions.map { $0.text }
                        if instructionTexts
                            .contains(instruction.wrappedValue.text)
                        {
                            print("bruh")
                        }

                        recipe.instructions = instructions
                    }
                }
            }
            .onChange(of: recipe) {
                instructions = recipe.instructions

                if instructions.isEmpty {
                    instructions = [Instruction(text: "")]
                }
            }
        }
    }

    // TODO: make this an array of textfields?
    private struct IngredientsView: View {
        @Bindable var recipe: Recipe

        var body: some View {
            Text("Ingredients")
                .font(.title)
            List(recipe.ingredients) { ingredient in
                Text("\(ingredient.name)")
            }
            .task(id: recipe) {
                // TODO: fill in the task
            }
        }
    }
}
