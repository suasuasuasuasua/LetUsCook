//
//  RecipeView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import PhotosUI
import SwiftData
import SwiftUI

/// Focus on a single recipe in the app
///
/// - Allow the user to read and scroll through the recipe
/// - The user should be able to preview everything about the recipe like...
///     - the creation date
///     - times referenced (maybe a stretch goal)
///     - the ingredients as a list (could put preview images pulled from some
///       database) or just used icons
///         - Could also figure out how Apple auto-categorizes the grocery list
///           in Reminders
///     - the instruction for the recipe
/// - The user should be able to edit the recipe by clicking a button
/// - The user should be able to delete the recipe by click another button
/// - The should be able to share the recipe, which exports the recipe to...
///     - A plaintext formatted string
///     - JSON (I like this idea)
///     - Some weird proprietary format that I choose
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
                    // TODO: Maybe also have things like links and date created?
                    ImageView(recipe: recipe)
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
                            Label("Show Image", systemImage: "photo")
                        }
                        // Share the recipe
                        Button {
                            // TODO: implement the share option
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
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
                        delete(recipe)
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
        // navigationContext.selectedRecipe = nil
        modelContext.delete(recipe)
    }
}

extension RecipeView {
    private struct RecipeContent: View {
        // https://stackoverflow.com/questions/61437905/swiftui-list-is-not-showing-any-items
        @Environment(\.defaultMinListRowHeight) var minRowHeight
        @Bindable var recipe: Recipe

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
                    IngredientsView(recipe: recipe)
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

        @State var name: String = ""
        @State private var OGName: String = ""
        @State private var error: String = ""

        var body: some View {
            NameBody()
                // Update the text field on the recipe whenever the recipe
                // changes. We do this instead of .onAppear because that happens
                // only when the view itself changes
                .task(id: recipe) {
                    name = recipe.name
                    OGName = recipe.name
                }
                .onChange(of: name) {
                    if name != OGName &&
                        recipeNames.contains(where: { $0 == name })
                    {
                        error = "Duplicate name!"
                    } else if name.isEmpty {
                        error = "Name cannot be empty!"
                    } else {
                        error = ""
                        recipe.name = name
                            .trimmingCharacters(in: .whitespacesAndNewlines)
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

    private struct ImageView: View {
        @Bindable var recipe: Recipe
        // TODO: should i make this an async image?
        @State private var image = Image(systemName: "photo")

        // https://developer.apple.com/documentation/photokit/bringing_photos_picker_to_your_swiftui_app
        @State private var photosSelection: PhotosPickerItem?
        @State private var fileURL: URL?

        private let imageWidth = 200.0, imageHeight = 200.0

        // https://developer.apple.com/tutorials/app-dev-training/persisting-data
        private var localCachePath: URL? = nil

        init(recipe: Recipe) {
            self.recipe = recipe
            localCachePath = try? FileManager.default.url(for: .cachesDirectory,
                                                          in: .userDomainMask,
                                                          appropriateFor: nil,
                                                          create: true)
                .appendingPathComponent("letuscook.data")
        }

        var body: some View {
            VStack(alignment: .leading) {
                Text("Photo")
                    .font(.title)
                image
                    .resizable()
                    .frame(width: imageWidth, height: imageHeight)
                    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-support-drag-and-drop-in-swiftui
                    .dropDestination(for: URL.self) { items, location in
                        // Need to ensure that all of variables are not nil to
                        // procede
                        // Get data from URL:
                        // https://stackoverflow.com/a/44868411
                        guard let itemURL = items.first,
                              let itemData = try? Data(contentsOf: itemURL),
                              let nsImage = NSImage(data: itemData)
                        else { return false }

                        // Set the image on the view
                        image = Image(nsImage: nsImage)

                        // Cache the image's data
                        cachePhoto(imageURL: itemURL, itemData: itemData)

                        return true
                    }
                // https://stackoverflow.com/a/63764764
                // TODO: eventually refactor this to the top view so we can
                // open files that way too
                Button {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseFiles = true
                    panel.canChooseDirectories = false
                    panel.isAccessoryViewDisclosed = true

                    // I think these are all the relevant file types for images
                    panel.allowedContentTypes = [.png, .jpeg, .heic, .heif]
                    if panel.runModal() == .OK {
                        fileURL = panel.url
                    }

                } label: {
                    Text("Choose from files.")
                }
                PhotosPicker(
                    selection: $photosSelection,
                    matching: .images,
                    preferredItemEncoding: .automatic
                ) {
                    Text("Choose from photos library.")
                }
                Spacer()
            }
            // TODO: there's a weird flicker
            .task(id: recipe) {
                image = if let imageURL = recipe.imageURL,
                           let nsImage = NSImage(contentsOf: imageURL)
                {
                    Image(nsImage: nsImage)
                } else {
                    Image(systemName: "photo")
                }
            }
            // TODO: i want to move away from tasks
            // https://www.youtube.com/watch?v=y3LofRLPUM8
            .task(id: photosSelection) {
                // TODO: Fine for now -- let's do caching later
                if let imageData = try? await photosSelection?
                    .loadTransferable(type: Data.self),
                    let nsImage = NSImage(data: imageData)
                {
                    // Set the image
                    image = Image(nsImage: nsImage)

                    // Define some URL for the image
                    let imageURL = URL(fileURLWithPath: recipe.name)
                        .appendingPathExtension(for: .heic)

                    // Cache the image itself
                    // TODO: it will actually overwrite the last image that
                    // was named New Recipe 3's image for example.
                    // Could tag the imageURL with a datetime as well
                    cachePhoto(imageURL: imageURL, itemData: imageData)
                } else {
                    print("Something went horribly wrong")
                }
            }
            // https://stackoverflow.com/a/60677690
            .task(id: fileURL) {
                // https://developer.apple.com/documentation/foundation/filemanager/1407903-copyitem
                if let fileURL,
                   let fileData = try? Data(contentsOf: fileURL),
                   let nsImage = NSImage(data: fileData)
                {
                    // Set the image
                    image = Image(nsImage: nsImage)

                    // Cache the image itself
                    cachePhoto(imageURL: fileURL, itemData: fileData)
                }
            }
        }

        private func cachePhoto(imageURL: URL, itemData: Data) {
            // Define the URL to the cached image
            let cachedURL = URL(
                fileURLWithPath: imageURL.lastPathComponent,
                isDirectory: false,
                relativeTo: localCachePath
            )
            do {
                // Attempt to save the image data to this path
                try itemData.write(to: cachedURL)

                // Save the image URL finally
                recipe.imageURL = cachedURL
            } catch {
                print("ERROR", error)
            }
        }
    }

    private struct TimeView: View {
        @Bindable var recipe: Recipe
        @State var prepTime: String = ""
        @State var cookTime: String = ""
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
            .task(id: recipe) {
                prepTime = recipe.prepTime
                cookTime = recipe.cookTime
            }
        }
    }

    private struct CommentsView: View {
        @Bindable var recipe: Recipe
        @State var comments: String = ""

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
            .task(id: recipe) {
                comments = recipe.comments
            }
        }
    }

    // TODO: make this an array of textfields?
    private struct InstructionsView: View {
        @Bindable var recipe: Recipe
        @State var instructions: [Instruction] = []

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

            .task(id: recipe) {
                // TODO: fill in the task
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
