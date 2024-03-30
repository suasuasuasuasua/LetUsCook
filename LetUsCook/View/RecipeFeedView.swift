//
//  RecipeFeedView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import SwiftUI

/// View recipes from cooking blogs feed using subscriptions via RSS.
///
/// The user should be able to...
/// - Scroll through a list of recipes from the blogs they are subscribed to
/// - Click on any of the recipes to preview (go into `RecipeView` probably) and
///   scroll through
/// - Give the user an option to subscribe to blogs
///     - Maybe curate this list at the start (like 3 options) then open to any
///       RSS code?
///     - This may require me to parse through the RSS to ensure that it is
///       indeed a cooking blog
/// - Favorite recipes and add it to the user's gallery
struct RecipeFeedView: View {
    var body: some View {
        Text("Recipe Feed View")
    }
}

#Preview {
    RecipeFeedView()
}
