//
//  BookSummary.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/22.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import Foundation

class BookSummary {
	var title : String = ""
	var author : String = ""
	var tags : String = ""
	var shelf : String = ""
	
	init(withTitle title : String, author : String, tags : String, shelf : String) {
		self.title = title
		self.author = author
		self.tags = tags
		self.shelf = shelf
	}
}
