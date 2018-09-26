//
//  User.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/21.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import Foundation

struct BooksRes : Codable {
	var books = [BookSummary]()
}

class User : Codable {
	var _id = ""
	var username = ""
	var shelves = [Shelf]()
	var books = [BookSummary]()
	
	init() {}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self._id = try container.decode(String.self, forKey: ._id)
		self.username = try container.decode(String.self, forKey: .username)
		self.shelves = try container.decode([Shelf].self, forKey: .shelves)
		if let books = try container.decodeIfPresent([BookSummary].self, forKey: .books) {
			self.books = books
		}

	}
	
	static var currentUser = User()
	
}

