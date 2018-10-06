//
//  AddBookTableViewController.swift
//  Library
//
//  Created by Younus Porteous on 2018/10/02.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import UIKit

struct CellModel {
	var field : String
	var value : String
	var type : cellType
}

enum cellType {
	case textField
	case textView
}

class AddBookTableViewController: UITableViewController {
	
	//var selectedBook : Book?
	var bookTableDelegate : BookTableViewController?
	
	let bookKeys : [CellModel] = [
		CellModel(field: "title", value: "", type: .textField),
		CellModel(field: "author", value: "", type: .textField),
		CellModel(field: "shelf", value: "", type: .textField),
		CellModel(field: "series", value: "", type: .textField),
		CellModel(field: "year", value: "", type: .textField),
		CellModel(field: "publisher", value: "", type: .textField),
		CellModel(field: "tags", value: "", type: .textField),
		CellModel(field: "summary", value: "", type: .textView)
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.register(UINib(nibName: "AddEditCell", bundle: nil), forCellReuseIdentifier: "addBookCellField")
		tableView.register(UINib(nibName: "SummaryCell", bundle: nil), forCellReuseIdentifier: "addBookCellView")
	}
	
	@IBAction func cancelButtonPressed(_ sender: Any) {
		self.dismiss(animated: true)
	}
	
	
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return bookKeys.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let currentCellModel = bookKeys[indexPath.row]
		
		if currentCellModel.type == .textField {
			let cell = tableView.dequeueReusableCell(withIdentifier: "addBookCellField", for: indexPath) as! AddEditCell
			
			// use localisation
			cell.fieldLabel.text = currentCellModel.field.capitalized
			
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "addBookCellView", for: indexPath) as! SummaryCell
			
			cell.fieldLabel.text = currentCellModel.field.capitalized
			
			return cell
		}
	}
}
