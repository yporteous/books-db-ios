//
//  AddBookTableViewController.swift
//  Library
//
//  Created by Younus Porteous on 2018/10/02.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import UIKit
import KeychainAccess

struct CellModel {
	var field : String
	var value : String
	var type : cellType
}

enum cellType {
	case textField
	case textView
	case picker
}

class AddBookTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
	
	let keychain = Keychain(service: "com.younusporteous.library")
	
	//var selectedBook : Book?
	var bookTableDelegate : BookTableViewController?
	var currentUser = User.currentUser
	
	var pickerRow : Int?
	
	var bookKeys : [CellModel] = [
		CellModel(field: "title", value: "", type: .textField),
		CellModel(field: "author", value: "", type: .textField),
		CellModel(field: "shelf", value: "", type: .picker),
		CellModel(field: "series", value: "", type: .textField),
		CellModel(field: "year", value: "", type: .textField),
		CellModel(field: "publisher", value: "", type: .textField),
		CellModel(field: "tags", value: "", type: .textField),
		CellModel(field: "summary", value: "", type: .textView)
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.register(UINib(nibName: "AddEditCell", bundle: nil), forCellReuseIdentifier: "addBookCellField")
		tableView.register(UINib(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "addBookCellPicker")
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
		
		if currentCellModel.type == .textView {
			let cell = tableView.dequeueReusableCell(withIdentifier: "addBookCellView", for: indexPath) as! SummaryCell
			
			cell.fieldLabel.text = currentCellModel.field.capitalized
			cell.valueTextView.tag = indexPath.row
			
			cell.valueTextView.delegate = self
			
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "addBookCellField", for: indexPath) as! AddEditCell
			
			// use localisation
			cell.fieldLabel.text = currentCellModel.field.capitalized
			cell.valueTextField.tag = indexPath.row
			
			// set self as delegate to get changes
			cell.valueTextField.delegate = self
			
			// additional setup for picker
			if currentCellModel.type == .picker {
				let shelfPicker = UIPickerView()
				shelfPicker.delegate = self
				shelfPicker.dataSource = self
				shelfPicker.tag = indexPath.row
				pickerRow = indexPath.row
				cell.valueTextField.inputView = shelfPicker
				cell.valueTextField.tintColor = .clear
				
				cell.valueTextField.rightView = {
					let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
					label.text = "∨"
					label.textColor = UIColor.lightGray
					return label
				}()
				cell.valueTextField.rightViewMode = .always
			}
			
			return cell
		}
	}
	
	// MARK: - editing a row - delegate methods
	
	//TextField
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if textField.tag == pickerRow {
			return false
		}
		bookKeys[textField.tag].value = (textField.text as NSString?)!.replacingCharacters(in: range, with: string)
		return true
	}
	
	//TextView
	func textViewDidChange(_ textView: UITextView) {
		bookKeys[textView.tag].value = textView.text!
	}
	
	//PickerView
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		let indexPath = IndexPath(row: pickerView.tag, section: 0)
		
		
		(tableView.cellForRow(at: indexPath) as! AddEditCell).valueTextField.text = currentUser.shelves[row].name
		bookKeys[pickerView.tag].value = currentUser.shelves[row].name
		print("Shelf is now '\(bookKeys[pickerView.tag].value)'")
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return currentUser.shelves[row].name
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return currentUser.shelves.count
	}
	
	// MARK: - Save book
	
	@IBAction func saveButtonPressed(_ sender: Any) {		
		let newBook = Book()
		
		for field in bookKeys {
			newBook.properties[field.field] = field.value
		}
		// validate missing values
		// validate incompatible values (year -> number)
		
		newBook.saveAsNewBook(withToken: keychain["token"]!) { (completed) in
			if completed {
				User.currentUser.refreshBooks(withToken: self.keychain["token"]!, completion: { (completed) in
					if completed {
						DispatchQueue.main.sync {
							// need to check which delegate to refresh for when editing is enabled
							self.dismiss(animated: true)
							if let delegate = self.bookTableDelegate {
								delegate.reloadBooks()
							}
						}
					}
				})
			}
		}
	}
	
}
