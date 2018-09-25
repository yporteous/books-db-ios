//
//  LoginViewController.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/21.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import UIKit
//import Alamofire
//import SwiftyJSON
import KeychainAccess

class LoginViewController: UIViewController {
	
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	let loginURL = "http://localhost:3000/users/login/"
	let userURL = "http://localhost:3000/users/me/"
	
	let keychain = Keychain(service: "com.younusporteous.library")
	
	//TODO: remove this after URLSession is working
	//var currentUser = User()
	
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
		
		let json = [
			"user" : [
				"username": username,
				"password": password
			]
		]
		
		guard let requestURL = URL(string: loginURL) else { return }
		var request = URLRequest(url: requestURL)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		do {
			request.httpBody = try JSONSerialization.data(withJSONObject: json)
		} catch {
			print("Could not encode: \(error)")
		}
		
		let task = URLSession.shared.dataTask(with: request) { (data, res, error) in
			guard let token = (res as? HTTPURLResponse)?.allHeaderFields["x-auth"] as? String else { return }
			self.keychain["token"] = token
			
			guard let receivedData = data else { return }
			
			print(String(data: receivedData, encoding: String.Encoding.utf8) ?? "Data could not be printed")
			
			do {
				let decoder = JSONDecoder()
				User.currentUser = try decoder.decode(User.self, from: receivedData)
				
				DispatchQueue.main.async {
					self.performSegue(withIdentifier: "login", sender: self)
				}
				
			} catch {
				print("Error: \(error)")
			}
		}
		task.resume()
	}
	
	func getUserData () {
		let token = keychain["token"]!
		
		guard let requestURL = URL(string: userURL) else { return }
		var request = URLRequest(url: requestURL)
		
		request.setValue(token, forHTTPHeaderField: "x-auth")
		
		
		let task = URLSession.shared.dataTask(with: request) { (data, res, error) in
			guard let receivedData = data else { return }
			do {
				let decoder = JSONDecoder()
				User.currentUser = try decoder.decode(User.self, from: receivedData)
				DispatchQueue.main.async {
					self.performSegue(withIdentifier: "login", sender: self)
				}
			} catch {
				print("Error: \(error)")
			}
		}
		task.resume()
		
	}
	
}
