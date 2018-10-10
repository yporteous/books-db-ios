//
//  PickerCell.swift
//  Library
//
//  Created by Younus Porteous on 2018/10/08.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import UIKit

class PickerCell: UITableViewCell, UIPickerViewDataSource {
	
	@IBOutlet weak var fieldLabel: UILabel!
	@IBOutlet weak var shelfPicker: UIPickerView!
	
	let currentUser = User.currentUser
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		
		shelfPicker.layer.borderWidth = 0.5
		shelfPicker.layer.borderColor = UIColor.lightGray.cgColor
		shelfPicker.layer.cornerRadius = 8
		
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return currentUser.shelves.count
	}
	
	
	
}
