import SwiftUI

struct WorkoutDetailsView: View {
    var workout: Workout
    
    @Environment(\.modelContext) var context
    
    @State private var isOpenAddExerciseSheet: Bool = false
    @State private var isOpenAddSetSheet: Bool = false
    @State private var selectedExercise: Exercise?
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(workout.exercises) { exercise in
                        Section() {
                            if !exercise.orderedSets.isEmpty {
                                ForEach(exercise.orderedSets) { item in    
                                    Text("\(item.reps) reps X \(item.weight, specifier: "%.1f") kg \(item.warmup ? "- Aquecimento" : "")")
                                }
                                .onDelete(perform: { indexSet in
                                    for index in indexSet {
                                        handleDeleteSet(set: exercise.sets[index], from: exercise)
                                    }
                                })
                            }
                            
                            Button(action: {
                                selectedExercise = exercise
                                isOpenAddSetSheet.toggle()
                            }) {
                                Label("Add Set", systemImage: "plus")
                            }
                        } header: {
                            HStack {
                                Text(exercise.name)
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        handleDeleteExercise(exercise)
                                    }
                                }){
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Add Exercise") {
                        isOpenAddExerciseSheet.toggle()
                    }
                }
            }
            .sheet(isPresented: $isOpenAddSetSheet) {
                AddSetForm(exercise: $selectedExercise)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $isOpenAddExerciseSheet) {
                AddExerciseForm(workout: workout)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            .navigationTitle("\(workout.date.formatted(date: .numeric, time: .omitted))")
        }
    }
    
    func handleDeleteExercise(_ exercise: Exercise){
        if let index = workout.exercises.firstIndex(where: { $0.id == exercise.id }) {
            workout.exercises.remove(at: index)
        }
        
        do {
            try context.save()
        } catch {
            print("Erro saving context \(error)")
        }
    }
    
    func handleDeleteSet(set: ExerciseSet, from exercise: Exercise) {
        if let index = exercise.sets.firstIndex(where: { $0.id == set.id }) {
            exercise.sets.remove(at: index)
        }
        
        
        do {
            try context.save()
        } catch {
            print("Erro saving context \(error)")
        }
        
    }
}

struct AddSetForm: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var exercise: Exercise?
    
    @State private var reps: String = ""
    @State private var weight: String = ""
    @State private var warmup: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Reps") {
                    TextField("Reps", text: $reps)
                        .keyboardType(.decimalPad)
                }
                
                Section("Weight") {
                    TextField("Weight", text: $weight)
                        .keyboardType(.decimalPad)
                }
                
                Section("Warmup") {
                    Toggle(isOn: $warmup) {
                        Text("Warmup Set")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        handleAddSetToExercise()
                    }
                }
            }
        }
    }
    
    func handleAddSetToExercise() {
        if let exercise = exercise {
            let set = ExerciseSet(reps: Int(reps) ?? 0, weight: Double(weight) ?? 0, warmup: warmup)
            
            exercise.sets.append(set)
                        
            dismiss()
        }
    }
}

struct AddExerciseForm: View {
    var workout: Workout
    @Environment(\.dismiss) var dismiss
    
    var exerciseNames: [String] {
        Workout.getExercisesName(workoutType: workout.type)
    }
    
    @State private var selectedExerciseName: String = ""
    
    init(workout: Workout) {
        self.workout = workout
        self._selectedExerciseName = State(initialValue: self.exerciseNames.first ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Picker("Exercise", selection: $selectedExerciseName) {
                    ForEach(exerciseNames, id: \.self) { name in
                        Text(name)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        handleAddExerciseToWorkout()
                    }
                }
            }
        }
    }
    
    func handleAddExerciseToWorkout() {
        let exercise = Exercise(name: selectedExerciseName)
        workout.exercises.append(exercise)
        dismiss()
    }
}

#Preview {
    let preview = Preview()
    let workout = Workout(date: .now, type: WorkoutType.PUSH)
    
    return WorkoutDetailsView(workout: workout)
        .modelContainer(preview.container)
        .onAppear {

            let exerciseChestFly = Exercise(name: "Chest Fly")
            
            let exerciseChestPress = Exercise(name: "Chest Press")
            
            workout.exercises.append(contentsOf: [exerciseChestFly, exerciseChestPress])
            
            preview.container.mainContext.insert(workout)



        }
}
