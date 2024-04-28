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
                        .toolbar {
                            // Toggle the image inspector on the right
                            ToolbarItem {
                                Button {
                                    isShowingImage.toggle()
                                } label: {
                                    Label("Show Image",
                                          systemImage: "sidebar.right")
                                }
                            }
                        }
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

                Spacer()
            }
        }
    }

    private struct NameView: View {
        @Bindable var recipe: Recipe

        @Query(sort: \Recipe.name) private var recipes: [Recipe]
        private var recipeNames: [String] {
            recipes.map(\.name)
        }

        @State private var name: String
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
            VStack {
                TextField("", text: $name)
                    .font(.title)
                if !error.isEmpty {
                    Text("\(error)")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                }
            }
            .scrollContentBackground(.hidden)
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

        // https://stackoverflow.com/a/69151631
        @FocusState var focusedInstruction: Int?

        init(recipe: Recipe) {
            self.recipe = recipe

            // Give a sample instruction by default -- remember to link it
            if recipe.instructions.isEmpty {
                print("instructions are empty! Assigning sample")
                let sampleInstruction = Instruction(
                    text: "Step 1"
                )

                recipe.updateInstructions(
                    withInstructions: [sampleInstruction]
                )
            }

            // For some reason the array in the recipe is always in a random
            // order??
            // Not happy about doing it this way because it feels *wrong*,
            // but the time crunch is just too much right now
            // https://stackoverflow.com/questions/76889986/swiftdata-ios-17-array-in-random-order
            instructions = recipe.instructions.sorted(by: {
                $0.index < $1.index
            })
        }

        var body: some View {
            Text("Instructions")
                .font(.title)
            Form {
                // https://stackoverflow.com/a/63145650
                ForEach(
                    Array(zip(instructions.indices, instructions)),
                    id: \.1
                ) { index, instruction in
                    // Dynamically create another text field on enter
                    // Moves the cursor's focus as well
                    InstructionTextField(instruction: instruction)
                        .focused($focusedInstruction, equals: index)
                        .onSubmit {
                            let nextIndex = index + 1
                            let sampleInstruction = Instruction(
                                // Offset by one more cause the instructions are
                                // 1-based
                                text: "New Step \(nextIndex + 1)"
                            )

                            // https://stackoverflow.com/a/69134653
                            DispatchQueue.main
                                .asyncAfter(deadline: .now()) {
                                    focusedInstruction = nextIndex
                                }

                            // Add a sample instruction
                            instructions.insert(
                                sampleInstruction,
                                at: nextIndex
                            )

                            recipe.updateInstructions(
                                withInstructions: instructions
                            )
                        }
                        .onChange(of: instruction.text) {
                            guard instruction.text.isEmpty,
                                  instructions.count > 1 else { return }

                            let nextIndex = index - 1
                            focusedInstruction = nextIndex

                            // Remove the selected instruction
                            instructions.remove(at: index)

                            recipe.updateInstructions(
                                withInstructions: instructions
                            )
                        }
                }
            }
            .onChange(of: recipe) {
                // Refer to the init() comments
                instructions = recipe.instructions.sorted(by: {
                    $0.index < $1.index
                })
            }
            .padding()
        }

        private struct InstructionTextField: View {
            @Bindable var instruction: Instruction

            var body: some View {
                LabeledContent {
                    TextField("", text: $instruction.text)
                        .frame(maxWidth: .infinity)
                } label: {
                    Text("\(instruction.index).")
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
            .scrollContentBackground(.hidden)
            .task(id: recipe) {
                // TODO: fill in the task
            }
        }
    }
}
