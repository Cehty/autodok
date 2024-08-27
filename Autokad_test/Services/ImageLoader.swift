//
//  ImageLoader.swift
//  Autokad_test
//
//  Created by Poet on 22.08.2024.
//

import Foundation
import UIKit

protocol IImageLoader: AnyActor {
	func fetchPhoto(url: String) async throws -> UIImage
}

actor ImageLoader: IImageLoader {
	func fetchPhoto(url: String) async throws -> UIImage {
		guard let url = URL(string: url) else { throw BaseErrors.invalidURL }
		let (data, response) = try await URLSession.shared.data(from: url)
		
		guard let httpResponse = response as? HTTPURLResponse,
			  httpResponse.statusCode == 200 else {
			throw BaseErrors.invalidResponse
		}
		
		guard let image = UIImage(data: data) else {
			throw BaseErrors.invalidModel
		}
		
		return image
	}
}

actor TestImageLoader: IImageLoader {
	func fetchPhoto(url: String) async throws -> UIImage {
		return UIImage()
	}
}

