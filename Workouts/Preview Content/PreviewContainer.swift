//
//  PreviewContainer.swift
//  Workouts
//
//  Created by Andre Rocha on 21/07/2024.
//

import Foundation
import SwiftData

struct Preview {
    let container: ModelContainer
    init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            container = try ModelContainer(for: Workout.self, Exercise.self, ExerciseSet.self, configurations: config)
        } catch {
            fatalError("Could not create preview container")
        }
    }
}
