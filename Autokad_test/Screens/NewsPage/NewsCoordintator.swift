//
//  NewsCoordintator.swift
//  Autokad_test
//
//  Created by Poet on 22.08.2024.
//

import UIKit

class NewsCoordintator: Coordinator {

	let navigationController: UINavigationController
	let serviceContainer = ServiceContainer()

	init(navigationContrller: UINavigationController = UINavigationController()) {
		self.navigationController = navigationContrller
		navigationController.navigationBar.prefersLargeTitles = true
	}

	func start() {
		showNews()
	}

	func end() {

	}
}

extension NewsCoordintator {
	func showNews() {
		let newsModule = NewsAssembler.makeModule(
			dependencies: .init(
				service: serviceContainer.getModelService,
				imageLoader: serviceContainer.imageLoader
			),
			parameters: .init()
		)
		
		navigationController.pushViewController(newsModule, animated: false)
	}
}
