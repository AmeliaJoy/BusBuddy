//
//  ContentView.swift
//  BusBuddy
//
//  Created by Amelia Schroeder on 9/27/25.
//

import SwiftUI
import SwiftData

// Updated model to hold start + end times
@Model
class Event {
    var id: UUID
    var title: String
    var startTime: Date
    var endTime: Date
    var locationName: String? // human-readable address

    init(title: String, startTime: Date, endTime: Date) {
        self.id = UUID()
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
    }
}


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var events: [Event]
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
                modelContext.delete(events[index])
            }
        }
    }
}

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title: String = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(3600)

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Title", text: $title)
                    DatePicker("Start Time", selection: $startTime)
                    DatePicker("End Time", selection: $endTime)
                }
            }
            .navigationTitle("New Event")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newEvent = Event(
                            title: title,
                            startTime: startTime,
                            endTime: endTime
                        )
                        modelContext.insert(newEvent)
                        dismiss()
                    }
                    .disabled(title.isEmpty || endTime <= startTime)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Event.self, inMemory: true)
}
