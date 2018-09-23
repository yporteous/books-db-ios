//
//  BookDetailViewController.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/22.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess

class BookDetailViewController: UIViewController {
	
	// MARK: - Properties
	
	// networking
	let keychain = Keychain(service: "com.younusporteous.library")
	let bookURL = "http:localhost:3000/books"
	
	// interface
	var details : NSAttributedString?
	@IBOutlet weak var textField: UITextView!
	
	// attributes
	
	// data
	var selectedBookID : String = ""
	var currentBook = Book()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print(selectedBookID)
		getBook()
	}
	
	// MARK: - Generating the string
	
	// MARK: - Networking
	
	func getBook() {
		let token = keychain["token"]!
		
		let headers : HTTPHeaders = [
			"x-auth": token
		]
		
		let requestURL = bookURL + "/" + selectedBookID
		
		Alamofire.request(requestURL, method: .get, headers: headers).responseJSON { (response) in
			print(response.value!)
		}
	}
}
