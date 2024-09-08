//
//  ContentView.swift
//  test
//
//  Created by Rohit Nikam on 9/7/24.
//

import SwiftUI
import GoogleGenerativeAI

struct Task: Identifiable{
    let id = UUID()
    var name: String
    var date: Date
}

struct ContentView: View {
    @State private var taskName: String = ""
    @State private var tasks: [Task] = []
    @State private var selectedDate: Date = Date()

    
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
            
            DatePicker(selection: $selectedDate,
                       label: { /*@START_MENU_TOKEN@*/Text("Date")/*@END_MENU_TOKEN@*/ })
                .labelsHidden()
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Spacer()
            
            TextField("Task Name", text: $taskName)
                .multilineTextAlignment(.center)
            
            Button("Add") {
                if !taskName.isEmpty{
                    let newTask = Task(name: taskName, date: selectedDate)
                    tasks.append(newTask)
                    taskName = ""
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
}

#Preview {
    ContentView()
}
