//
//  FeedView.swift
//  BusBuddy
//
//  Created by Amelia Schroeder on 9/27/25.
//
import SwiftUI

struct FeedView: View {
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    
    // Example data
    let categories = [
        ("Tech", "gearshape"),
        ("Food & Drink", "fork.knife"),
        ("Arts & Culture", "paintpalette"),
        ("Sports", "sportscourt")
    ]
    
    let events = [
        EventCard(title: "Hackathon 2025", club: "Coding Club", price: "Free", image: "laptopcomputer"),
        EventCard(title: "Open Mic Night", club: "Poetry Society", price: "Free", image: "mic"),
        EventCard(title: "Basketball Tournament", club: "Rec Center", price: "$5", image: "sportscourt"),
        EventCard(title: "Cultural Food Fest", club: "International Club", price: "$10", image: "fork.knife")
    ]
    
    var filteredEvents: [EventCard] {
        if searchText.isEmpty { return events }
        return events.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Quick filters row
                    HStack(spacing: 12) {
                        FilterButton(icon: "heart", label: "Favorites")
                        FilterButton(icon: "clock.arrow.circlepath", label: "History")
                        FilterButton(icon: "person.2", label: "Following")
                        FilterButton(icon: "map", label: "Nearby")
                    }
                    .padding(.horizontal)
                    
                    // Banner carousel
                    TabView {
                        BannerView(title: "Welcome Week", imageName: "party.popper")
                        BannerView(title: "Clubs Fair", imageName: "person.3.sequence")
                    }
                    .frame(height: 160)
                    .tabViewStyle(PageTabViewStyle())
                    
                    // Categories
                    HStack {
                        Text("Categories")
                            .font(.headline)
                        Spacer()
                        Button("See all") {}
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(categories, id: \.0) { cat in
                                VStack {
                                    Circle()
                                        .fill(Color(.systemGray5))
                                        .frame(width: 60, height: 60)
                                        .overlay(Image(systemName: cat.1).font(.title2))
                                    Text(cat.0)
                                        .font(.caption)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Popular Events
                    HStack {
                        Text("Popular Events")
                            .font(.headline)
                        Spacer()
                        Button("See all") {}
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(filteredEvents) { event in
                            EventCardView(event: event)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Campus Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        if isSearching {
                            TextField("Search Events", text: $searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 200)
                            
                            Button(action: {
                                isSearching = false
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                            }
                        } else {
                            Button(action: { isSearching = true }) {
                                Image(systemName: "magnifyingglass")
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct FilterButton: View {
    var icon: String
    var label: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title3)
                .padding(10)
                .background(Color(.systemGray6))
                .clipShape(Circle())
            Text(label)
                .font(.caption)
        }
    }
}

struct BannerView: View {
    var title: String
    var imageName: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.15))
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.headline)
                    Text("Don’t miss it!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: imageName)
                    .font(.largeTitle)
            }
            .padding()
        }
        .padding(.horizontal)
    }
}

struct EventCard: Identifiable {
    let id = UUID()
    var title: String
    var club: String
    var price: String
    var image: String
}

struct EventCardView: View {
    var event: EventCard
    
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray5))
                .frame(height: 120)
                .overlay(Image(systemName: event.image).font(.largeTitle))
            
            Text(event.club)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(event.title)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Text(event.price)
                .font(.caption)
                .foregroundColor(.blue)
        }
    }
}
