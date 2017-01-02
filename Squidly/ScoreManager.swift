//
//  ScoreManager.swift
//  Squidly
//
//  Created by Connor Wybranowski on 12/31/16.
//  Copyright © 2016 com.Wybro. All rights reserved.
//

import UIKit

class ScoreManager: NSObject {
    
    class func save(score: Int) {
        let defaults = UserDefaults.standard
        
        if let currentScore = defaults.value(forKey: "userScore") as? Int {
            if score > currentScore {
                defaults.setValue(score, forKeyPath: "userScore")
                defaults.synchronize()
                return
            }
        } else {
            // First time saving score
            defaults.setValue(score, forKeyPath: "userScore")
            defaults.synchronize()
        }
    }
    
    class func loadScore() -> Int {
        let defaults = UserDefaults.standard
        
        if let score = defaults.value(forKey: "userScore") as? Int {
            return score
        }
        return 0
    }

}
