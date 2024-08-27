//
//  GetModelService.swift
//  DikidiTest
//
//  Created by Poet on 20.06.2024.
//

import Foundation
import Combine
import UIKit

protocol IGetModelService: AnyActor {
	func getModel() async throws -> [News]?
}

actor GetModelService: IGetModelService {
    private let url = URL(string: "https://webapi.autodoc.ru/api/news/1/15")!
    
	func getModel() async throws -> [News]? {
		let (data, response) = try await URLSession.shared.data(from: url)
		
		guard let httpResponse = response as? HTTPURLResponse,
				httpResponse.statusCode == 200 else {
			throw BaseErrors.invalidResponse
		}
		
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let model = try decoder.decode(ReponceData.self, from: data)
		return model.news
    }
}

actor TestGetModelService: IGetModelService {
	func getModel() async throws -> [News]? {
		return [News()]
	}
}

