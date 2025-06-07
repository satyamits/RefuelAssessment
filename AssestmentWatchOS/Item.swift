//
//  Item.swift
//  AssestmentWatchOS
//
//  Created by Satyam Singh on 07/06/25.
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
