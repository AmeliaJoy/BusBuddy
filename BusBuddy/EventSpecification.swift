//
//  EventSpecification.swift
//  BusBuddy
//
//  Created by Amelia Schroeder on 9/27/25.
//

import Foundation
import SwiftUI
struct EventSpecification: Hashable, Codable, Identifiable
{
    var id: UUID = UUID()
    var title: String
    var time: Date
    var info: String
    var location: String
    var meetupLocation: String?
    var meetupTime: Date?
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
