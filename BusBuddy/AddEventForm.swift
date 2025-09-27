//
//  AddEventForm.swift
//  BusBuddy
//
//  Created by Claire Li  on 9/27/25.
//

import SwiftUI
import MapKit
// Add/Edit Event Form with draggable pin
struct AddEventForm: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var showingAddForm: Bool
    
    var eventToEdit: EventSpecification? = nil
    
    @State private var title: String = ""
   @State private var time: Date = Date()
    @State private var info: String = ""
    @State private var location: String = ""
    @State private var meetupLocation: String? = nil
    @State private var meetupTime: Date? = nil
    @State private var imageName: String = ""
    @State private var rsvps : [User] = []
    @State private var creator: User = GlobalDataTemp.currentUser
    @State private var group: String = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var pin = MapPinItem(coordinate: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437))
    @State private var locationName: String = "Tap or drag the pin to select location"
    
    let geocoder = CLGeocoder()
    
    init(showingAddForm: Binding<Bool>, eventToEdit: EventSpecification? = nil) {
        self._showingAddForm = showingAddForm
        self.eventToEdit = eventToEdit
        
        if let event = eventToEdit {
            let _title = event.title
            let _time = event.time
            let _info = event.info
            let _location = event.location
            let _meetupLocation = event.meetupLocation
            let _meetupTime = event.meetupTime
            let _imageName = event.imageName
            let rsvps = event.rsvps
            let creator = event.creator
            let group = event.group
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Title", text: $title)
                    DatePicker("Start Time", selection: $time)
                    DatePicker("Meetup Time", selection: Binding(
                        get: { meetupTime ?? time },   // fallback if nil
                        set: { newValue in meetupTime = newValue }
                    ))                }
                
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
                    .disabled(title.isEmpty || locationName.isEmpty)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(title.isEmpty ? Color.gray : Color.blue)
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
        if var event = eventToEdit {
            event.title = title
            event.time = time
            event.info = info
            event.location = location
            event.meetupLocation = meetupLocation
            event.meetupTime = meetupTime
            event.imageName = imageName
            event.rsvps = rsvps
            event.creator = creator
            } else {
                let newEvent = EventSpecification(title: title,
                                                  time: time,
                                                  info: info,
                                                  location: location,
                                                  meetupLocation: meetupLocation,
                                                  meetupTime: meetupTime,
                                                  imageName: imageName,
                                                  rsvps: rsvps,
                                                  creator: creator,
                                                  group:group
                                                    )
            GlobalDataTemp.events.append(newEvent)
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

