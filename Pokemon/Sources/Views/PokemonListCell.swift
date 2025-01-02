//
//  PokemonListCell.swift
//  Pokemon
//
//  Created by 김하민 on 12/26/24.
//

import UIKit
import SnapKit

final class PokemonListCell: UICollectionViewCell {
    static let id = "PokemonListCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .cyan
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPink
        contentView.addSubview(imageView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }
    
    func setImage(with image: UIImage) {
        imageView.image = image
    }
}
