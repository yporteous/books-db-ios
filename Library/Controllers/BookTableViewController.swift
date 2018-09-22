//
//  BookTableViewController.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/21.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import UIKit
import Alamofire
import KeychainAccess
import SwiftyJSON

class BookTableViewController: UITableViewController {
	
	var selectedShelf : Shelf?
	var books = [BookSummary]()
	
	let keychain = Keychain(service: "com.younusporteous.library")
	let booksURL = "http:localhost:3000/books"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loadBooks()
		
		self.navigationItem.title = selectedShelf?.name
	}
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return books.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath)
		
		cell.textLabel!.text = books[indexPath.row].title
		
		return cell
	}
	
	// MARK: - Navigation
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: - Loading books
	
	func loadBooks() {
		let token = keychain["token"]!
		
		let headers : HTTPHeaders = [
			"x-auth": token
		]
		
		Alamofire.request(booksURL, method: .get, headers: headers).responseJSON { (response) in
			self.books = self.parseShelves(JSON(response.value!)["books"])
			self.tableView.reloadData()
		}
	}
	
	func parseShelves(_ books : JSON) -> [BookSummary] {
		var bookArray = [BookSummary]()
		
		for (_, bookJSON) : (String, JSON) in books {
			if selectedShelf?.name == "All" || bookJSON["shelf"].stringValue == selectedShelf?.name {
				bookArray.append(BookSummary(withTitle: bookJSON["title"].stringValue,
																		 author: bookJSON["author"].stringValue,
																		 tags: bookJSON["tags"].stringValue,
																		 shelf: bookJSON["shelf"].stringValue))
			}
		}
		
		return bookArray
	}
	
}
