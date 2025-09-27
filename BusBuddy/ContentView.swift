//
//  ContentView.swift
//  BusBuddy
//
//  Created by Amelia Schroeder on 9/27/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var showingAddEvent = false

    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Image(systemName: "house.fill")
                }
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                }
            FriendView()
                .tabItem {
                    Image(systemName: "person.fill")
                }
            Button(action: { showingAddEvent = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                        }
                        .tabItem {
                            Image(systemName: "plus.circle")
                            Text("Add")
                        }
            
        }
        /**NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            /**.toolbar  {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action:openFeed){
                        Label("Open Feed", systemImage: "magnifyingglass")
                    }
                }
                ToolbarItemGroup(placement:.bottomBar){
                        NavigationLink(destination:FeedView()){
                            Image(systemName: "house")
                        }
                        Button(action:openFeed){
                            Label("Open Feed", systemImage: "house.fill")
                        }
                        Button(action: calendarView) {
                            Label("Open calendar View", systemImage: "calendar")
                        }
                        Button(action: friendView) {
                            Label("Open Friend View", systemImage: "person.fill")
                        }
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                        
                        
                }
            }**/
        } detail: {
            Text("Select an item")
        }**/
    }
    private func openFeed(){
        
    }
    private func friendView(){}
    private func calendarView(){}
    private func addItem() {
        /**withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }**/
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
