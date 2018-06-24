//
//  IntentHandler.swift
//  CryptoSiri
//
//  Created by Robert Alexander on 12/19/17.
//  Copyright © 2017 Robert Alexander. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension{}

extension IntentHandler: INCreateNoteIntentHandling{
    func handle(intent: INCreateNoteIntent, completion: @escaping (INCreateNoteIntentResponse) -> Void) {
        
        var mm = INCreateNoteIntentResponseCode(rawValue: 0)
        let w = NSUserActivity(activityType: "ok")
        var l = INCreateNoteIntentResponse(code: mm!, userActivity: w)
        completion(l)
    }
    
    
}

