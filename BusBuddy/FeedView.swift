//
//  FeedView.swift
//  BusBuddy
//
//  Created by Amelia Schroeder on 9/27/25.
//

import SwiftUI

struct FeedView: View {
    @State private var isSearching = false
    @State private var searchText = ""
    var body: some View {
        NavigationView{
            Text("Welcome to your feed!")
                .toolbar  {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        if isSearching {
                            TextField("Search Events", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .frame(width: 200)
                        } else {
                            Button(action: { isSearching = true }) {
                                Image(systemName: "magnifyingglass")
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                                            if isSearching {
                                                Button(action:{
                                                    isSearching = false
                                                    searchText = ""
                                                })
                                                {
                                                    Image(systemName: "xmark")
                                                }
                                            }
                                        }
                }
        }
            
        
    }
    private func searchEvents(){
        
    }
}
#Preview {
    FeedView()
}
