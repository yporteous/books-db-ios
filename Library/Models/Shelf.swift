//
//  Shelf.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/21.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import UIKit

class Shelf : Codable {
	var name : String
	var colour : String
	
	init(withName name : String = "", andColour colour : String = "#ccc") {
		self.name = name
		self.colour = colour
	}
}
