//
//  PokemonDetail.swift
//  Pokedex3
//
//  Created by Ishaan Das on 18/06/24.
//

import SwiftUI
import CoreData

struct PokemonDetail: View {
    @EnvironmentObject var pokemon: Pokemon
    @State var showShiny = false
    var body: some View {
        ScrollView {
            ZStack {
                Image(pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: 6)
                    .overlay {
                        LinearGradient(stops: [Gradient.Stop(color: .black, location: 0),Gradient.Stop(color: .clear, location: 0.1),Gradient.Stop(color: .clear, location: 0.75),Gradient.Stop(color: .black, location: 1)], startPoint: .top, endPoint: .bottom)
                    }
                
                AsyncImage(url: showShiny ? pokemon.shinySprite : pokemon.sprite) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 50)
                        .shadow(color: .black, radius: 6)
                } placeholder: {
                    ProgressView()
                }
            }
            
            HStack{
                ForEach(pokemon.types!, id: \.self) { type in
                    Text(type.capitalized)
                        .font(.title2)
                        .shadow(color: .white, radius: 1)
                        .padding(.vertical, 7)
                        .padding(.horizontal)
                        .background(Color(type.capitalized))
                        .clipShape(.rect(cornerRadius: 50))
                }
                
                Spacer()
            }
            .padding()
            
            Text("Stats")
                .font(.title)
                .padding(.bottom, -7)
            
            Stats()
                .environmentObject(pokemon)
        }
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showShiny.toggle()
                } label: {
                    Image(systemName: showShiny ? "wand.and.stars" : "wand.and.stars.inverse")
                        .symbolEffect(.bounce, value: showShiny)
                        .foregroundStyle(showShiny ? .yellow : Color(.blue))
                        .font(.title3)
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        PokemonDetail()
            .environmentObject(SamplePokemon.samplePokemon)
    }
}
