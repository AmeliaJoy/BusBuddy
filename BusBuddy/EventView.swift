//
//  EventView.swift
//  BusBuddy
//
//  Created by Amelia Schroeder on 9/27/25.
//

import SwiftUI

struct EventView: View {
    @State private var rsvped = false
    @State private var rsvps: [User]
    var eventNum: Int

    init(eventNum: Int) {
        self.eventNum = eventNum
            _rsvps = State(initialValue: GlobalDataTemp.events[eventNum].rsvps)
        _rsvped = State(initialValue: GlobalDataTemp.events[eventNum].rsvps.contains { $0.id == GlobalDataTemp.currentUser.id })
        }
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Event Image
            GlobalDataTemp.events[eventNum].image
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()
                .cornerRadius(15)
            HStack(spacing: 10) {
                // Creator avatar
                GlobalDataTemp.events[eventNum].creator.image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(GlobalDataTemp.events[eventNum].creator.fullName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(GlobalDataTemp.events[eventNum].group)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding(.bottom, 5)
            // Event title and time
            HStack {
                Text(GlobalDataTemp.events[eventNum].title).font(.headline)
                Spacer()
                Text(GlobalDataTemp.events[eventNum].time, style: .time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            // Event info
            Text(GlobalDataTemp.events[eventNum].info)
                .font(.subheadline)
                .foregroundColor(.secondary)

            // Meetup info
            HStack {
                Image(systemName: "mappin.and.ellipse")
                Text("Meetup at \(GlobalDataTemp.events[eventNum].meetupTime, style: .time)")
                    .font(.caption)
            }
            .foregroundColor(.gray)

            // RSVPs
            
                    HStack(spacing: -10) {
                        if !GlobalDataTemp.events[eventNum].rsvps.isEmpty {
                            ForEach(GlobalDataTemp.events[eventNum].rsvps.prefix(3), id: \.id) { user in
                                user.image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                            }
                            Text("\(GlobalDataTemp.events[eventNum].rsvps[0].fullName) \(GlobalDataTemp.events[eventNum].rsvps.count >= 2 ? "and \(GlobalDataTemp.events[eventNum].rsvps.count-1) more":"")").padding(.leading, 25).font(.caption)
                            .foregroundColor(.gray)}
                            Spacer()
                        Button(action:toggleRSVP){
                            Text(rsvped ? "RSVPed" : "RSVP")
                        }.buttonStyle(.glassProminent).buttonBorderShape(.roundedRectangle).tint(rsvped ? Color(red:163/255,green:53/255, blue:32/255) : Color(red:255/255,green:198/255, blue:41/255)).foregroundColor(rsvped ? Color(red:255/255,green:198/255, blue:41/255) : Color(red:163/255,green:53/255, blue:32/255))
                    }
                
                .padding(.top, 5)
            
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.95))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    private func toggleRSVP()
    {
        if rsvped {
            GlobalDataTemp.events[eventNum].rsvps.removeAll {
                $0.id == GlobalDataTemp.currentUser.id }
                }
        else {
            GlobalDataTemp.events[eventNum].rsvps.append(GlobalDataTemp.currentUser)
        }
        rsvped.toggle()
    }
}
#Preview {
    EventView(eventNum:1)
}
