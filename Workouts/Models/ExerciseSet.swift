//
//  ExerciseSet.swift
//  Workouts
//
//  Created by Andre Rocha on 21/07/2024.
//

import Foundation
import SwiftData

@Model
class ExerciseSet: Identifiable {
    var id: String
    var reps: Int
    var weight: Double
    var warmup: Bool
    var exercise: Exercise?
    var created_at: Date
    
    init(reps: Int, weight: Double, warmup: Bool = false) {
        self.id = UUID().uuidString
        self.reps = reps
        self.weight = weight
        self.warmup = warmup
        self.created_at = .now
    }
}
