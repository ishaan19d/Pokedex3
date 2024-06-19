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
    
    @StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())

    var body: some View {
        switch pokemonVM.status {
        case .success:
            NavigationStack {
                List(pokedex) { pokemon in
                    NavigationLink{
                        PokemonDetail()
                            .environmentObject(pokemon)
                    } label : {
                        AsyncImage(url: pokemon.sprite) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100,height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100,height: 100)
                        
                        Text(pokemon.name!.capitalized)
                    }
                }
                .navigationTitle("Pokédex")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
            
        default:
            ProgressView()
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
