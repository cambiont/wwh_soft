import SwiftUI

struct RecipeEditorView: View {
    @State private var recipe: Recipe = .sample

    var body: some View {
        HStack(spacing: 0) {
            editorPane
                .frame(maxWidth: .infinity)

            Divider()

            previewPane
                .frame(maxWidth: .infinity)
        }
        .frame(minWidth: 1000, minHeight: 700)
    }

    // MARK: - Editor

    private var editorPane: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text("Recipe Editor")
                    .font(.title)
                    .bold()
                    .padding(.top, 12)

                Form {
                    Section("Recipe") {
                        TextField("Recipe ID (slug, e.g. pot-roast)", text: $recipe.id)
                        TextField("Title", text: $recipe.title)
                    }

                    Section {
                        componentsEditor
                    } header: {
                        HStack {
                            Text("Components")
                            Spacer()
                            Button("Add component") { addComponent() }
                        }
                    }

                    Section {
                        notesEditor
                    } header: {
                        HStack {
                            Text("Notes (optional)")
                            Spacer()
                            Button("Add note") { addNote() }
                        }
                    }
                }
                .padding(.bottom, 16)

            }
            .padding(.horizontal, 16)
        }
    }

    private var componentsEditor: some View {
        VStack(alignment: .leading, spacing: 14) {

            ForEach(recipe.components.indices, id: \.self) { cIdx in
                componentCard(componentIndex: cIdx)
            }

        }
    }

    private func componentCard(componentIndex cIdx: Int) -> some View {
        let componentBinding = Binding<RecipeComponent>(
            get: { recipe.components[cIdx] },
            set: { recipe.components[cIdx] = $0 }
        )

        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Component \(cIdx + 1)")
                    .font(.headline)

                Spacer()

                Button(role: .destructive) {
                    deleteComponent(at: cIdx)
                } label: {
                    Text("Delete")
                }
                .disabled(recipe.components.count <= 1)
            }

            TextField("Component ID (e.g. marinade)", text: componentBinding.id)
            TextField("Component title", text: componentBinding.title)

            Divider()

            // Ingredients (plain strings)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Ingredients")
                        .font(.subheadline)
                        .bold()
                    Spacer()
                    Button("Add ingredient") { addIngredient(to: cIdx) }
                }

                ForEach(recipe.components[cIdx].ingredients.indices, id: \.self) { iIdx in
                    HStack {
                        TextField(
                            "Ingredient (plain text)",
                            text: bindingForIngredient(componentIndex: cIdx, ingredientIndex: iIdx)
                        )

                        Button(role: .destructive) {
                            deleteIngredient(componentIndex: cIdx, ingredientIndex: iIdx)
                        } label: {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(.borderless)
                    }
                }

                if recipe.components[cIdx].ingredients.isEmpty {
                    Text("No ingredients yet.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            // Steps (plain strings)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Steps")
                        .font(.subheadline)
                        .bold()
                    Spacer()
                    Button("Add step") { addStep(to: cIdx) }
                }

                ForEach(recipe.components[cIdx].steps.indices, id: \.self) { sIdx in
                    HStack {
                        Text("\(sIdx + 1).")
                            .foregroundStyle(.secondary)
                            .frame(width: 28, alignment: .trailing)

                        TextField(
                            "Step (plain text)",
                            text: bindingForStep(componentIndex: cIdx, stepIndex: sIdx)
                        )

                        Button(role: .destructive) {
                            deleteStep(componentIndex: cIdx, stepIndex: sIdx)
                        } label: {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(.borderless)
                    }
                }

                if recipe.components[cIdx].steps.isEmpty {
                    Text("No steps yet.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

        }
        .padding(12)
        .background(Color(nsColor: .windowBackgroundColor).opacity(0.6))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
        )
        .cornerRadius(10)
    }

    private var notesEditor: some View {
        VStack(alignment: .leading, spacing: 10) {
            let notes = recipe.notes ?? []

            ForEach(notes.indices, id: \.self) { nIdx in
                HStack {
                    TextField("Note (plain text)", text: bindingForNote(noteIndex: nIdx))

                    Button(role: .destructive) {
                        deleteNote(at: nIdx)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(.borderless)
                }
            }

            if notes.isEmpty {
                Text("No notes.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Preview

    private var previewPane: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Preview")
                    .font(.title)
                    .bold()
                    .padding(.top, 12)

                Text(recipe.title.isEmpty ? "Untitled" : recipe.title)
                    .font(.title2)
                    .bold()

                Text("ID: \(recipe.id.isEmpty ? "—" : recipe.id)")
                    .foregroundStyle(.secondary)

                Divider()

                ForEach(recipe.components, id: \.id) { component in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(component.title.isEmpty ? "Untitled component" : component.title)
                            .font(.headline)

                        if !component.ingredients.isEmpty {
                            Text("Ingredients")
                                .font(.subheadline)
                                .bold()

                            ForEach(component.ingredients, id: \.self) { line in
                                Text("• \(line)")
                            }
                        }

                        if !component.steps.isEmpty {
                            Text("Steps")
                                .font(.subheadline)
                                .bold()
                                .padding(.top, component.ingredients.isEmpty ? 0 : 6)

                            ForEach(Array(component.steps.enumerated()), id: \.offset) { idx, line in
                                Text("\(idx + 1). \(line)")
                            }
                        }

                        if component.ingredients.isEmpty && component.steps.isEmpty {
                            Text("No ingredients or steps yet.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)

                    Divider()
                }

                if let notes = recipe.notes, !notes.isEmpty {
                    Text("Notes")
                        .font(.headline)
                        .padding(.top, 6)

                    ForEach(notes, id: \.self) { n in
                        Text("• \(n)")
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
    }

    // MARK: - Actions (Components)

    private func addComponent() {
        let n = recipe.components.count + 1
        recipe.components.append(
            RecipeComponent(
                id: "component-\(n)",
                title: "Component \(n)",
                ingredients: [],
                steps: []
            )
        )
    }

    private func deleteComponent(at index: Int) {
        guard recipe.components.count > 1 else { return }
        guard recipe.components.indices.contains(index) else { return }
        recipe.components.remove(at: index)
    }

    // MARK: - Actions (Ingredients)

    private func addIngredient(to componentIndex: Int) {
        guard recipe.components.indices.contains(componentIndex) else { return }
        recipe.components[componentIndex].ingredients.append("")
    }

    private func deleteIngredient(componentIndex: Int, ingredientIndex: Int) {
        guard recipe.components.indices.contains(componentIndex) else { return }
        guard recipe.components[componentIndex].ingredients.indices.contains(ingredientIndex) else { return }
        recipe.components[componentIndex].ingredients.remove(at: ingredientIndex)
    }

    // MARK: - Actions (Steps)

    private func addStep(to componentIndex: Int) {
        guard recipe.components.indices.contains(componentIndex) else { return }
        recipe.components[componentIndex].steps.append("")
    }

    private func deleteStep(componentIndex: Int, stepIndex: Int) {
        guard recipe.components.indices.contains(componentIndex) else { return }
        guard recipe.components[componentIndex].steps.indices.contains(stepIndex) else { return }
        recipe.components[componentIndex].steps.remove(at: stepIndex)
    }

    // MARK: - Actions (Notes)

    private func addNote() {
        if recipe.notes == nil { recipe.notes = [] }
        recipe.notes?.append("")
    }

    private func deleteNote(at index: Int) {
        guard var notes = recipe.notes else { return }
        guard notes.indices.contains(index) else { return }
        notes.remove(at: index)
        recipe.notes = notes.isEmpty ? nil : notes
    }

    // MARK: - Bindings helpers

    private func bindingForIngredient(componentIndex: Int, ingredientIndex: Int) -> Binding<String> {
        Binding<String>(
            get: {
                guard recipe.components.indices.contains(componentIndex),
                      recipe.components[componentIndex].ingredients.indices.contains(ingredientIndex)
                else { return "" }
                return recipe.components[componentIndex].ingredients[ingredientIndex]
            },
            set: { newValue in
                guard recipe.components.indices.contains(componentIndex),
                      recipe.components[componentIndex].ingredients.indices.contains(ingredientIndex)
                else { return }
                recipe.components[componentIndex].ingredients[ingredientIndex] = newValue
            }
        )
    }

    private func bindingForStep(componentIndex: Int, stepIndex: Int) -> Binding<String> {
        Binding<String>(
            get: {
                guard recipe.components.indices.contains(componentIndex),
                      recipe.components[componentIndex].steps.indices.contains(stepIndex)
                else { return "" }
                return recipe.components[componentIndex].steps[stepIndex]
            },
            set: { newValue in
                guard recipe.components.indices.contains(componentIndex),
                      recipe.components[componentIndex].steps.indices.contains(stepIndex)
                else { return }
                recipe.components[componentIndex].steps[stepIndex] = newValue
            }
        )
    }

    private func bindingForNote(noteIndex: Int) -> Binding<String> {
        Binding<String>(
            get: {
                let notes = recipe.notes ?? []
                guard notes.indices.contains(noteIndex) else { return "" }
                return notes[noteIndex]
            },
            set: { newValue in
                if recipe.notes == nil { recipe.notes = [] }
                guard recipe.notes!.indices.contains(noteIndex) else { return }
                recipe.notes![noteIndex] = newValue
            }
        )
    }
}

private extension Binding where Value == RecipeComponent {
    var id: Binding<String> { .init(get: { wrappedValue.id }, set: { wrappedValue.id = $0 }) }
    var title: Binding<String> { .init(get: { wrappedValue.title }, set: { wrappedValue.title = $0 }) }
}
#Preview {
    RecipeEditorView()
}
