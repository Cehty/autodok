//
//  Autokad_testTests.swift
//  Autokad_testTests
//
//  Created by Poet on 27.08.2024.
//

import XCTest
@testable import Autokad_test
import Combine

final class Autokad_testTests: XCTestCase {
	
	let service = TestGetModelService()
	let imageLoader = TestImageLoader()
	
	func test_DidLoad() throws {
		let viewModel = NewsViewModel(service: service, imageLoader: imageLoader)
		let input: PassthroughSubject<NewsViewModel.Input, Never> = .init()
		
		let output = viewModel.bind(input.eraseToAnyPublisher())
		
		output
			.sink { event in
				switch event {
				case .apply(let snapshot):
					let items = snapshot.itemIdentifiers
					XCTAssertEqual(items, [NewsCellViewModel(model: News(), image: UIImage())])
				case .fetchQuoteDidFail(_):
					break
				}
			}.store(in: &viewModel.cancellables)
		
		input.send(.didLoad)
    }
	
	func test_DidSelectItem() throws {
		let viewModel = NewsViewModel(service: service, imageLoader: imageLoader)
		let input: PassthroughSubject<NewsViewModel.Input, Never> = .init()
		
		let output = viewModel.bind(input.eraseToAnyPublisher())
		
		var item: NewsCellViewModel?
		
		output
			.sink { event in
				switch event {
				case .apply(let snapshot):
					item = snapshot.itemIdentifiers.first
				case .fetchQuoteDidFail(_):
					break
				}
			}.store(in: &viewModel.cancellables)
		
		input.send(.didLoad)
		
		guard let item else { return }
		input.send(.didSelectItem(indexPath: .init(item: 0, section: 0), item: item))
		XCTAssertEqual(item.getIsShowed(), true)
	}
	
	func test_NewsCell_DidLoad() throws {
		let cellViewModel = NewsCellViewModel(model: News(), image: UIImage())
		let input: PassthroughSubject<NewsCellViewModel.Input, Never> = .init()
		
		let output = cellViewModel.bind(input.eraseToAnyPublisher())
		
		output
			.sink { event in
				switch event {
				case .setImage(let image):
					XCTAssertEqual(image, UIImage())
				case .setTitle(let title):
					XCTAssertEqual(title, "")
				case .setDate(let date):
					let value = AppDateFormatter.shared.string(from: Date(), dateFormat: .ddMMyyyy)
					XCTAssertEqual(date, value)
				case .setDescription(let description):
					XCTAssertEqual(description, "")
				case .setType(let type):
					XCTAssertEqual(type, "")
				case .setIsShowed(let isShowed):
					break
				}
			}.store(in: &cellViewModel.cancellables)
		
		input.send(.didLoad)
	}
}
