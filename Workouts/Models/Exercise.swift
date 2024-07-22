//
//  Exercise.swift
//  Workouts
//
//  Created by Andre Rocha on 21/07/2024.
//

import Foundation
import SwiftData

@Model
class Exercise: Identifiable {
    var id: String
    var name: String
    var workout: Workout?
    @Relationship(deleteRule: .cascade, inverse: \ExerciseSet.exercise) var sets = [ExerciseSet]()
    
    var orderedSets: [ExerciseSet] {
        return sets.sorted { $0.created_at < $1.created_at }
    }

    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
    }
}
