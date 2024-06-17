//
//  Pokedex3App.swift
//  Pokedex3
//
//  Created by Ishaan Das on 17/06/24.
//

import SwiftUI

@main
struct Pokedex3App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
