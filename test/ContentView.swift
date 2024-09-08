//
//  ContentView.swift
//  test
//
//  Created by Rohit Nikam on 9/7/24.
//

import SwiftUI
import UserNotifications

struct Task: Identifiable{
    let id = UUID()
    var name: String
    var date: Date
}

struct ContentView: View {
    @State private var taskName: String = ""
    @State private var tasks: [Task] = []
    @State private var selectedDate: Date = Date()
    @State private var isBellActive: Bool = true

    
    var body: some View {
        VStack {
            
            Spacer()
            
            Circle()
                .fill(.blue)
                .frame(width: 200)
                .overlay(
                    Image(systemName: "calendar.circle")
                        .font(.system(size: 144))
                        .foregroundColor(.white)
                )
            
            Spacer()
                .frame(height: 30)
            
            HStack {
                DatePicker(selection: $selectedDate,
                           label: { /*@START_MENU_TOKEN@*/Text("Date")/*@END_MENU_TOKEN@*/ })
                    .labelsHidden()
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                
                Spacer()
                    .frame(width: 30)
                
                Button(action: {
                    isBellActive.toggle()
                }) {
                    Image(systemName: isBellActive ? "bell" : "bell.slash")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            .padding()
            Spacer()
            
            TextField("Task Name", text: $taskName)
                .multilineTextAlignment(.center)
            
            Button("Add") {
                if !taskName.isEmpty{
                    let newTask = Task(name: taskName, date: selectedDate)
                    tasks.append(newTask)
                    taskName = ""
                    
                    if isBellActive{
                        scheduleNotification(for: newTask)
                    }
                }
            }
            
            
            
            List{
                
                ForEach (tasks.sorted (by: {$0.date < $1.date})){task in
                    HStack{
                        
                        Text(task.name)
                        Spacer()
                        Text(task.date, style: .date)
                        
                        Spacer()
                        
                        Button (action: {
                            if let index = tasks.firstIndex(where: {$0.id == task.id}){
                                deleteTask(at: index)
                            }
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                }
            }
        }
        .padding()
    }
    
    private func deleteTask(at index: Int){
        tasks.remove(at: index)
    }
    
    private func scheduleNotification(for task: Task){

        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Don't forget to: \(task.name)"
        content.sound = .default
        
        // Create date components from the task's date for scheduling the notification
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
            
        // Create a calendar-based trigger to fire the notification at the specific time
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
        // Create a unique identifier for this notification request using the task's ID
        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)
            
        // Add the notification request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            // Handle any errors that occur while adding the notification request
            if let error = error {
                print("Error scheduling notification:\(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ContentView()
}
