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
	
	let defaults = UserDefaults.standard
		
	var loginURL = ""
	var userURL = ""
	var bookURL = ""
	
	var token = ""
	
	let keychain = Keychain(service: "com.younusporteous.library")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//set urls
		loginURL = defaults.string(forKey: "baseURL")! + "/users/login/"
		userURL = defaults.string(forKey: "baseURL")! + "/users/me/"
		bookURL = defaults.string(forKey: "baseURL")! + "/books/"
		
		// test for token
		if keychain["token"] != nil {
			token = keychain["token"]!
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
		print("Requesting from ", requestURL)
		
		var request = URLRequest(url: requestURL)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		do {
			request.httpBody = try JSONSerialization.data(withJSONObject: json)
		} catch {
			print("Could not encode: \(error)")
		}
		
		let task = URLSession.shared.dataTask(with: request) { (data, res, error) in
			guard let token = (res as? HTTPURLResponse)?.allHeaderFields["X-Auth"] as? String else {
				print("Did not receive token")
				return
			}
			self.keychain["token"] = token
			self.token = token
			
			guard let receivedData = data else { return }
			
			print(String(data: receivedData, encoding: String.Encoding.utf8) ?? "Data could not be printed")
			
			do {
				User.currentUser = try JSONDecoder().decode(User.self, from: receivedData)
				
				DispatchQueue.main.async {
					//self.performSegue(withIdentifier: "login", sender: self)
					self.getUserBooks()
				}
				
			} catch {
				print("Error: \(error)")
			}
		}
		task.resume()
	}
	
	func getUserData () {
		guard let requestURL = URL(string: userURL) else { return }
		var request = URLRequest(url: requestURL)
		
		request.setValue(token, forHTTPHeaderField: "x-auth")
		
		let task = URLSession.shared.dataTask(with: request) { (data, res, error) in
			guard let receivedData = data else { return }
			
			do {
				User.currentUser = try JSONDecoder().decode(User.self, from: receivedData)
				DispatchQueue.main.async {
					//self.performSegue(withIdentifier: "login", sender: self)
					self.getUserBooks()
				}
			} catch {
				print("Error: \(error)")
			}
		}
		task.resume()
		
	}
	
	func getUserBooks () {
		guard let requestURL = URL(string: bookURL) else { return }
		var request = URLRequest(url: requestURL)
		
		request.setValue(token, forHTTPHeaderField: "x-auth")
		
		let task = URLSession.shared.dataTask(with: request) { (data, res, error) in
			guard let receivedData = data else { return }
			do {
				User.currentUser.books = (try JSONDecoder().decode(BooksRes.self, from: receivedData)).books
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
