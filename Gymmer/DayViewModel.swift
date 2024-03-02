import Foundation
import CoreData

class DayViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var selectedWorkout: WorkoutType? = nil
    @Published var comments: String = ""
    @Published var workouts: [WorkoutType] = []
    
    func getDateString() -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"

        let df2 = DateFormatter()
        df2.dateFormat = "EEEE"

        let monthString = dateFormatter.string(from: selectedDate)
        let dayString = df2.string(from: selectedDate)

        return [monthString, dayString]
    }
    
    func getAllWorkoutTypesFromCoreData() {
        self.workouts = CoreDataManager.shared.getWorkoutTypes()
    }
    
    func getDateKey() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: self.selectedDate)
    }
    
    func checkIfObjectsExist() -> Bool {
        let fetchRequest: NSFetchRequest<WorkoutDaySummary> = WorkoutDaySummary.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", getDateKey())
        
        do {
            let count = try CoreDataManager.shared.viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error counting objects: \(error.localizedDescription)")
            return false
        }
    }
    
    func createOrUpdateObject() {
        let dateString = getDateKey()
        
        if let existingObject = fetchObject() {
            existingObject.comment = self.comments
            existingObject.workoutType = self.selectedWorkout
        } else {
            let newObject = WorkoutDaySummary(context: CoreDataManager.shared.viewContext)
            newObject.date = dateString
            newObject.comment = self.comments
            newObject.workoutType = selectedWorkout
        }

        CoreDataManager.shared.save()
    }

    func fetchObject() -> WorkoutDaySummary? {
        let dateString = getDateKey()

        let fetchRequest: NSFetchRequest<WorkoutDaySummary> = WorkoutDaySummary.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", dateString)
        
        do {
            let objects = try CoreDataManager.shared.viewContext.fetch(fetchRequest)
            return objects.first
        } catch {
            print("Error fetching objects: \(error.localizedDescription)")
            return nil
        }
    }
    
    //save a workout day summary to coredata
    func saveWorkoutSummary(){
        let dateValue = getDateKey()
        let commentValue = self.comments
        
        guard let workoutTypeValue = self.selectedWorkout else {
            print("\nNOT SAVED: No workout type selected\n")
            return
        }
        
        print("\(dateValue) - \(commentValue) - \(workoutTypeValue)")
        print("\nSAVED\n")
    }
}
