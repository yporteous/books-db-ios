//
//  Book.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/21.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import Foundation

// try using Codable to create these?

class Book : Decodable {
	var title : String
	var author : String
	//var series : String
	//var year : Int
	//var publisher : String
	var details : Details
	
	var summary : String // UITextView?
	var tags : String
	var shelf : String
	
	enum CodingKeys: String, CodingKey {
		case title
		case author
		case summary
		case tags
		case shelf
		case details
		case series
		case year
		case publisher
	}
	
	init() {
		title = ""
		author = ""
		summary = ""
		tags = ""
		shelf = ""
		details = Details()
	}
	
	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		title = try values.decode(String.self, forKey: .title)
		author = try values.decode(String.self, forKey: .author)
		summary = try values.decode(String.self, forKey: .summary)
		tags = try values.decode(String.self, forKey: .tags)
		shelf = try values.decode(String.self, forKey: .shelf)
		details = try Details(from: decoder)
	}
}

struct Details : Decodable {
	var series : String = ""
	var year : Int = 0
	var publisher : String = ""
}
