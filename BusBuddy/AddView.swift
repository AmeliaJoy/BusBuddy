//
//  AddView.swift
//  BusBuddy
//
//  Created by Claire Li on 9/27/25.
//
import SwiftUI
import SwiftData
import MapKit

// Helper struct for map annotation
struct MapPinItem: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct AddView: View {
    //@Environment(\.modelContext) private var modelContext
    @State private var showingAddForm = false
    let events = GlobalDataTemp.events.filter { $0.creator.id == GlobalDataTemp.currentUser.id }
    
    
    var body: some View {
        NavigationStack {
            List {
                if events.isEmpty {
                    Text("No events yet. Tap 'Add Event' to create one!")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(events) { event in
                        let index = events.firstIndex(where: { $0.id == event.id })
                        EventView(eventNum: index ?? 0)
                            /**NavigationLink(destination: AddEventForm(showingAddForm: .constant(true), eventToEdit: event)
                                        .environment(\.modelContext, modelContext)) {
                            VStack(alignment: .leading) {
                                Text(event.title).font(.headline)
                                Text("\(event.startTime.formatted(date: .omitted, time: .shortened)) - \(event.endTime.formatted(date: .omitted, time: .shortened))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                if let location = event.locationName {
                                    Text("Location: \(location)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 5)
                        }**/
                    }
                    .onDelete(perform: deleteEvents)
                }
            }
            .navigationTitle("My Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddForm = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Event")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddForm) {
                AddEventForm(showingAddForm: $showingAddForm)
            }
        }
    }
    
    private func deleteEvents(offsets: IndexSet) {
        for index in offsets {
        }
    }
}
#Preview {
    AddView()
}
