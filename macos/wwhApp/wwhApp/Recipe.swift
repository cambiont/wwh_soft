import Foundation

// MARK: - Recipe Model v1

struct Recipe: Codable, Equatable {
    /// Stable identifier (recommended: lowercase slug, e.g. "pot-roast")
    var id: String

    /// Human-readable name (e.g. "Pot roast")
    var title: String

    /// Ordered list of components (order is meaningful)
    var components: [RecipeComponent]

    /// Optional recipe-level notes
    var notes: [String]?

    init(
        id: String,
        title: String,
        components: [RecipeComponent],
        notes: [String]? = nil
    ) {
        self.id = id
        self.title = title
        self.components = components
        self.notes = notes
    }
}

struct RecipeComponent: Identifiable, Codable, Equatable {
    /// Stable component id (slug-ish, e.g. "marinade")
    var id: String

    /// Component title (e.g. "Marinade")
    var title: String

    /// Plain strings in v1
    var ingredients: [String]

    /// Plain strings in v1
    var steps: [String]

    init(
        id: String,
        title: String,
        ingredients: [String] = [],
        steps: [String] = []
    ) {
        self.id = id
        self.title = title
        self.ingredients = ingredients
        self.steps = steps
    }
}

// MARK: - Convenience

extension Recipe {
    static let sample = Recipe(
        id: "pot-roast",
        title: "Pot roast",
        components: [
            RecipeComponent(
                id: "marinade",
                title: "Marinade",
                ingredients: ["2 tbsp soy sauce", "1 tbsp brown sugar"],
                steps: ["Mix the marinade ingredients."]
            ),
            RecipeComponent(
                id: "main",
                title: "Main",
                ingredients: ["Beef chuck", "Onion", "Carrots"],
                steps: ["Sear the beef.", "Add vegetables and simmer until tender."]
            )
        ],
        notes: ["Tastes better the next day."]
    )
}
