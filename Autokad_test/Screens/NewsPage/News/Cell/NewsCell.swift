//
//  ViewCell.swift
//  Autokad_test
//
//  Created by Poet on 21.08.2024.
//

import UIKit
import Combine

class NewsCell: UICollectionViewCell {
	
	private lazy var verticalStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.spacing = UIDevice.current.userInterfaceIdiom == .pad ? 12 : 8
		return stackView
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.textColor = .white
		label.font = .systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? 31 : 21, weight: .bold)
		return label
	}()
	
	private lazy var dateLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .systemGray
		label.textAlignment = .right
		label.font = .systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? 24 : 14, weight: .regular)
		return label
	}()
	
	private lazy var typeLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .systemRed
		label.font = .systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? 24 : 14, weight: .regular)
		return label
	}()
	
	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.numberOfLines = 0
		label.font = .systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? 27 : 17, weight: .regular)
		label.isHidden = true
		return label
	}()
	
	private lazy var imageView: UIImageView = {
		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var horisontalStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.isHidden = true
		return stackView
	}()
	
	override var isHighlighted: Bool {
		didSet {
			shrink(with: isHighlighted ? .down : .identity)
		}
	}
	
	private var viewModel: NewsCellViewModel?
	private let input: PassthroughSubject<NewsCellViewModel.Input, Never> = .init()
	private var cancellables = Set<AnyCancellable>()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.backgroundColor = .backView
		contentView.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 40 : 20
		contentView.layer.masksToBounds = true
		setupViews()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		cancellables.forEach { $0.cancel() }
		cancellables.removeAll()
	}
	
	func setup(with viewModel: NewsCellViewModel) {
		self.viewModel = viewModel
		bindViewModel()
		input.send(.didLoad)
	}
}

// MARK: - Bindable
private extension NewsCell {
	func bindViewModel() {
		guard let viewModel else { return }
		let output = viewModel.bind(input.eraseToAnyPublisher())
		output
			.sink { [weak self] event in
				guard let self else { return }
				switch event {
				case .setImage(let image):
					if let image {
						self.imageView.image = image
					}
					self.setupImageViewConstraints()
				case .setTitle(let title):
					self.titleLabel.text = title
				case .setDate(let date):
					self.dateLabel.text = date
				case .setDescription(let description):
					self.descriptionLabel.text = description
				case .setType(let type):
					self.typeLabel.text = type
				case .setIsShowed(let isShowed):
					self.descriptionLabel.isHidden = !isShowed
					self.horisontalStackView.isHidden = !isShowed
				}
			}.store(in: &cancellables)
	}
}

private extension NewsCell {
	func setupViews() {
		setupImageView()
		setupVerticalStackView()
		setupHorisontalStackView()
	}
	
	func setupImageView() {
		contentView.addSubview(imageView)
		
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
		])
	}
	
	func setupVerticalStackView() {
		contentView.addSubview(verticalStackView)
		let inset: CGFloat =  UIDevice.current.userInterfaceIdiom == .pad ? 26 : 16
		
		NSLayoutConstraint.activate([
			verticalStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: inset),
			verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
			verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
			verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
		])
		
		verticalStackView.addArrangedSubview(horisontalStackView)
		verticalStackView.addArrangedSubview(titleLabel)
		verticalStackView.addArrangedSubview(descriptionLabel)
	}
	
	func setupHorisontalStackView() {
		horisontalStackView.addArrangedSubview(typeLabel)
		horisontalStackView.addArrangedSubview(dateLabel)
	}
	
	func setupImageViewConstraints() {
		let imageHeight = viewModel?.getImageSize(by: contentView.frame.width) ?? 0
		
		NSLayoutConstraint.activate([
			imageView.heightAnchor.constraint(equalToConstant: imageHeight)
		])
	}
}
