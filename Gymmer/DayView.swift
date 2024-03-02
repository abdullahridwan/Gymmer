import Foundation
import SwiftUI

struct WorkoutForm: View {
    @ObservedObject var dvm: DayViewModel

    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("What did you workout today?")) {
                    Picker("Workout", selection: $dvm.selectedWorkout) {
                        ForEach(dvm.workouts, id: \.self) { workout in
                            Text("\(workout.emoji ?? "🥲") \(workout.name ?? "None")")
                                .tag(workout)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Comments")) {
                    TextEditor(text: $dvm.comments)
                        .frame(height: 100)
                        .padding(.vertical, 8)
                        .cornerRadius(8)
                }
            }
            .navigationTitle(dvm.getDateString()[0])
            .onAppear {
                dvm.getAllWorkoutTypesFromCoreData()
            }
            .onDisappear {
                dvm.saveWorkoutSummary()
            }
        }
    }
}

struct WorkoutForm_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutForm(dvm: DayViewModel())
    }
}
