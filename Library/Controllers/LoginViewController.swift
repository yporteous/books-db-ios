//
//  LoginViewController.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/21.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess

class LoginViewController: UIViewController {
	
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	let loginURL = "http://localhost:3000/users/login"
	let shelvesURL = "http://localhost:3000/shelves"
	
	let keychain = Keychain(service: "com.younusporteous.library")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		// test for token
		if keychain["token"] != nil {
			getUserData()
		} else {
			print("No token; please log in")
		}
	}
	
	// MARK: - Logging in
	
	@IBAction func loginButtonPressed(_ sender: Any) {
		login(username: usernameTextField.text!, password: passwordTextField.text!)
	}
	
	func login(username : String, password : String) {
		
		let parameters : Parameters = [
			"user": [
				"username": username,
				"password": password
			]
		]
		
		Alamofire.request(loginURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
			if let token = response.response?.allHeaderFields["x-auth"] as? String {
				self.keychain["token"] = token
				User.currentUser.shelves = self.parseShelves(JSON(response.result.value!)["shelves"])
				self.performSegue(withIdentifier: "login", sender: self)
			} else {
				print("unable to log in")
			}
		}
	}
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// load necessary user data from the server before going to Shelf Table
		
	}
	
	func getUserData () {
		let token = keychain["token"]!
		
		let headers : HTTPHeaders = [
			"x-auth": token
		]
		
		Alamofire.request(shelvesURL, method: .get, headers: headers).responseJSON { (response) in
			User.currentUser.shelves = self.parseShelves(JSON(response.result.value!)["shelves"])
			self.performSegue(withIdentifier: "login", sender: self)
		}
	}
	
	func parseShelves(_ shelves : JSON) -> [Shelf] {
		var shelfArray = [Shelf]()
		
		for (_, shelfJSON) : (String, JSON) in shelves {
			shelfArray.append(Shelf(withName: shelfJSON["name"].stringValue, andColour: shelfJSON["colour"].stringValue))
		}
		
		return shelfArray
	}
	
}
