//
//  ViewController.swift
//  Pokemon
//
//  Created by 김하민 on 12/24/24.
//

import UIKit
import RxSwift
import Kingfisher

final class MainViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let mainViewModel = MainViewModel()
    private var pokemonList = [Pokemon]()

    
    private let pokeBall: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(resource: .pokeBall)
        
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        collectionView.register(PokemonListCell.self,
                                forCellWithReuseIdentifier: PokemonListCell.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .pokemonDarkRed
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        setUI()
        setConstraints()
        print("MainViewController Loaded")
    }

    private func bind() {
        mainViewModel.pokemonListSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pokemons in
                self?.pokemonList = pokemons
                self?.collectionView.reloadData()
            }, onError: { error in
                print("error: \(error)")
            }).disposed(by: disposeBag)
    }
    
    private func setUI() {
        view.backgroundColor = .pokemonMainRed
        
        view.addSubview(pokeBall)
        view.addSubview(collectionView)
    }
    
    private func setConstraints() {
        pokeBall.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalTo(pokeBall.snp.width)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(pokeBall.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalWidth(1/3)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1/3)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }

}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected: \(indexPath.item.description)")
        let detailVC = DetailViewController(with: indexPath.item + 1)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonListCell.id, for: indexPath) as? PokemonListCell
        else { return UICollectionViewCell() }
        
        let urlPrefix = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"
        let url = URL(string: urlPrefix + "\(indexPath.item + 1).png")
        
        cell.imageView.kf.setImage(with: url, placeholder: UIImage(resource: .pokeBall))
        
        return cell
    }
    
    
}
