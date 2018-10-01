//
//  ProfileViewController.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/26.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
	
	let user = User.currentUser
	
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var numberOfShelvesLabel: UILabel!
	@IBOutlet weak var numberOfBooksLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		let nShelves = user.shelves.count
		let nBooks = user.books.count
		
		
		usernameLabel.text = user.username
		numberOfShelvesLabel.text = "Shelves: \(nShelves)"
		numberOfBooksLabel.text = "Books: \(nBooks)"
	}
	
	
}
