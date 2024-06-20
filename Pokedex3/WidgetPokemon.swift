//
//  WidgetPokemon.swift
//  Pokedex3
//
//  Created by Ishaan Das on 20/06/24.
//

import SwiftUI

enum WidgetSize {
    case small
    case medium
    case large
}

struct WidgetPokemon: View {
    @EnvironmentObject var pokemon: Pokemon
    let widgetSize: WidgetSize
    
    var body: some View {
        ZStack{
            Color(pokemon.types![0].capitalized)
            
            switch widgetSize {
            case .small:
                FetchedImage(url: pokemon.sprite)
                
            case .medium:
                HStack{
                    FetchedImage(url: pokemon.sprite)
                    
                    VStack(alignment: .leading){
                        Text(pokemon.name!.capitalized)
                            .font(.title)
                        
                        Text(pokemon.types!.joined(separator: ", ").capitalized)
                    }
                    .padding(.trailing, 30)
                }
                
            case .large:
                FetchedImage(url: pokemon.sprite)
                VStack{
                    HStack{
                        Text(pokemon.name!.capitalized)
                            .font(.largeTitle)
                        
                        Spacer()
                    }
                    Spacer()
                    
                    HStack{
                        Spacer()
                        
                        Text(pokemon.types!.joined(separator: ", ").capitalized)
                            .font(.title2)
                    }
                }
                .padding()
            }
        }
        .foregroundStyle(.black)
    }
}

#Preview {
    WidgetPokemon(widgetSize: .large)
        .environmentObject(SamplePokemon.samplePokemon)
}
