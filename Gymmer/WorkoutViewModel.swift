//
//  WorkoutViewModel.swift
//  Gymmer
//
//  Created by Abdullah Ridwan on 3/1/24.
//

import Foundation
import CoreData

class WorkoutViewModel: ObservableObject {
    @Published var workouts: [WorkoutType]
    @Published var newWorkout: String = ""
    @Published var showAlert: Bool = false

    init(workouts: [WorkoutType] = []) {
        self.workouts = workouts
    }
    
    
    func createWorkoutTypeInCoreData() {
        //split up newWorkout into emoji and name
        let emojiString = newWorkout.prefix(1)
        let wname = newWorkout.dropFirst()
        
        //make a core data instance of the new workout
        let wt = WorkoutType(context: CoreDataManager.shared.viewContext)
        wt.emoji = String(emojiString)
        wt.name = String(wname)
        
        //save
        CoreDataManager.shared.save()
    }
    
    func getAllWorkoutTypesFromCoreData(){
        self.workouts = CoreDataManager.shared.getWorkoutTypes()
    }

    func addWorkout() {
        // Conditions
        let hasText = !newWorkout.isEmpty // Not empty
        let hasEmoji = hasEmojiInFront(s: newWorkout) // Has an emoji in the front

        // If it doesn't have the emoji, there should be an alert
        if !hasEmoji {
            showAlert = true
        }

        // If conditions are met
        if hasText && hasEmoji {
            createWorkoutTypeInCoreData()
            getAllWorkoutTypesFromCoreData()
            newWorkout = ""
        }
    }

    private func hasEmojiInFront(s: String) -> Bool {
        for scalar in s.unicodeScalars {
            let isEmoji = scalar.properties.isEmoji
            if isEmoji {
                return true
            }
            break
        }
        return false
    }

    func deleteWorkout(at offsets: IndexSet) {
        for index in offsets {
            let workout = workouts[index]
            print(workout)
            CoreDataManager.shared.delete(item: workout)
        }
    }
}
