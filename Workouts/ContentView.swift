//
//  ContentView.swift
//  Workouts
//
//  Created by Andre Rocha on 21/07/2024.
//

import SwiftUI

struct ContentView: View {
    var workoutsType: [WorkoutType] = [WorkoutType.PUSH, WorkoutType.PULL, WorkoutType.LEGS]
    
    let trainingSchedule = [
        ["PULL", "LEGS", "REST", "PUSH", "PULL"],
        ["LEGS", "PUSH", "REST", "PULL", "LEGS"],
        ["PUSH", "PULL", "REST", "LEGS", "PUSH"]
    ]
        
        func getTrainingForDate(date: Date) -> String {
            let calendar = Calendar.current
            let startOfCycle = calendar.date(from: DateComponents(year: 2024, month: 1, day: 1))! // Define a start date for your cycle
            let daysSinceStart = calendar.dateComponents([.day], from: startOfCycle, to: date).day!
            
            let totalDays = trainingSchedule.count * trainingSchedule[0].count
            let adjustedDay = daysSinceStart % totalDays
            let cycleIndex = adjustedDay / trainingSchedule[0].count
            let dayIndex = adjustedDay % trainingSchedule[0].count
            
            return trainingSchedule[cycleIndex][dayIndex]
        }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Today's workout is \(getTrainingForDate(date: Date()))")
                    .font(.title)
                    .bold()
                    .padding()
                ForEach(workoutsType, id: \.self) { workoutType in
                    NavigationLink(destination: WorkoutHistory(workoutType: workoutType)) {
                        GroupBox("\(workoutType)") {
                            Text("\(workoutType)")
                        }
                        .frame(width: .infinity)
                    }
                    .buttonStyle(.plain)
                    
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Workout's")
        }
    }
}

#Preview {
    let preview = Preview()
    return ContentView()
        .modelContainer(preview.container)
}
