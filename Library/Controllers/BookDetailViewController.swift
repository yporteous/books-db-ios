//
//  BookDetailViewController.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/24.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import UIKit
import KeychainAccess

class BookDetailViewController: UITableViewController {
	
	// MARK: - Properties
	let defaults = UserDefaults.standard
	
	// networking
	let keychain = Keychain(service: "com.younusporteous.library")
	var bookURL = "" //"http:localhost:3000/books/"
	
	// interface
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var summaryLabel: UILabel!
		
	// data
	var selectedBookID : String = ""
	var currentBook : Book?
	var detailArray = [(String, String)]()
	var tableFields = [
		"series",
		"publisher",
		"year"
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		bookURL = defaults.string(forKey: "baseURL")! + "/books/"
		
		currentBook = Book(byID: selectedBookID, withToken: keychain["token"]!) { (gotBook, book) in
			if gotBook {
				DispatchQueue.main.async {
					self.updateHeaderFields()
				}
			} else {
				print("Could not get book")
			}
		}
	}
	
	// MARK: - Table view data source
	// TODO: - check which fields are actually present
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableFields.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
		
		let detail = tableFields[indexPath.row]
		
		if let detailValue = currentBook?.properties[detail] {
			// can use localisation to properly capitalise and translate at the same time
			cell.textLabel?.text = "\(detail.capitalized): \(detailValue)"
		}
		
		return cell
	}
	
	// MARK: - Networking
	
	// MARK: - Tabel view header data and layout
	
	func updateHeaderFields() {
		guard let book = currentBook?.properties else {
			//also return to previous view as this means the book data is invalid
			return
		}
		titleLabel.text = book["title"] as? String
		authorLabel.text = book["author"] as? String
		summaryLabel.text = book["summary"] as? String
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		guard let headerView = tableView.tableHeaderView else { return }
		
		let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		
		if headerView.frame.size.height != size.height {
			headerView.frame.size.height = size.height
			tableView.tableHeaderView = headerView
			tableView.layoutIfNeeded()
		}
	}
	
}
