//
//  DetailViewController.swift
//  Pokemon
//
//  Created by 김하민 on 12/27/24.
//

import UIKit
import RxSwift
import SnapKit

final class DetailViewController: UIViewController {
    
    let pokemonID: Int
    
    private let disposeBag = DisposeBag()
    private lazy var detailViewModel = DetailViewModel(of: pokemonID)
    
    // MARK: - UI Components
    private lazy var pokemonImage: UIImageView = {
        let imageView = UIImageView()
        let urlPrefix = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"
        let url = URL(string: urlPrefix + "\(pokemonID).png")
        
        imageView.kf.setImage(with: url, placeholder: UIImage(resource: .pokeBall))
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: - StackViews
    private lazy var numberAndNameStack: UIStackView = {
        let stackView = UIStackView()
        
        let stacks = [numberLabel, nameLabel]
        
        stacks.forEach { stackView.addArrangedSubview($0) }
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        let stacks = [
            pokemonImage,
            numberAndNameStack,
            typeLabel,
            heightLabel,
            weightLabel,
        ]
        
        stacks.forEach { stackView.addArrangedSubview($0) }
        
        stackView.backgroundColor = .pokemonDarkRed
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    // MARK: - View Controller initializer
    convenience init(with pokemonID: Int) {
        self.init(nibName: nil, bundle: nil, with: pokemonID)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, with pokemonID: Int) {
        self.pokemonID = pokemonID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pokemonMainRed
//        setDefaultValue()
        bind()
        view.addSubview(stackView)
        setConstraints()
        print("DetailVC loaded")
    }
    
    // MARK: - View Setup
    private func bind() {
        detailViewModel.pokemonDetailSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] details in
                self?.numberLabel.text = details.id.description
                self?.nameLabel.text = details.name
                self?.typeLabel.text = details.types.first?.type.name
                self?.heightLabel.text = details.height.description
                self?.weightLabel.text = details.weight.description
            }, onError: { error in
                print("error: \(error)")
            }).disposed(by: disposeBag)
    }
    
    private func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(pokemonImage.snp.height).multipliedBy(2)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        pokemonImage.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.top).inset(16)
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(pokemonImage.snp.width)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        numberAndNameStack.snp.makeConstraints { make in
            make.centerX.equalTo(pokemonImage.snp.centerX)
            
        }
        
    }
    
    private func setDefaultValue() {
        numberLabel.text = "???"
        nameLabel.text = "???"
        typeLabel.text = "???"
        heightLabel.text = "Height: ???"
        weightLabel.text = "Weight: ???"
    }
}
