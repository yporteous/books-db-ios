//
//  Book.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/21.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import Foundation

// try using Codable to create these?

class Book {
	let defaults = UserDefaults.standard
	
	var properties : [String: Any] = [:]
	
	init(byID id : String, withToken token : String, completion: @escaping (Bool, [String: Any]) -> Void) {
		let bookURL = defaults.string(forKey: "baseURL")! + "/books/"
		guard let requestURL = URL(string: bookURL + id) else { return }
		var request = URLRequest(url: requestURL)
		
		request.setValue(token, forHTTPHeaderField: "x-auth")
		
		let task = URLSession.shared.dataTask(with: request) { (data, res, error) in
			guard let receivedData = data else { return }
			
			if let bookDictionary = (try? JSONSerialization.jsonObject(with: receivedData)) {
				self.properties = bookDictionary as! [String: Any]
				completion(true, bookDictionary as! [String: Any])
			} else {
				completion(false, ["title": "none"])
			}
		}
		task.resume()
	}
}
