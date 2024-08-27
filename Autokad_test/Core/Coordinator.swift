//
//  Coordinator.swift
//  Autokad_test
//
//  Created by Poet on 22.08.2024.
//

import UIKit

protocol Coordinator {
	func start()
	func end()
}

extension Coordinator {

	func present(navigation: UINavigationController, controllerToPresent: UIViewController, animated: Bool = true) {
		navigation.present(controllerToPresent, animated: animated)
	}
}
