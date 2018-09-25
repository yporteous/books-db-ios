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
	var currentBook = Book()
	var detailArray = [(String, String)]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		bookURL = defaults.string(forKey: "baseURL")! + "/books/"
		
		//print(selectedBookID)
		getBook()
	}
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return detailArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
		
		let detail = detailArray[indexPath.row]
		
		cell.textLabel?.text = "\(detail.0): \(detail.1)"
		
		return cell
	}
	
	// MARK: - Networking
	
	func getBook() {
		let token = keychain["token"]
		
		guard let requestURL = URL(string: bookURL + selectedBookID) else { return }
		var request = URLRequest(url: requestURL)
		
		request.setValue(token, forHTTPHeaderField: "x-auth")
		
		let task = URLSession.shared.dataTask(with: request) { (data, res, error) in
			guard let receivedData = data else { return }
			do {
				let decoder = JSONDecoder()
				self.currentBook = try decoder.decode(Book.self, from: receivedData)
				self.detailArray = Mirror(reflecting: self.currentBook.details)
					.children
					.compactMap({ (child) -> (String, String) in
						let value = "\(child.value)"
						return (child.label!.capitalized, value)
					})
				
				DispatchQueue.main.async {
					self.updateHeaderFields()
					self.tableView.reloadData()
				}
				
			} catch {
				print("Error: \(error)")
			}
		}
		task.resume()
	}
	
	// MARK: - Tabel view header data and layout
	
	func updateHeaderFields() {
		titleLabel.text = currentBook.title
		authorLabel.text = currentBook.author
		summaryLabel.text = currentBook.summary
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
