//
//  AppController.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/19/24.
//

import Foundation

@Observable
class AppController {
    var dataModel: DataModel
    var navigationContext: NavigationContext

    init() {
        self.dataModel = .init()
        self.navigationContext = .init()
    }
}
