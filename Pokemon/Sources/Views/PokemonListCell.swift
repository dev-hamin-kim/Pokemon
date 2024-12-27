//
//  PokemonListCell.swift
//  Pokemon
//
//  Created by 김하민 on 12/26/24.
//

import UIKit

final class PokemonListCell: UICollectionViewCell {
    static let id = "PokemonListCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func setImage(with pokemon: Pokemon) {
        
    }
}
