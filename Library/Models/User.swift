//
//  User.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/21.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import Foundation

class User : Codable {
	var _id = ""
	var username = ""
	var shelves = [Shelf]()
	
	static var currentUser = User()
	
}

