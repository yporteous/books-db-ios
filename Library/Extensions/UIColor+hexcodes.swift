//
//  UIColor+hexcodes.swift
//  Library
//
//  Created by Younus Porteous on 2018/09/21.
//  Copyright © 2018 Younus Porteous. All rights reserved.
//

import UIKit

extension UIColor {
	convenience init(hex: String) {
		let scanner = Scanner(string: hex)
		scanner.scanLocation = 0
		
		var rgbValue: UInt64 = 0
		
		scanner.scanHexInt64(&rgbValue)
		
		let r = (rgbValue & 0xff0000) >> 16
		let g = (rgbValue & 0xff00) >> 8
		let b = rgbValue & 0xff
		
		self.init(
			red: CGFloat(r) / 0xff,
			green: CGFloat(g) / 0xff,
			blue: CGFloat(b) / 0xff,
			alpha: 1
		)
	}
	
	convenience init(hex3: String) {
		var hex = hex3
		hex.remove(at: hex.startIndex)
		let scanner = Scanner(string: hex)
		scanner.scanLocation = 0
		
		var rgbValue: UInt64 = 0
		
		scanner.scanHexInt64(&rgbValue)
		
		let r = (rgbValue & 0xf00) >> 8
		let g = (rgbValue & 0xf0) >> 4
		let b = rgbValue & 0xf
		
		self.init(
			red: CGFloat(r) / 0xf,
			green: CGFloat(g) / 0xf,
			blue: CGFloat(b) / 0xf,
			alpha: 1
		)
	}
}
