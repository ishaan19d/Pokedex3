//
//  SamplePokemon.swift
//  Pokedex3
//
//  Created by Ishaan Das on 18/06/24.
//

import Foundation
import CoreData

struct SamplePokemon {
    static let samplePokemon = {
        let context = PersistenceController.preview.container.viewContext
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.fetchLimit = 1
        let results = try! context.fetch(fetchRequest)
        
        return results.first!
    }()
}
