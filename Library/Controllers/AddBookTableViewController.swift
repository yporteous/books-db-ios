//
//  AddBookTableViewController.swift
//  Library
//
//  Created by Younus Porteous on 2018/10/02.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import UIKit

class AddBookTableViewController: UITableViewController {
	
	var selectedBook : Book?
	
	let bookKeys = [
		["title", "author", "shelf"],
		["series", "year", "publisher"],
		["tags", "summary"]
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return bookKeys.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return bookKeys[section].count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "addBookCell", for: indexPath)
		if indexPath.section == 1 {
			
		}
		// Configure the cell...
		
		return cell
	}
	
}
