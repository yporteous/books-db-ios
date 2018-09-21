//
//  LoginViewController.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/21.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import UIKit
import Alamofire
//import SwiftyJSON

class LoginViewController: UIViewController {
	
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	let loginURL = "http://localhost:3000/users/login"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
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
			if let token = response.response?.allHeaderFields["x-auth"] {
				
				
				// /*
				let tag = "com.younusporteous.Library.token".data(using: .utf8)!
				let addQuery : [String: Any] = [
					kSecClass as String: kSecClassKey,
					kSecAttrApplicationTag as String: tag,
					kSecValueRef as String: token
				]
				
				SecItemAdd(addQuery as CFDictionary, nil)
				// */
			}
		}
		
		
		
//		performSegue(withIdentifier: "login", sender: self)
	}
	
	
}
