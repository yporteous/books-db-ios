//
//  ShelfTableViewController.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/21.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import UIKit

class ShelfTableViewController: UITableViewController {
	
	var shelves = [Shelf]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		shelves.append(Shelf(withName: "Fiction", andColour: "#bf9"))
		shelves.append(Shelf(withName: "Science Fiction", andColour: "#8bf"))
	}
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return shelves.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "shelfCell", for: indexPath)
		
		let bg = UIColor(hex3: shelves[indexPath.row].colour)
		
		cell.textLabel!.text = shelves[indexPath.row].name
		cell.backgroundColor = bg
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		performSegue(withIdentifier: "goToShelf", sender: self)
	}
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! BookTableViewController
		
		if let indexPath = tableView.indexPathForSelectedRow {
			destinationVC.selectedShelf = shelves[indexPath.row]
		}
	}
	
}
