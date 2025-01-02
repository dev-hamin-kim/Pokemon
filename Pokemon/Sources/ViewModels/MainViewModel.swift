//
//  MainViewModel.swift
//  Pokemon
//
//  Created by 김하민 on 12/26/24.
//

import Foundation
import UIKit
import RxSwift
import Kingfisher

class MainViewModel {
    
    private let limit = 20
    private let offset = 0
    private let disposeBag = DisposeBag()
    
    let pokemonListSubject = BehaviorSubject(value: [Pokemon]())
    
    init() {
        fetchPokemonList()
    }
    
    private func fetchPokemonList() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            pokemonListSubject.onError(NetworkError.invalidURL)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (pokemonList: PokemonList) in
                self?.pokemonListSubject.onNext(pokemonList.results)
            }, onFailure: { [weak self] error in
                self?.pokemonListSubject.onError(error)
            }).disposed(by: disposeBag)
    }
}
