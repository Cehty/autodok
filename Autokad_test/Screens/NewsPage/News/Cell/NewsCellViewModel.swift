//  
//  NewsCellViewModel.swift
//  Autokad_test
//
//  Created by Poet on 21.08.2024.
//

import Foundation
import UIKit
import Combine

class NewsCellViewModel: Hashable {
	
	enum Input {
		case didLoad
	}
	
	enum Output {
		case setImage(UIImage?)
		case setTitle(String)
		case setDate(String)
		case setDescription(String)
		case setType(String)
		case setIsShowed(Bool)
	}
	
	private var cancellables = Set<AnyCancellable>()

	private let output: PassthroughSubject<Output, Never> = .init()
	private var image: UIImage?
	private var isShowed = false

	private var model: News

	init(model: News, image: UIImage?) {
        self.model = model
		self.image = image
	}
	
	func getModel() -> News {
		return model
	}
	
	func getIsShowed() -> Bool {
		return isShowed
	}
	
	func isShowedToggle() {
		isShowed.toggle()
		output.send(.setIsShowed(isShowed))
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(model)
	}

	static func == (lhs: NewsCellViewModel, rhs: NewsCellViewModel) -> Bool {
		return lhs.model == rhs.model
	}
	
	deinit {
		cancellables.forEach { $0.cancel() }
		cancellables.removeAll()
	}
}

extension NewsCellViewModel {
	func bind(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
		input.sink { [weak self] event in
			guard let self else { return }
			switch event {
			case .didLoad:
				output.send(.setTitle(model.title))
				let date = AppDateFormatter.shared.string(from: model.publishedDate, dateFormat: .ddMMyyyy)
				output.send(.setDate(date))
				output.send(.setImage(image))
				output.send(.setDescription(model.description))
				output.send(.setType(model.categoryType))
				output.send(.setIsShowed(isShowed))
			}
		}.store(in: &cancellables)
		return output.eraseToAnyPublisher()
	}
	
	func getImageSize(by width: CGFloat) -> CGFloat {
		if let image {
			return image.size.height * width / image.size.width
		} else {
			return 200
		}
	}
}
