//
//  Item.swift
//  BusBuddy
//
//  Created by Amelia Schroeder on 9/27/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
