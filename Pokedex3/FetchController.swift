//
//  FetchController.swift
//  Pokedex3
//
//  Created by Ishaan Das on 17/06/24.
//

import Foundation
import CoreData

struct FetchController {
    enum NetworkError: Error {
        case badResponse
        case badData
    }
    
    private func fetchPokemon(from url: URL) async throws -> TempPokemon {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw NetworkError.badResponse
        }
        
        let tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)
        
        print("Fetched \(tempPokemon.id): \(tempPokemon.name)")
        
        return tempPokemon
    }
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    func fetchAllPokemon() async throws -> [TempPokemon]? {
        if havePokemon() {
            return nil
        }
        var allPokemon: [TempPokemon] = []
        
        let fetchURL = baseURL.appending(queryItems: [URLQueryItem(name: "limit", value: "386")])
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw NetworkError.badResponse
        }
        
        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any], let pokedex = pokeDictionary["results"] as? [[String: String]] else {
            throw NetworkError.badData
        }
        
        for pokemon in pokedex {
            if let url = pokemon["url"] {
                allPokemon.append(try await fetchPokemon(from: URL(string: url)!))
            }
        }
        
        return allPokemon
    }
    
    private func havePokemon() -> Bool {
        let context = PersistenceController.shared.container.newBackgroundContext()
        
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", [1,386])
        do{
            let checkPokemon = try context.fetch(fetchRequest)
            if checkPokemon.count == 2 {
                return true
            }
            else{
                return false
            }
        } catch {
            print("Fetch Failed: \(error)")
            return false
        }
    }

}
