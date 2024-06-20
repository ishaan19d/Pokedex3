//
//  FetchedImage.swift
//  Pokedex3
//
//  Created by Ishaan Das on 20/06/24.
//

import SwiftUI

struct FetchedImage: View {
    
    let url: URL?
    
    var body: some View {
        if let url, let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData){
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .shadow(color: .black, radius: 6)
        }
        else{
            Image(.bulbasaur)
                .resizable()
                .scaledToFit()
                .shadow(color: .black, radius: 6)
        }
    }
}

#Preview {
    FetchedImage(url: SamplePokemon.samplePokemon.sprite)
}
