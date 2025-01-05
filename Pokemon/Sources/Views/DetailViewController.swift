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
    private let redBackground: UIView = {
        let view = UIView()
        
        view.backgroundColor = .pokemonDarkRed
        view.layer.cornerRadius = 16
        
        return view
    }()
    
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
        
        label.text = "No. ???"
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "???"
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "타입: ???"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        
        label.text = "키: ???"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        
        label.text = "몸무게: ???"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
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
        
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        let stacks = [
            numberAndNameStack,
            typeLabel,
            heightLabel,
            weightLabel,
        ]
        
        stacks.forEach { stackView.addArrangedSubview($0) }
        
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    // MARK: - View Controller initializer
    convenience init(with pokemonID: Int) {
        self.init(nibName: nil, bundle: nil, with: pokemonID)
        bind()
        print("DetailVC Initialized")
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
        view.addSubview(redBackground)
        view.addSubview(pokemonImage)
        view.addSubview(stackView)
        setConstraints()
        print("DetailVC loaded")
    }
    
    // MARK: - View Setup
    private func bind() {
        detailViewModel.pokemonDetailSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] details in
                self?.numberLabel.text = "No. " + details.id.description
                self?.typeLabel.text = "타입: " + (details.types.first?.type.name.inKorean ?? "???")
                
                if details.types.count > 1 {
                    let secondType = details.types[1].type.name.inKorean
                    self?.typeLabel.text?.append(contentsOf: ", \(secondType)")
                }
                
                self?.heightLabel.text = "키: " + String(Double(details.height) / 10.0) + "m"
                self?.weightLabel.text = "몸무게: " + String(Double(details.weight) / 10.0) + "Kg"
            }, onError: { error in
                print("error: \(error)")
            }).disposed(by: disposeBag)
        
        detailViewModel.namesSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pokemon in
                self?.nameLabel.text = pokemon.names.first(where: { $0.language.name == "ko" })?.name
            }, onError: { error in
                print("error: \(error)")
            }).disposed(by: disposeBag)
        
    }
    
    private func setConstraints() {
        redBackground.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalToSuperview().dividedBy(2)
        }
        
        pokemonImage.snp.makeConstraints { make in
            make.top.equalTo(redBackground.snp.top).inset(16)
            make.width.equalTo(redBackground.snp.width).dividedBy(2)
            make.height.equalTo(pokemonImage.snp.width)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(pokemonImage.snp.bottom).offset(16)
            make.bottom.equalTo(redBackground.snp.bottom).inset(40)
            make.horizontalEdges.equalTo(redBackground.snp.horizontalEdges).inset(50)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.trailing.equalTo(pokemonImage.snp.centerX)
        }
        
        
    }
}
