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
    @Environment(\.modelContext) private var modelContext
    @Query private var events: [Event]
    
    @State private var showingAddForm = false
    
    
    
    var body: some View {
        NavigationStack {
            List {
                if events.isEmpty {
                    Text("No events yet. Tap 'Add Event' to create one!")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(events) { event in
                        NavigationLink(destination: AddEventForm(showingAddForm: .constant(true), eventToEdit: event)
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
                        }
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
                    .environment(\.modelContext, modelContext)
            }
        }
    }
    
    private func deleteEvents(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(events[index])
        }
    }
}

// Add/Edit Event Form with draggable pin
struct AddEventForm: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var showingAddForm: Bool
    
    var eventToEdit: Event? = nil
    
    @State private var title: String = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(3600)
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var pin = MapPinItem(coordinate: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437))
    @State private var locationName: String = "Tap or drag the pin to select location"
    
    let geocoder = CLGeocoder()
    
    init(showingAddForm: Binding<Bool>, eventToEdit: Event? = nil) {
        self._showingAddForm = showingAddForm
        self.eventToEdit = eventToEdit
        
        if let event = eventToEdit {
            _title = State(initialValue: event.title)
            _startTime = State(initialValue: event.startTime)
            _endTime = State(initialValue: event.endTime)
            if let locName = event.locationName {
                _locationName = State(initialValue: locName)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Title", text: $title)
                    DatePicker("Start Time", selection: $startTime)
                    DatePicker("End Time", selection: $endTime)
                }
                
                Section(header: Text("Location")) {
                    Map(coordinateRegion: $region, interactionModes: .all, annotationItems: [pin]) { item in
                        MapAnnotation(coordinate: item.coordinate) {
                            Image(systemName: "mappin.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            let mapPoint = value.location
                                            let coordinate = convertPointToCoordinate(point: mapPoint, region: region, size: UIScreen.main.bounds.size)
                                            pin.coordinate = coordinate
                                            reverseGeocode(coordinate: coordinate)
                                        }
                                )
                        }
                    }
                    .frame(height: 250)
                    .cornerRadius(10)
                    .onTapGesture {
                        pin.coordinate = region.center
                        reverseGeocode(coordinate: pin.coordinate)
                    }
                    
                    Text(locationName)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Section {
                    Button(eventToEdit != nil ? "Save Changes" : "Save Event") {
                        saveEvent()
                    }
                    .disabled(title.isEmpty || endTime <= startTime || locationName.isEmpty)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(title.isEmpty || endTime <= startTime ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .navigationTitle(eventToEdit != nil ? "Edit Event" : "Add Event")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showingAddForm = false }
                }
            }
        }
    }
    
    private func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { places, _ in
            if let place = places?.first {
                var name = ""
                if let street = place.thoroughfare { name += street }
                if let city = place.locality { name += name.isEmpty ? city : ", \(city)" }
                if let state = place.administrativeArea { name += name.isEmpty ? state : ", \(state)" }
                locationName = name.isEmpty ? "Selected location" : name
            } else {
                locationName = "Selected location"
            }
        }
    }
    
    private func saveEvent() {
        if let event = eventToEdit {
            event.title = title
            event.startTime = startTime
            event.endTime = endTime
            event.locationName = locationName
        } else {
            let newEvent = Event(title: title, startTime: startTime, endTime: endTime)
            newEvent.locationName = locationName
            modelContext.insert(newEvent)
        }
        showingAddForm = false
    }
    
    // Convert drag point to map coordinate
    private func convertPointToCoordinate(point: CGPoint, region: MKCoordinateRegion, size: CGSize) -> CLLocationCoordinate2D {
        let span = region.span
        let center = region.center
        let latitudeDeltaPerPoint = span.latitudeDelta / Double(size.height)
        let longitudeDeltaPerPoint = span.longitudeDelta / Double(size.width)
        
        let lat = center.latitude - span.latitudeDelta / 2 + Double(point.y) * latitudeDeltaPerPoint
        let lon = center.longitude - span.longitudeDelta / 2 + Double(point.x) * longitudeDeltaPerPoint
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
