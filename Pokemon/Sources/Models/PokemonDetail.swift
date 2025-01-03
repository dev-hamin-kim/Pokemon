//
//  PokemonDetail.swift
//  Pokemon
//
//  Created by 김하민 on 12/26/24.
//

import Foundation

struct PokemonDetail: Codable {
    let id: Int
    var name: String = ""
    var types: [PokemonType] = []
    var height: Int = 0
    var weight: Int = 0
}

struct PokemonType: Codable {
    let slot: Int
    let type: TypeInfo
}

struct TypeInfo: Codable {
    let name: String
    let url: URL
}
