//
//  PokemonList.swift
//  Pokemon
//
//  Created by 김하민 on 12/26/24.
//

import Foundation

struct PokemonList: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let number: Int
    let name: String
    let url: URL
}
