//
//  User.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/21.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import KeychainAccess


class User {
	var _id = ""
	var shelves = [Shelf]()
	var books = [Book]()
	
	
	
	
	static let currentUser = User()
	
}
