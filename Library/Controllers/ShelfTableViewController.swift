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
		shelves = User.currentUser.shelves
	}
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return shelves.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "shelfCell", for: indexPath)
		
		cell.textLabel!.text = shelves[indexPath.row].name
		cell.backgroundColor = UIColor(hex3: shelves[indexPath.row].colour)
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "goToShelf", sender: self)
	}
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {		
		let destinationVC = segue.destination as! BookTableViewController
		
		if let indexPath = tableView.indexPathForSelectedRow {
			destinationVC.selectedShelf = shelves[indexPath.row]
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}
	
	// use viewDidAppear to clear shelf colour from menu bar
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		navigationController?.navigationBar.barTintColor = nil
		navigationController?.navigationBar.isTranslucent = true
	}
	
	// MARK: - Adding
	
	@IBAction func addNewShelfAction(_ sender: Any) {
		
		var nameField = UITextField()
		var colourField = UITextField() // for now
		
		let alert = UIAlertController(title: "Add new shelf", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add shelf", style: .default) { (action) in
			
			let regex = "#[a-z0-9]{3}"
			
			let newShelf = Shelf()
			newShelf.name = nameField.text!
			
			if colourField.text!.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil {
				newShelf.colour = colourField.text!
			} else {
				newShelf.colour = "#ccc"
			}
			
			self.shelves.append(newShelf)
			User.currentUser.shelves.append(newShelf)
			
			self.tableView.reloadData()
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Shelf name"
			nameField = alertTextField
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Shelf colour"
			colourField = alertTextField
		}
		
		alert.addAction(action)
		alert.addAction(cancelAction)
		present(alert, animated: true, completion: nil)
		
	}
	
}
