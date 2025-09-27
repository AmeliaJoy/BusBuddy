//
//  EventSpecification.swift
//  BusBuddy
//
//  Created by Amelia Schroeder on 9/27/25.
//

import Foundation
import SwiftUI
struct EventSpecification: Hashable, Codable
{
    var id: Int
    var title: String
    var time: Date
    var info: String
    var coordinates: Coordinates
    var meetupCoords: Coordinates
    var meetupTime: Date
    var imageName: String
    var image: Image {
        Image(imageName)
    }
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
    var rsvps: [User],
    creator: User,
        group: String
    
}
