//  
//  ViewAssembler.swift
//  Autokad_test
//
//  Created by Poet on 21.08.2024.
//

import UIKit

class NewsAssembler {
    
    static func makeModule(
        dependencies: NewsAssembler.Dependencies,
        parameters: NewsAssembler.Parameters
    ) -> NewsController {
        let viewModel = NewsViewModel(
			service: dependencies.service,
			imageLoader: dependencies.imageLoader
		)

        return NewsController(viewModel: viewModel)
    }

    struct Dependencies {
		let service: IGetModelService
		let imageLoader: IImageLoader
    }
    
    struct Parameters {
		
    }
}
