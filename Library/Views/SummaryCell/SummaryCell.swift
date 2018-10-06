//
//  SummaryCell.swift
//  Library
//
//  Created by Younus Porteous on 2018/10/06.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import UIKit

class SummaryCell: UITableViewCell {
	
	@IBOutlet weak var fieldLabel: UILabel!
	@IBOutlet weak var valueTextView: UITextView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		
		valueTextView.layer.borderWidth = 0.5
		valueTextView.layer.borderColor = UIColor.lightGray.cgColor
		
		valueTextView.layer.cornerRadius = 8
		
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}
