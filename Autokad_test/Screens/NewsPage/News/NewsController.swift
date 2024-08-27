//  
//  ViewController.swift
//  Autokad_test
//
//  Created by Poet on 21.08.2024.
//

import UIKit
import Combine

enum NewsSection: Int, Hashable {
    case section
}

final class NewsController: UIViewController {

    private let viewModel: NewsViewModel
	private let input: PassthroughSubject<NewsViewModel.Input, Never> = .init()
	private var cancellables = Set<AnyCancellable>()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var dataSource = makeDataSource()

    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
	@available (*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func loadView() {
        super.loadView()
        view.backgroundColor = .clear
		title = "Новости"
        setupViews()
    }

	override func viewDidLoad() {
		super.viewDidLoad()
		bindViewModel()
		input.send(.didLoad)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	deinit {
		viewModel.cancellables.forEach { $0.cancel() }
		viewModel.cancellables.removeAll()
	}
}

// MARK: - DataSource
private extension NewsController {
    func makeDataSource() -> UICollectionViewDiffableDataSource<NewsSection, NewsCellViewModel> {

        let cellRegistration = UICollectionView.CellRegistration<NewsCell, NewsCellViewModel> { cell, indexPath, item in
            cell.setup(with: item)
        }

        return UICollectionViewDiffableDataSource<NewsSection, NewsCellViewModel>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        )
    }
}

// MARK: - Bindable
private extension NewsController {
	func bindViewModel() {
		let output = viewModel.bind(input.eraseToAnyPublisher())
		output
			.receive(on: DispatchQueue.main)
			.sink { [weak self] event in
				switch event {
				case .apply(let snapshot):
					self?.dataSource.apply(snapshot, animatingDifferences: true)
				case .fetchQuoteDidFail(let error):
					print("\(error)")
				}
			}.store(in: &viewModel.cancellables)
	}
}

// MARK: - Setup Views
private extension NewsController {
    func setupViews() {
        setupCollectionView()
    }

    func setupCollectionView() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Collection View Layout
extension NewsController {
    func generateLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            guard let section = NewsSection(rawValue: section) else { return nil }
            switch section {
            case .section:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 16, leading: 12, bottom: 16, trailing: 12)
                section.interGroupSpacing = 24
                
                return section
            }
        }
    }
}

// MARK: - CollectionViewDelegate
extension NewsController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
		input.send(.didSelectItem(indexPath: indexPath, item: item))
    }
}
