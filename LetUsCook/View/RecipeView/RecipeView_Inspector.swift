import PhotosUI
import SwiftData
import SwiftUI

struct InspectorView: View {
    @Bindable var recipe: Recipe

    var body: some View {
        VStack(alignment: .leading) {
            DateView(recipe: recipe)
            ImageView(recipe: recipe)
            CategoriesView(recipe: recipe)
            Spacer()
        }
        .padding()
    }
}

extension InspectorView {
    struct DateView: View {
        let recipe: Recipe

        var body: some View {
            VStack(alignment: .leading) {
                Text("Date created")
                    .font(.title)
                Text(recipe.dateCreated.formatted(
                    date: .abbreviated,
                    time: .standard
                ))
                .font(.subheadline)
            }
        }
    }

    struct ImageView: View {
        // TODO: should i make this an async image?
        @State private var image = Image(systemName: "photo")

        // https://developer.apple.com/documentation/photokit/bringing_photos_picker_to_your_swiftui_app
        @State private var photosSelection: PhotosPickerItem?
        @State private var fileURL: URL?

        @Bindable var recipe: Recipe

        private let imageWidth = 200.0, imageHeight = 200.0

        // https://developer.apple.com/tutorials/app-dev-training/persisting-data
        var localCachePath: URL? = try? FileManager.default.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        .appendingPathComponent("letuscook.data")

        @State private var photoDetailsExpanded = false

        var body: some View {
            VStack(alignment: .leading) {
                image
                    .resizable()
                    .frame(width: imageWidth, height: imageHeight)
                    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-support-drag-and-drop-in-swiftui
                    .dropDestination(for: URL.self) { items, location in
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
                DisclosureGroup(
                    isExpanded: $photoDetailsExpanded,
                    content: {
                        VStack(alignment: .leading) {
                            if let url = recipe.imageURL
                            {
                                Text("\(url.size.B2KB()) KB")
                            } else {
                                Text("No photo selected")
                            }
                        }
                    },
                    label: {
                        Text("Details")
                    }
                )

                // https://stackoverflow.com/a/63764764
                // TODO: eventually refactor this to the top view so we can
                // open files that way too
                HStack {
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
                print("selection changed")
                if let imageData = try? await photosSelection?
                    .loadTransferable(type: Data.self),
                    let nsImage = NSImage(data: imageData)
                {
                    // Set the image
                    image = Image(nsImage: nsImage)

                    // Define some URL for the image
                    let imageURL = URL(fileURLWithPath: recipe.name)
                        .appendingPathExtension(for: .heic)

                    // TODO: it will actually overwrite the last image that
                    // was named New Recipe 3's image for example.
                    // Could tag the imageURL with a datetime as well
                    // Cache the image itself
                    cachePhoto(imageURL: imageURL, itemData: imageData)
                } else {
                    print("Something went horribly wrong!!!")
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
            }
        }
    }
}
