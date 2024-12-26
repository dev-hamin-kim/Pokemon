//
//  PokemonList.swift
//  Pokemon
//
//  Created by 김하민 on 12/26/24.
//

import Foundation

struct PokemonList: Codable {
    let results: [String]
}

struct Pokemon: Codable {
    let name: String
    let url: URL
}
