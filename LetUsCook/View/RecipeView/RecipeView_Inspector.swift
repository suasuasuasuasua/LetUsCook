import PhotosUI
import SwiftData
import SwiftUI

struct InspectorView: View {
    @Bindable var recipe: Recipe

    var body: some View {
        VStack(alignment: .leading) {
            ImageView(recipe: recipe)
            RecipeDetailedView(recipe: recipe)
            CategoriesView(recipe: recipe)
            Spacer()
        }
        .padding()
    }
}

extension InspectorView {
    struct ImageView: View {
        @Bindable var recipe: Recipe

        // https://developer.apple.com/documentation/photokit/bringing_photos_picker_to_your_swiftui_app
        @State private var image: Image? = nil
        @State private var photosSelection: PhotosPickerItem?
        @State private var fileURL: URL?

        private let imageWidth = 200.0, imageHeight = 200.0

        // TODO: refactor to top view so I can put this in the settings menu
        // https://developer.apple.com/tutorials/app-dev-training/persisting-data
        var localCachePath: URL? = try? FileManager.default.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        .appendingPathComponent("letuscook.data")

        var body: some View {
            image?
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: imageWidth, height: imageHeight)
                // https://www.hackingwithswift.com/quick-start/swiftui/how-to-support-drag-and-drop-in-swiftui
                .dropDestination(for: URL.self) { items, location in
                    // Get data from URL:
                    // https://stackoverflow.com/a/44868411
                    guard let itemURL = items.first,
                          let itemData = try? Data(contentsOf: itemURL),
                          let nsImage = NSImage(data: itemData)
                    else { return false }

                    // Cache and set the image on the view
                    cacheImage(imageURL: itemURL, itemData: itemData)
                    setImage(nsImage: nsImage)

                    return true
                }
            // https://stackoverflow.com/a/63764764
            // TODO: eventually refactor this to the top view so we can
            // open files that way too
            HStack {
                // Select a file from the macOS file system
                Button {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseFiles = true
                    panel.canChooseDirectories = false
                    panel.isAccessoryViewDisclosed = true

                    // I think these are all the relevant file types for
                    // images
                    panel.allowedContentTypes = [.png, .jpeg, .heic, .heif]
                    if panel.runModal() == .OK {
                        fileURL = panel.url
                    }

                } label: {
                    Label("Files", systemImage: "folder")
                        .foregroundStyle(.accent)
                }
                // Select an image from the photos gallery
                PhotosPicker(
                    selection: $photosSelection,
                    matching: .images,
                    preferredItemEncoding: .automatic
                ) {
                    Label("Photos", systemImage: "photo.on.rectangle")
                        .foregroundStyle(.darkerAccent)
                }
                // // TODO: implement taking a picture with your phone
                // Text("Take a picture with your phone")
            }
            .task(id: recipe) {
                withAnimation(.bouncy) {
                    if let imageURL = recipe.imageURL,
                       let nsImage = NSImage(contentsOf: imageURL)
                    {
                        image = Image(nsImage: nsImage)
                    } else {
                        image = Image(systemName: "photo")
                    }
                }
            }
            // TODO: i want to move away from tasks
            // https://www.youtube.com/watch?v=y3LofRLPUM8
            .task(id: photosSelection) {
                if let imageData = try? await photosSelection?
                    .loadTransferable(type: Data.self),
                    let nsImage = NSImage(data: imageData)
                {
                    // Define some URL for the image
                    let imageURL = URL(fileURLWithPath: recipe.name)
                        .appendingPathExtension(for: .heic)

                    // Cache and set the image
                    cacheImage(imageURL: imageURL, itemData: imageData)
                    setImage(nsImage: nsImage)
                } else {
                    print("Something went horribly wrong!!!")
                }
            }
            // https://stackoverflow.com/a/60677690
            .task(id: fileURL) {
                if let fileURL,
                   let fileData = try? Data(contentsOf: fileURL),
                   let nsImage = NSImage(data: fileData)
                {
                    // Cache and set the image
                    cacheImage(imageURL: fileURL, itemData: fileData)
                    setImage(nsImage: nsImage)
                }
            }
        }

        private func setImage(nsImage: NSImage) {
            // Set the image
            withAnimation {
                image = Image(nsImage: nsImage)
            }
        }

        // https://developer.apple.com/documentation/foundation/filemanager/1407903-copyitem
        private func cacheImage(imageURL: URL, itemData: Data) {
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

    struct RecipeDetailedView: View {
        let recipe: Recipe
        @State private var photoDetailsExpanded = false

        var body: some View {
            DisclosureGroup(
                isExpanded: $photoDetailsExpanded,
                content: {
                    VStack(alignment: .leading) {
                        DateView(recipe: recipe)
                        // TODO: not actually updating when image is first
                        // added
                        if let url = recipe.imageURL {
                            Text("Size: \(url.size.B2KB)KB")
                        } else {
                            Text("No photo selected")
                        }
                    }
                },
                label: {
                    Text("Details")
                }
            )
        }
    }

    struct DateView: View {
        let recipe: Recipe

        var date: String {
            recipe.dateCreated.formatted(
                date: .abbreviated,
                time: .shortened
            )
        }

        var body: some View {
            Text("Date created: \(date)")
        }
    }

    private struct CategoriesView: View {
        @Bindable var recipe: Recipe
        @State var selectedRecipe: Recipe? = nil

        // TODO: show all the categories for the recipes
        var body: some View {
            VStack(alignment: .leading) {
                Text("Categories")
                    .font(.title)
                List(selection: $selectedRecipe) {
                    ForEach(recipe.categories) { category in
                        Text(category.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
}
