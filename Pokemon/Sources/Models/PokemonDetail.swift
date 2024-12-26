//
//  PokemonDetail.swift
//  Pokemon
//
//  Created by 김하민 on 12/26/24.
//

struct PokemonDetail: Codable {
    let number: Int
    let name: String
    let types: PokemonTypes
    let height: Int
    let weight: Int
}

struct PokemonTypes: Codable {
    let slot: Int
    let type: String
}
