//
//  ContentView.swift
//  Pokedex3
//
//  Created by Ishaan Das on 17/06/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],animation: .default)
    private var pokedex: FetchedResults<Pokemon>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)], predicate: NSPredicate(format: "favorite = %d",true), animation: .default) private var favorites: FetchedResults<Pokemon>
    
    @State var filterByFavorites = false
    @StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())
    @State var searchText = ""
    
    private var filteredPokemon: [Pokemon] {
        if searchText.isEmpty {
            return filterByFavorites ? Array(favorites) : Array(pokedex)
        } else {
            return (filterByFavorites ? Array(favorites) : Array(pokedex)).filter { pokemon in
                pokemon.name!.localizedStandardContains(searchText)
            }
        }
    }
    
    var body: some View {
        switch pokemonVM.status {
        case .notStarted:
            EmptyView()
            
        case .fetching:
            VStack{
                ProgressView()
                    .padding()
                Text("Fetching Pokemons...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
            
        case .success:
            NavigationStack {
                List(filteredPokemon) { pokemon in
                    NavigationLink{
                        PokemonDetail()
                            .environmentObject(pokemon)
                    } label : {
                        HStack{
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
                            Spacer()
                            if pokemon.favorite {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                }
                .navigationTitle("Pokédex")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            filterByFavorites.toggle()
                        } label: {
                            Image(systemName: filterByFavorites ? "star.fill" : "star")
                                .tint(.yellow)
                                .symbolEffect(.bounce, value: filterByFavorites)
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Find your pokemon")
            .autocorrectionDisabled()
            .animation(.default, value: filteredPokemon)
            
        case .failed(let error):
            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 15))
                .padding()
        }
    }
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
