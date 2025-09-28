//
//  GlobalDataTemp.swift
//  BusBuddy
//
//  Created by Amelia Schroeder on 9/27/25.
//

import Foundation
import Combine
class GlobalDataTemp
{
    static var currentUser = User(id: 0, firstName: "Amelia", lastName: "Schroeder", bio: "it's me", imageName:"myAvatar")
    static var events: [EventSpecification] = [
            EventSpecification(
                id: 1,
                title: "Bus Meetup at Downtown",
                time: Date(),
                info: "Join us for a scenic bus ride through the city.",
                coordinates: EventSpecification.Coordinates(latitude: 40.7128, longitude: -74.0060),
                meetupCoords: EventSpecification.Coordinates(latitude: 40.730610, longitude: -73.935242),
                meetupTime: Date(),
                imageName: "bus1",
                rsvps: [
                    User(id: 1, firstName: "Alice", lastName: "Smith", bio: "", imageName: "avatar1"),
                    User(id: 2, firstName: "Bob", lastName: "Johnson", bio: "", imageName: "avatar2"),
                    User(id: 3, firstName: "Claire", lastName: "Li", bio: "", imageName: "avatar3")
                ],
                creator: User(id: 3, firstName: "Claire", lastName: "Li", bio: "", imageName: "avatar3"),
                       group: "City Bus Club"
            ),
            EventSpecification(
                id: 2,
                title: "Little Tokyo Trip",
                time: Date(),
                info: "Explore the city lights after dark! (and maybe some ramen)",
                coordinates: EventSpecification.Coordinates(latitude: 40.730610, longitude: -73.935242),
                meetupCoords: EventSpecification.Coordinates(latitude: 40.741895, longitude: -73.989308),
                meetupTime: Date(),
                imageName: "bus2",
                rsvps: [],
                creator: User(id: 3, firstName: "Claire", lastName: "Li", bio: "", imageName: "avatar3"),
                       group: "City Bus Club"
            )
        ]
}
