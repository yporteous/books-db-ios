//
//  AddBookTableViewController.swift
//  Library
//
//  Created by Younus Porteous on 2018/10/02.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import UIKit

class AddBookTableViewController: UITableViewController {
	
	//var selectedBook : Book?
	var bookTableDelegate : BookTableViewController?
	
	let bookKeys = [
		"title",
		"author",
		"shelf",
		"series",
		"year",
		"publisher",
		"tags",
		"summary"
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.register(UINib(nibName: "AddEditCell", bundle: nil), forCellReuseIdentifier: "addBookCell")
	}
	
	@IBAction func cancelButtonPressed(_ sender: Any) {
		self.dismiss(animated: true)
	}
	
	
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return bookKeys.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "addBookCell", for: indexPath) as! AddEditCell
		
		// use localisation
		cell.fieldLabel.text = bookKeys[indexPath.row].capitalized
		
		//cell.textLabel!.text = bookKeys[indexPath.row]
		
		// Configure the cell...
		
		return cell
	}
	
}
