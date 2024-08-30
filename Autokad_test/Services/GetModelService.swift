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
	func getModel(count: Int) async throws -> [News]?
}

actor GetModelService: IGetModelService {

	private let pageSize = 15
	
	func getModel(count: Int) async throws -> [News]? {
		guard let url = getURL(count: count) else { throw BaseErrors.invalidURL }
		
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

private extension GetModelService {
	func getURL(count: Int) -> URL? {
		let offset = count / pageSize + 1
		var urlComponent = URLComponents()
		urlComponent.scheme = "https"
		urlComponent.host = "webapi.autodoc.ru"
		urlComponent.path = "/api/news/\(offset)/\(pageSize)"
		return urlComponent.url
	}
}

actor TestGetModelService: IGetModelService {
	func getModel(count: Int) async throws -> [News]? {
		return [News()]
	}
}

