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
                title: "Bus Meetup at Downtown",
                time: Date(),
                info: "Join us for a scenic bus ride through the city.",
                location: "St. John's",
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
                title: "City Night Bus Tour",
                time: Date(),
                info: "Explore the city lights after dark!",
                location: "city",
                imageName: "bus2",
                rsvps: [],
                creator: User(id: 3, firstName: "Claire", lastName: "Li", bio: "", imageName: "avatar3"),
                       group: "City Bus Club"
            )
        ]
}
