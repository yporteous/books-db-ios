//
//  BookSummary.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/22.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import Foundation

class BookSummary : Codable {
	var _id : String = ""
	var title : String = ""
	var author : String = ""
	var tags : String = ""
	var shelf : String = ""
	
	init(withID id : String, title : String, author : String, tags : String, shelf : String) {
		_id = id
		self.title = title
		self.author = author
		self.tags = tags
		self.shelf = shelf
	}
}
