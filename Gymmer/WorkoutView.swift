//
//  SettingsView.swift
//  Gymmer
//
//  Created by Abdullah Ridwan on 3/1/24.
//

import SwiftUI

struct WorkoutView: View {
    @ObservedObject var viewModel: WorkoutViewModel = WorkoutViewModel()
    
    var body: some View {
        VStack{
            Form {
                Section(header: Text("Put in your workouts")) {
                    List {
                        ForEach(viewModel.workouts, id: \.self) { workout in
                            Text("\(workout.emoji ?? "🥲") \(workout.name ?? "None")")
                        }
                        .onDelete(perform: viewModel.deleteWorkout)
                    }
                    HStack {
                        TextField("👟 Running", text: $viewModel.newWorkout)

                        Button(action: viewModel.addWorkout) {
                            Image(systemName: "plus.circle")
                        }
                        .alert(isPresented: $viewModel.showAlert) {
                            Alert(title: Text("👋 Hey, wait up!"), message: Text("Use an Emoji at the Beginning of your Workout"), dismissButton: .default(Text("Got it!")))
                        }
                    }
                }
            }
        }
        .navigationTitle("Workout Form")
        .onAppear(perform: {
            viewModel.getAllWorkoutTypesFromCoreData()
        })
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}

