//
//  BookTableViewController.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/21.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import UIKit
import KeychainAccess

class BookTableViewController: UITableViewController {
	
	var selectedShelf : Shelf?
	
	var booksResponse = BooksRes()
	
	var books = [BookSummary]()
	
	let defaults = UserDefaults.standard
	let keychain = Keychain(service: "com.younusporteous.library")
	var booksURL = "" //"http:localhost:3000/books"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		booksURL = defaults.string(forKey: "baseURL")! + "/books/"
		
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
		performSegue(withIdentifier: "openBookDetails", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! BookDetailViewController
		
		if let indexPath = tableView.indexPathForSelectedRow {
			destinationVC.selectedBookID = books[indexPath.row]._id
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		navigationController?.navigationBar.barTintColor = UIColor(hex3: selectedShelf!.colour)
	}
	
	// MARK: - Loading books
	
	func loadBooks() {
		
		let token = keychain["token"]!
		
		guard let requestURL = URL(string: booksURL) else { return }
		var request = URLRequest(url: requestURL)
		
		request.setValue(token, forHTTPHeaderField: "x-auth")
		
		let task = URLSession.shared.dataTask(with: request) { (data, res, error) in
			guard let receivedData = data else { return }
			do {
				let decoder = JSONDecoder()
				self.booksResponse = try decoder.decode(BooksRes.self, from: receivedData)
				self.books = self.booksResponse.books.filter({ (book) -> Bool in
					return self.selectedShelf?.name == "All" || book.shelf == self.selectedShelf?.name
				})
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			} catch {
				print("Error: \(error)")
			}
		}
		task.resume()
	}
}
