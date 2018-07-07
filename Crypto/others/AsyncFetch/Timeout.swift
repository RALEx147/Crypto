//
//  Timeout.swift
//  Crypto
//
//  Created by Robert Alexander on 7/6/18.
//  Copyright © 2018 Robert Alexander. All rights reserved.
//

import Foundation

enum MyError: Error {
	case runtimeError(String)
}

func someFunction(_ message:String ) throws {
	throw MyError.runtimeError(message)
}
