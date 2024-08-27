//
//  ServiceContainer.swift
//  Autokad_test
//
//  Created by Poet on 22.08.2024.
//

import Foundation

struct ServiceContainer {
	
	static let shared = ServiceContainer()
	
	init() { }
	
	var getModelService: GetModelService {
		return GetModelService()
	}
	
	var imageLoader: ImageLoader {
		return ImageLoader()
	}
}

