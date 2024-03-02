//
//  ContentView.swift
//  Gymmer
//
//  Created by Abdullah Ridwan on 2/29/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var selectedDate: Date = Date()
    @State private var isModalPresented: Bool = false
    @State private var workouts: [WorkoutType] = []
    
    @StateObject var dvm = DayViewModel()
    
    
    func workoutTypeExists(emoji: String, name: String) -> Bool {
        let fetchRequest: NSFetchRequest<WorkoutType> = WorkoutType.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "emoji == %@ AND name == %@", emoji, name)
        
        do {
            let count = try CoreDataManager.shared.viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error counting objects: \(error.localizedDescription)")
            return false
        }
    }
    
    func getWorkoutTypeFromCoreData() -> WorkoutType? {
        let fetchRequest: NSFetchRequest<WorkoutType> = WorkoutType.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "emoji == %@ AND name == %@",  "🏅", "Starting Strong!")

        do {
            let results = try CoreDataManager.shared.viewContext.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching workout type: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                CalendarView(isModal: $isModalPresented, selectedDate: $selectedDate)
                Spacer()
            }
            .navigationTitle("Summary")
            .navigationBarItems(trailing:
                NavigationLink(destination: WorkoutView()) {
                Image(systemName: "plus")
                
                }
           )
        }
//        .onAppear(perform: {
//            if !workoutTypeExists(emoji: "🏅", name: "Starting Strong!") {
//                let wt = WorkoutType(context: CoreDataManager.shared.viewContext)
//                wt.emoji = "🏅"
//                wt.name = "Starting Strong!"
//
//                CoreDataManager.shared.save()
//            }
//        })
        .sheet(isPresented: $isModalPresented) {
            WorkoutForm(dvm: dvm)
                .onAppear(perform: {
                    dvm.selectedDate = selectedDate
//                    dvm.selectedWorkout = getWorkoutTypeFromCoreData()!
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
