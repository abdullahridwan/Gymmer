//
//  ContentView.swift
//  Gymmer
//
//  Created by Abdullah Ridwan on 2/29/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedDate: Date = Date()
    @State private var isModalPresented: Bool = false
    @State private var tasks: [Date] = [
        Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
        Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
        Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
    ]
    
    
    var body: some View {
        NavigationView {
            VStack {
                CalendarView(isModal: $isModalPresented, selectedDate: $selectedDate)
                Spacer()
            }
            .navigationTitle("Summary")
            .navigationBarItems(trailing: Button(action: {
                self.isModalPresented.toggle()
            }) {
                Image(systemName: "plus.circle")
            })
        }
        .sheet(isPresented: $isModalPresented) {
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
