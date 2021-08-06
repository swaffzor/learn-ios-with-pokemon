//
//  Model.swift
//  PokeCollection
//
//  Created by Jeremy Swafford on 6/24/21.
//

import UIKit

struct PokemonPaginated: Codable {
    var count = 0
    var next: URL?
    var previous: URL?
    var results = [PokeNamedApi]()
}

struct PokemonDTO: Codable {
    var id = 0
    var name = ""
    var base_experience = 0
    var height = 0
    var is_default = true
    var order = 0
    var weight = 0
    var abilities = [PokemonAbilities]()
    var forms = [PokeNamedApi]()
    var game_indices = [PokeGameIndicies]()
//    var held_items = [PokeHeldItems]()
    var location_area_encounters = ""
    var moves = [PokeMoves]()
    var species = PokeNamedApi()
    var sprites = PokemonSprite()
    var stats = [PokeStat]()
    var types = [PokeType]()
}

struct PokeType: Codable {
    var slot = 0
    var type = PokeNamedApi()
}

struct PokeStat: Codable {
    var base_stat = 0
    var effort = 0
    var stat = PokeNamedApi()
}

struct PokeMoves: Codable {
    var move = PokeNamedApi()
    var version_group_details = [PokeMoveVersion]()
}

struct PokeMoveVersion: Codable {
    var level_learned_at = 0
    var version_group = PokeNamedApi()
    var move_learn_method = PokeNamedApi()
}

struct PokeHeldItems: Codable {
    var item = [PokeNamedApi]()
    var version_details = [PokeVersion]()
}

struct PokeVersion: Codable {
    var rarity = 0
    var version = [PokeNamedApi]()
}

struct PokemonAbilities: Codable {
    var is_hidden = false
    var slot = 0
    var ability = PokeNamedApi()
    
}

struct PokeNamedApi: Codable {
    var name = ""
    var url = ""
}

struct PokeGameIndicies: Codable {
    var game_index = 0
    var version = PokeNamedApi()
}

struct PokemonSprite: Codable {
    var back_female: String?
    var back_shiny_female: String?
    var back_default: String?
    var front_female: String?
    var front_shiny_female: String?
    var back_shiny: String?
    var front_default: String?
    var front_shiny: String?
}

class Pokemon {
    var id = 0
    var name = ""
    var base_experience = 0
    var height = 0
    var is_default = true
    var order = 0
    var weight = 0
    var sprite = ""
    var image: Data?
    var imageLoaded = false
    
    init(pokemon: Pokemon) {
        self.imageLoaded = false
        self.id = pokemon.id
        self.name = pokemon.name
        self.base_experience = pokemon.base_experience
        self.height = pokemon.height
        self.is_default = pokemon.is_default
        self.order = pokemon.order
        self.weight = pokemon.weight
        self.sprite = pokemon.sprite
        self.image = pokemon.image
    }
        
    init(id: Int, name: String, sprite: String) {
        self.id = id
        self.name = name
        self.sprite = sprite
    }
    
    init(from pokemon: PokemonDTO) {
        self.id = pokemon.id
        self.name = pokemon.name
        self.base_experience = pokemon.base_experience
        self.height = pokemon.height
        self.is_default = pokemon.is_default
        self.order = pokemon.order
        self.weight = pokemon.weight
        self.sprite = pokemon.sprites.front_default ?? ""
    }
}

