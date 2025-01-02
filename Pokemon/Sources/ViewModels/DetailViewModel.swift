//
//  DetailViewModel.swift
//  Pokemon
//
//  Created by 김하민 on 12/27/24.
//

import Foundation
import RxSwift

final class DetailViewModel {
    
    private let disposeBag = DisposeBag()
    
    let pokemonID: Int
    let pokemonDetailSubject = PublishSubject<PokemonDetail>()
    
    init(of pokemonID: Int) {
        self.pokemonID = pokemonID
    }
    
    private func fetchPokemonDetails() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonID.description)/") else {
            pokemonDetailSubject.onError(NetworkError.invalidURL)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (details: PokemonDetail) in
                self?.pokemonDetailSubject.onNext(details)
            }, onFailure: { [weak self] error in
                self?.pokemonDetailSubject.onError(error)
            }).disposed(by: disposeBag)
    }
}
