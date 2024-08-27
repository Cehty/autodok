//  
//  NewsViewModel.swift
//  Autokad_test
//
//  Created by Poet on 21.08.2024.
//

import UIKit
import Combine

final class NewsViewModel {
	
	enum Input {
		case didLoad
		case didSelectItem(indexPath: IndexPath, item: AnyHashable)
	}
	
	enum Output {
		case apply(snapshot: NSDiffableDataSourceSnapshot<NewsSection, NewsCellViewModel>)
		case fetchQuoteDidFail(error: Error)
	}
	
	var cancellables = Set<AnyCancellable>()

	private let output: PassthroughSubject<Output, Never> = .init()
	private let service: IGetModelService
	private let imageLoader: IImageLoader
    private var snapshot = NSDiffableDataSourceSnapshot<NewsSection, NewsCellViewModel>()

	init(service: IGetModelService, imageLoader: IImageLoader) {
		self.service = service
		self.imageLoader = imageLoader
    }
}

private extension NewsViewModel {
	func makeModels() async {
		do {
			snapshot.deleteSections([.section])
			snapshot.appendSections([.section])
			guard let models: [News] = try await service.getModel() else { return }

			let items = try await withThrowingTaskGroup(of: NewsCellViewModel.self, returning: [NewsCellViewModel].self) { [weak self] group in
				guard let self else { return [] }
				for model in models {
					group.addTask { try await self.makeImtem(for: model) }
				}

				var items = [NewsCellViewModel]()
				
				for try await item in group {
					items.append(item)
				}

				return items
			}
			
			let sortedItems = items.sorted { $0.getModel().publishedDate < $1.getModel().publishedDate }
			
			snapshot.appendItems(sortedItems, toSection: .section)
			
			output.send(.apply(snapshot: snapshot))
		} catch {
			output.send(.fetchQuoteDidFail(error: error))
		}
	}
	
	func makeImtem(for model: News) async throws -> NewsCellViewModel {
		let image = try await imageLoader.fetchPhoto(url: model.titleImageUrl)
		return NewsCellViewModel(model: model, image: image)
	}
}

extension NewsViewModel {
	func bind(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
		input.sink { [weak self] event in
			guard let self else { return }
			switch event {
			case .didLoad:
				Task {
					await self.makeModels()
				}
			case .didSelectItem(_, let item):
				guard let item = item as? NewsCellViewModel else { return }
				item.isShowedToggle()
				output.send(.apply(snapshot: snapshot))
			}
		}.store(in: &cancellables)
		return output.eraseToAnyPublisher()
	}
}
