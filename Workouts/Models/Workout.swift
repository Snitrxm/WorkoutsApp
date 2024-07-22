//
//  Workout.swift
//  Workouts
//
//  Created by Andre Rocha on 21/07/2024.
//

import Foundation
import SwiftData

enum WorkoutType: Codable {
    case PUSH, PULL, LEGS
}

@Model
class Workout: Identifiable, ObservableObject {
    var id: String
    var date: Date
    var type: WorkoutType
    @Relationship(deleteRule: .cascade, inverse: \Exercise.workout) var exercises = [Exercise]()
    
    init(date: Date, type: WorkoutType) {
        self.id = UUID().uuidString
        self.date = date
        self.type = type
    }
    
    static func getExercisesName(workoutType: WorkoutType) -> [String] {
        if workoutType == WorkoutType.PUSH {
            return ["Chest Fly", "Chest Press", "Incline Bench Press", "Triceps Pushdown Cable", "French Triceps", "Lateral Raise", "Shoulder Press"]
        }
        
        if workoutType == WorkoutType.PULL {
            return ["Lat Pulldown", "Seated Row", "Face Pull", "Preacher Curl", "Hammer Curl", "Bicep Curl"]
        }
        
        if workoutType == WorkoutType.LEGS {
            return ["Leg Extension", "Lying Leg Curl", "Calf Press Seated Leg Press", "Bulgarian", "Anca"]
        }
        
        return []
    }
}
