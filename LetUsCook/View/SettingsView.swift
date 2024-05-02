//
//  SettingsView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/10/24.
//

import SwiftUI

struct SettingsView: View {
    @State var saveLocation: String

    init() {
        let localCachePath: URL? = try? FileManager.default.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        .appendingPathComponent("letuscook.data")

        if let localCachePath {
            saveLocation = localCachePath.absoluteString
        } else {
            saveLocation = ""
        }
    }

    var body: some View {
        VStack {
            LabeledContent {
                TextField("Image Cache Directory", text: $saveLocation)
            } label: {
                Text("Image Cache Directory")
            }
        }.padding()
    }
}
