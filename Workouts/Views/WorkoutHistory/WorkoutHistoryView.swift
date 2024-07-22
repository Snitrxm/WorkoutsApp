//
//  WorkoutHistory.swift
//  Workouts
//
//  Created by Andre Rocha on 21/07/2024.
//

import SwiftUI
import SwiftData


struct WorkoutHistory: View {
    var workoutType: WorkoutType

    @Environment(\.modelContext) var context
    
    @State var isShowingPersonalRecordsSheet: Bool = false
    
    @Query(sort: \Workout.date) var workoutHistory: [Workout]
    
    var filteredWorkouts: [Workout] {
        workoutHistory.filter { $0.type == workoutType }
    }
        
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(filteredWorkouts) { workout in
                        NavigationLink(destination: WorkoutDetailsView(workout: workout)) {
                            Text("\(workout.date.formatted(date: .numeric, time: .omitted))")
                        }
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            handleDeleteWorkout(filteredWorkouts[index])
                        }
                    })
                }
            }
            .sheet(isPresented: $isShowingPersonalRecordsSheet) {
                PersonalRecordsView(workouts: filteredWorkouts)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isShowingPersonalRecordsSheet.toggle()
                    }) {
                        Text("Personal Records")
                    }
                }
                
                ToolbarItem {
                    Button(action: {
                        handleCreateWorkout()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("\(workoutType)")
        }
    }
    
    func handleDeleteWorkout(_ workout: Workout) {
        context.delete(workout)
    }
    
    func handleCreateWorkout() {
        let workout = Workout(date: .now, type: workoutType)
        
        context.insert(workout)
    }
}

struct PersonalRecordsView: View {
    var workouts: [Workout]
    
    var uniqueExercises: [String: String] {
           var exerciseDict = [String: String]()
           
           for workout in workouts {
               if workout.exercises.isEmpty {
                   continue
               }
               
               for exercise in workout.exercises {
                   if exerciseDict[exercise.name] == nil {
                       var bestSet = exercise.sets.first?.weight ?? 0
                       for set in exercise.sets {
                           if set.weight > bestSet {
                               bestSet = set.weight
                           }
                       }
                       exerciseDict[exercise.name] = "\(bestSet) kg"
                   } else {
                       // Verifica se algum set é maior em carga e substitui
                       var currentBestWeight = Double(exerciseDict[exercise.name]!)!
                       for set in exercise.sets {
                           if set.weight > currentBestWeight {
                               currentBestWeight = set.weight
                           }
                       }
                       exerciseDict[exercise.name] = "\(currentBestWeight) kg"
                   }
               }
           }
           return exerciseDict
       }
        
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    ForEach(uniqueExercises.sorted(by: >), id: \.key) { key, value in
                        Section(key) {
                            Text(value)
                        }
                    }
                }
                
            }
            .toolbar {
                ToolbarItem {
                    Button(action: { dismiss() }){
                        Text("Done")
                    }
                }
            }
        }
    }
}

#Preview {
    let preview = Preview()
    return WorkoutHistory(workoutType: WorkoutType.PUSH)
        .modelContainer(preview.container)
}
