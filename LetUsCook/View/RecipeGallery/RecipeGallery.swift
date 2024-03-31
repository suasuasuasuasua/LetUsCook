//
//  RecipeGallery.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/31/24.
//

import SwiftUI

struct RecipeGallery: View {
    var recipes: [Recipe]
    //    @Binding var editing: Bool
    //    let selectRecipe: (Recipe) -> Void
    //    let addRecipe: () -> Void
    
    var body: some View {
        Text("Recipe Gallery")
        
        Table(recipes) {
            TableColumn("Name", value: \.name)
            TableColumn("Prep Time", value: \.prepTime)
            TableColumn("Cook Time", value: \.cookTime)
            TableColumn("Comments", value: \.comments)
        }
        
        
        //        ScrollView {
        //            LazyVGrid(
        //                columns: RecipeGallery([GridItem(200)]),
        //                spacing: 20
        //            ) {
        //                }
        //            }
    }
}
