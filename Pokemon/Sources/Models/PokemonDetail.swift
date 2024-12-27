//
//  PokemonDetail.swift
//  Pokemon
//
//  Created by 김하민 on 12/26/24.
//

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let types: [PokemonType]
    let height: Int
    let weight: Int
}

struct PokemonType: Codable {
    let slot: Int
    let type: String
}
