import SwiftUI

struct CalendarView: View {
    @State private var currentDate = Date()
    @Binding var isModal: Bool;
    @Binding var selectedDate: Date
    
    private let columns = 7
    private let numberOfRows = 6 // 6 weeks for layout
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    private var daysInMonth: [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let numDays = range.count
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        
        var daysArray: [Date] = []
        for day in 0..<numDays {
            let date = calendar.date(byAdding: .day, value: day, to: firstDayOfMonth)!
            daysArray.append(date)
        }
        return daysArray
    }
    
    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    // Action to perform when the button is tapped
                    withAnimation {
                        self.updateMonth(by: -1)
                    }
                }) {
                    Image(systemName: "chevron.left") // Left arrow icon
                        .foregroundColor(.green)
                        .frame(width: 40, height: 10)
                        .padding()
                }
                
                Spacer()
                
                Text(monthString(for: currentDate))
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    // Action to perform when the button is tapped
                    withAnimation {
                        self.updateMonth(by: 1)
                    }
                }) {
                    Image(systemName: "chevron.right") // Right arrow icon
                        .foregroundColor(.green)
                        .frame(width: 40, height: 10)
                        .padding()
                }
            }
            
            HStack {
                ForEach(1 ..< 8) { dayIndex in
                    Text(self.dayOfWeek(for: dayIndex))
                        .textCase(.uppercase)
                        .font(.caption)
                        .frame(width: 40, height: 10)
                        .foregroundColor(.secondary)
                        .background(Color.red.opacity(0.0))
                        .cornerRadius(20)
                }
            }
            
            VStack{
                ForEach(0..<numberOfRows, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<self.columns, id: \.self) { column in
                            let index = row * self.columns + column
                            if index < self.daysInMonth.count {
                                CalendarCell(date: self.daysInMonth[index], selectedDate: $selectedDate, isModal: $isModal)
//                                    .withAnimation(.easeInOut(duration: 0.2))
                            } else {
                                Text("")
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.green)
                                    .background(Color.green.opacity(0.0))
                                    .cornerRadius(20)
                                    .padding(4)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    // Function to get the day of the week (SUN to SAT) for a given index
    private func dayOfWeek(for index: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.shortWeekdaySymbols[(index + 5) % 7] // Shifting for SAT to SUN
    }
    
    private func monthString(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM YYY"
        return dateFormatter.string(from: date)
    }
    
    private func updateMonth(by value: Int) {
        currentDate = Calendar.current.date(byAdding: .month, value: value, to: currentDate) ?? currentDate
    }
}

struct CalendarCell: View {
    let date: Date
    @Binding var selectedDate: Date
    @Binding var isModal: Bool
    
    var body: some View {
        Button(action: {
            selectedDate = self.date
            isModal = true
        }, label: {
            Text(getDay(from: date))
                .frame(width: 40, height: 40)
                .foregroundColor(.green)
                .background(Color.green.opacity(0.1))
                .cornerRadius(20)
                .padding(4)
            
        })
    }
    
    private func getDay(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(isModal: .constant(false), selectedDate: .constant(Date()))
    }
}
