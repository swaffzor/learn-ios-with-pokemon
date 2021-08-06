//
//  Fetch.swift
//  PokeCollection
//
//  Created by Jeremy Swafford on 6/24/21.
//

import Foundation

func fetchPaginatedData(url: URL, completionHandler: @escaping (PokemonPaginated) ->  Void) {
    
    let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    guard let resultURL = components?.url?.absoluteURL else {return}
    
    let task = URLSession.shared.dataTask(with: resultURL) { data, response, error in
        if data != nil, error == nil {
            if let responseText = String.init(data: data!, encoding: .ascii) {
                let jsonData = responseText.data(using: .utf8)!
                let temp = try! JSONDecoder().decode(PokemonPaginated.self, from: jsonData)
                completionHandler(temp)
            }
        }
    }
    task.resume()
}

func fetchPokemonCells(url: String, completionHandler: @escaping (Pokemon) -> Void) {
    guard let resultURL = URL(string: url) else {return}
    URLSession.shared.dataTask(with: resultURL) { (data, response, err) in
        guard let pokeData = data, err == nil else {return}
        do {
            let pokemonData = try JSONDecoder().decode(PokemonDTO.self, from: pokeData)
            let myPokemon = Pokemon(from: pokemonData)
            completionHandler(myPokemon)
        } catch {
            print("oh no \(error)")
        }
    }.resume()
}

func fetchImage(url: URL, completionHandler: @escaping (Data) -> Void) {
    URLSession.shared.dataTask(with: url) {data, response, error in
        guard let d = data, error == nil else {return}
        completionHandler(d)
    }.resume()
}
