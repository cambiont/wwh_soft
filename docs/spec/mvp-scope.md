# MVP Scope

This document defines the minimum viable product (MVP) for the recipe editor.
The goal is to deliver a clear “wow, this works” experience for non-technical users.

---

## Core principles
- Users must never need to understand Markdown or git.
- The editor operates on structured data and renders output deterministically.
- Publishing should feel safe, predictable, and non-scary.

---

## Feature 1: Recipe Editor (No Markdown Exposure)

### Core UX
- Form-based editor for recipes.
- Optional preview pane showing rendered recipe output.
- Raw Markdown is not shown by default.

### Supported recipe data
- Title
- Components with:
  - Ingredients (lists)
  - Steps (ordered)
- Notes
- Tags (optional)
- Photos (1..n)

(See `recipe-model-v1.md` for canonical data shape.)

### Export behaviour
- Generates a Markdown file matching the Hugo content structure.
- Writes front matter in the configured format (YAML/TOML/JSON).
- Stores images in a predictable location and references them correctly.

### Quality-of-life requirements
- Local autosave for drafts.
- Template enforcement (e.g. components must have steps).
- Basic validation (e.g. missing title, empty steps).

---

## Feature 2: Publishing Without “Git”

### Supported publishing modes (choose one for MVP)

#### Option A: Publish via Pull / Merge Request
- App creates a new branch per publish.
- Pushes changes to the remote repository.
- Opens a PR/MR via provider API.
- User sees confirmation with a link.

**Pros**
- Safer for multiple contributors.
- Avoids direct conflicts on main.

**Cons**
- Requires a review/merge step.

#### Option B: Direct publish to default branch
- App pulls latest changes.
- Commits locally.
- Pushes to default branch.

**Pros**
- One-click “live” publishing.

**Cons**
- Conflicts become user-visible if multiple contributors publish.

---

## Authentication
- Credentials stored securely using macOS Keychain.
- GitHub:
  - Fine-grained PAT or OAuth device flow.
- GitLab:
  - PAT or OAuth.

---

## First-run setup flow
1. Connect GitHub or GitLab account.
2. Select repository.
3. Select default branch.
4. Detect Hugo recipe folder (or prompt user).
5. Confirm recipe template and image storage strategy.
6. Setup complete.

---

## Core user flows

### Create recipe
1. Create new recipe.
2. Enter title, ingredients, steps, notes.
3. Add photo(s).
4. Preview.
5. Publish.

### Edit recipe
1. Browse recipe list from repo checkout.
2. Open recipe.
3. Edit.
4. Publish.

---

## Error handling (critical UX)
The application must clearly and calmly handle:
- Authentication expiry
- Network failures
- Push rejection
- Merge conflicts
- Repository moved or renamed

Error screens must prioritise clarity and reassurance over technical detail.
