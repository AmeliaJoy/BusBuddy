//
//  CalendarView.swift
//  BusBuddy
//
//  Created by Amelia Schroeder on 9/27/25.
//
//
//  CalendarView.swift
//  BusBuddy
//
//  Created by Amelia Schroeder on 9/27/25.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var events: [Event]
    
    @State private var currentMonth = Date() // Tracks which month we’re viewing
    @State private var selectedDate: Date? = nil
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private var currentMonthDays: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else { return [] }
        var days: [Date] = []
        var date = monthInterval.start
        
        // Add empty slots for alignment
        let firstWeekday = calendar.component(.weekday, from: date) - 1
        for _ in 0..<firstWeekday { days.append(Date.distantPast) }
        
        while date < monthInterval.end {
            days.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        return days
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Month header with navigation
                HStack {
                    Button(action: { changeMonth(by: -1) }) {
                        Image(systemName: "chevron.left")
                    }
                    Spacer()
                    Text(monthTitle)
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button(action: { changeMonth(by: 1) }) {
                        Image(systemName: "chevron.right")
                    }
                }
                .padding(.horizontal)
                
                // Days of week header
                HStack {
                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                // Calendar grid
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(currentMonthDays, id: \.self) { date in
                        if calendar.isDate(date, equalTo: Date.distantPast, toGranularity: .day) {
                            Color.clear.frame(height: 40) // Empty slot
                        } else {
                            VStack(spacing: 4) {
                                Text("\(calendar.component(.day, from: date))")
                                    .font(.body)
                                    .frame(maxWidth: .infinity)
                                    .padding(6)
                                    .background(isToday(date) ? Color.blue.opacity(0.3) : Color.clear)
                                    .clipShape(Circle())
                                
                                if !eventsFor(date: date).isEmpty {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 6, height: 6)
                                }
                            }
                            .frame(height: 50)
                            .onTapGesture {
                                selectedDate = date
                            }
                        }
                    }
                }
                .padding(.vertical)
                
                Spacer()
            }
            .navigationTitle("Calendar")
            .sheet(
                isPresented: Binding(
                    get: { selectedDate != nil },
                    set: { if !$0 { selectedDate = nil } }
                )
            ) {
                if let date = selectedDate {
                    DayEventsView(date: date, events: eventsFor(date: date))
                }
            }
        }
    }
    
    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    private func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
    
    private func eventsFor(date: Date) -> [Event] {
        events.filter {
            calendar.isDate($0.startTime, inSameDayAs: date)
        }
    }
}

struct DayEventsView: View {
    var date: Date
    var events: [Event]
    
    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .full
        return f
    }()
    
    var body: some View {
        NavigationStack {
            List {
                if events.isEmpty {
                    Text("No events for this day")
                        .foregroundColor(.gray)
                } else {
                    ForEach(events) { event in
                        VStack(alignment: .leading) {
                            Text(event.title)
                                .font(.headline)
                            Text("\(event.startTime.formatted(date: .omitted, time: .shortened)) - \(event.endTime.formatted(date: .omitted, time: .shortened))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            if let loc = event.locationName {
                                Text("📍 \(loc)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle(formatter.string(from: date))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CalendarView()
        .modelContainer(for: Event.self, inMemory: true)
}
