//
//  NavigationContext.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import Foundation
import SwiftUI

@Observable
class NavigationContext {
    var selectedPane: String?
    
    var columnVisibility: NavigationSplitViewVisibility
    var sidebarTitle = "Let Us Cook"
    
//    var contentListTitle: String {
//        if let selectedAnimalCategoryName {
//            selectedAnimalCategoryName
//        } else {
//            ""
//        }
//    }

//    init(selectedAnimalCategoryName: String? = nil,
//         selectedAnimal: Animal? = nil,
//         columnVisibility: NavigationSplitViewVisibility = .automatic)
//    {
//        self.selectedAnimalCategoryName = selectedAnimalCategoryName
//        self.selectedAnimal = selectedAnimal
//        self.columnVisibility = columnVisibility
//    }

    init(columnVisibility: NavigationSplitViewVisibility = .automatic,
         sidebarTitle: String = "Let Us Cook")
    {
        self.columnVisibility = columnVisibility
        self.sidebarTitle = sidebarTitle
    }
}
