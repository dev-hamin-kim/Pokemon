//
//  PokemonSpecies.swift
//  Pokemon
//
//  Created by 김하민 on 1/5/25.
//

struct PokemonSpecies: Codable {
    var names: [Name] = []
}

struct Name: Codable {
    let name: String
    let language: Language
}

struct Language: Codable {
    let name: String
    let url: String
}
