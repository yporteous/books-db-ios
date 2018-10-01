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
		
		books = User.currentUser.books.filter({ (book) -> Bool in
			return self.selectedShelf?.name == "All" || book.shelf == self.selectedShelf?.name
		})
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
}
