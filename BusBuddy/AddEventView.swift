//
//  AddEventView.swift
//  BusBuddy
//
//  Created by Claire Li on 9/27/25.
//
import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title: String = ""
    @State private var info: String = ""
    @State private var group: String = ""
    @State private var startTime: Date = Date().addingTimeInterval(3600)
    @State private var meetupTime: Date = Date()
    @State private var hasDate: Bool = false
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Title", text: $title)
                    TextField("Group", text: $group)
                    DatePicker("Event Start Time", selection: $startTime)
                    Toggle("Meet up beforehand?", isOn: $hasDate)
                    if(hasDate){
                        DatePicker("Meetup Time", selection: $meetupTime)
                        TextField("Additional Info", text: $info)}
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
                        let newEvent = EventSpecification(
                            title: title,
                            time: startTime,
                            info: info,
                            location: "",
                            meetupLocation: "",
                            meetupTime: meetupTime,
                            imageName: "blank",
                             rsvps: [],
                            creator: GlobalDataTemp.currentUser,
                                group: group
                            
                        )
                        dismiss()
                    }
                    .disabled(title.isEmpty || meetupTime <= startTime)
                }
            }
        }
    }
}
#Preview {
    AddEventView()
}
