# Recipe Model v1

This document defines the canonical structured representation of a recipe for the recipe editor.

This model is **component-based**: a recipe is composed of an ordered list of components (e.g. Marinade, Meat, Gravy), each with its own ingredients and steps.

## Goals
- Support recipes with **n components**, each with its own ingredients and steps.
- Keep v1 simple: ingredients and steps are stored as plain strings.
- Enable deterministic rendering to Hugo-friendly Markdown.

## Non-goals (v1)
- Structured quantity/unit parsing for ingredients.
- Rich step semantics (timers, sub-steps, dependencies).
- Cross-recipe links or references.
- Arbitrary freeform Markdown as the primary editing format.

---

## Top-level: `Recipe`

### Shape
A recipe is a JSON object with the following fields:

#### Required
- `id` (string)
- `title` (string)
- `components` (array of `Component`, ordered, length >= 1)

#### Optional
- `notes` (array of string)

### Field definitions
- **`id`**
  - A stable identifier for the recipe.
  - Must be unique within the recipe collection/repo.
  - Recommended format: lowercase slug (e.g. `pot-roast`).

- **`title`**
  - Human-readable recipe name (e.g. `Pot roast`).

- **`components`**
  - Ordered list of recipe components.
  - Order is meaningful and must be preserved by the editor and renderer.

- **`notes`**
  - Optional list of notes for the recipe as a whole.
  - Notes are plain strings in v1.

### Example
```json
{
  "id": "pot-roast",
  "title": "Pot roast",
  "components": [
    {
      "id": "marinade",
      "title": "Marinade",
      "ingredients": ["2 tbsp soy sauce"],
      "steps": ["Mix the marinade ingredients."]
    }
  ],
  "notes": ["Tastes better the next day."]
}
