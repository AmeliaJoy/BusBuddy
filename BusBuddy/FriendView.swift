//  FriendView.swift
//  BusBuddy
//
//  Created by Amelia Schroeder on 9/27/25.
//
import SwiftUI

// Sample models
struct Friend: Identifiable {
    let id = UUID()
    var firstName: String
    var lastName: String
    var profileImageName: String // now fun images like "dog", "mountain", etc.
    var bio: String
    var groups: [String]
    
    var fullName: String { "\(firstName) \(lastName)" }
}

// Sample data with fun profile images
let sampleFriends: [Friend] = [
    Friend(firstName: "Alice", lastName: "Johnson", profileImageName: "avatar1", bio: "Love volunteering!", groups: ["Book Club", "Neighborhood Watch"]),
    Friend(firstName: "Bob", lastName: "Smith", profileImageName: "avatar2", bio: "Runner and foodie.", groups: ["Charity Run", "Cycling Group"]),
    Friend(firstName: "John", lastName: "James", profileImageName: "avatar3", bio: "Community events enthusiast.", groups: ["Food Drive", "Farmers Market"])
]

struct FriendView: View {
    var friends: [Friend] = sampleFriends
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(friends) { friend in
                        VStack(alignment: .leading, spacing: 10) {
                            // Profile header
                            HStack(spacing: 15) {
                                Image(friend.profileImageName) // fun image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .shadow(radius: 3)
                                
                                VStack(alignment: .leading) {
                                    Text(friend.fullName)
                                        .font(.headline)
                                    Text(friend.bio)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                            }
                            
                            // Groups
                            if !friend.groups.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(friend.groups, id: \.self) { group in
                                            Text(group)
                                                .font(.caption)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Color.blue.opacity(0.2))
                                                .foregroundColor(.blue)
                                                .cornerRadius(12)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Friends")
        }
    }
}

// MARK: - Preview
struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView()
    }
}
