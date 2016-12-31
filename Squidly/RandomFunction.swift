//
//  RandomFunction.swift
//  Squidly
//
//  Created by Connor Wybranowski on 12/30/16.
//  Copyright © 2016 com.Wybro. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat {
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max-min) + min
    }
    
    public static func clamp(min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
        if value > max {
            return max
        } else if value < min {
            return min
        } else {
            return value
        }
    }
}
