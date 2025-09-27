//
//  User.swift
//  BusBuddy
//
//  Created by Amelia Schroeder on 9/27/25.
//


import Foundation
import SwiftUI
struct User: Hashable, Codable
{
    var id: Int
    var firstName: String
    var lastName: String
    var fullName: String {
        return firstName + " " + lastName
    }
    var bio: String
    var imageName: String
    var image: Image {
        Image(imageName)
    }
}
