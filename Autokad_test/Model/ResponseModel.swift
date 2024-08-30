//
//  RequestModel.swift
//  DikidiTest
//
//  Created by Poet on 20.06.2024.
//

import Foundation
import SwiftUI

struct ReponceData: Codable, Hashable {
	let news: [News]
	let totalCount: Int
}

struct News: Codable, Hashable {
	let id: Int
	let title: String
	let description: String
	let publishedDate: Date
	let url: String
	let fullUrl: String
	let titleImageUrl: String?
	let categoryType: String
	var isShowed: Bool = false
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(Int.self, forKey: .id)
		self.title = try container.decode(String.self, forKey: .title)
		self.description = try container.decode(String.self, forKey: .description)
		let publishedDate = try container.decode(String.self, forKey: .publishedDate)
		let convertDate = AppDateFormatter.shared.date(from: publishedDate, dateFormat: .yyyyMMddHHmmssSSSZ)
		if let convertDate {
			self.publishedDate = convertDate
		} else {
			self.publishedDate = AppDateFormatter.shared.date(from: publishedDate, dateFormat: .yyyyMMddHHmmss)!
		}
		self.url = try container.decode(String.self, forKey: .url)
		self.fullUrl = try container.decode(String.self, forKey: .fullUrl)
		self.titleImageUrl = try container.decodeIfPresent(String.self, forKey: .titleImageUrl)
		self.categoryType = try container.decode(String.self, forKey: .categoryType)
	}
	
	init() {
		self.id = 0
		self.title = ""
		self.description = ""
		self.publishedDate = Date()
		self.url = ""
		self.fullUrl = ""
		self.titleImageUrl = ""
		self.categoryType = ""
	}
}
