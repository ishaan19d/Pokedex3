//
//  ContentView.swift
//  Pokedex3
//
//  Created by Ishaan Das on 17/06/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],animation: .default)
    private var pokedex: FetchedResults<Pokemon>

    var body: some View {
    
        NavigationStack {
            List(pokedex) { pokemon in
                NavigationLink{
                    AsyncImage(url: pokemon.sprite) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100,height: 100)
                } label : {
                    AsyncImage(url: pokemon.sprite) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175,height: 175)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100,height: 100)
                    
                    Text(pokemon.name!.capitalized)
                }
            }
            .navigationTitle("Pokedex")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
