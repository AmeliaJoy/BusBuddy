//
//  ContentView.swift
//  BusBuddy
//
//  Created by Amelia Schroeder on 9/27/25.
//

import SwiftUI
import SwiftData

// Updated model to hold start + end times



struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var showingAddEvent = false

    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Feed")
                }
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            FriendView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Friends")
                }
            AddView()
                .tabItem{
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                    Text("Add")
                }

        
        }
        .sheet(isPresented: $showingAddEvent) {
            AddEventView()
        }
    }

    private func deleteEvents(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                GlobalDataTemp.events.remove(at: index)
            }
        }
    }
}



#Preview {
    ContentView()
}
