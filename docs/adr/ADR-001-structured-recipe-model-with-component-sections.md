# ADR-001: Structured Recipe Model with Component Sections

## Status
Accepted

## Context
The project aims to provide a macOS GUI for creating and editing recipes for a Hugo-based site, targeting non-technical users. Recipes currently exist as Markdown files managed via git, which limits extensibility and usability as features grow.

Recipes frequently consist of multiple logical parts (e.g. marinade, main, gravy; dressing and salad), each with its own ingredients and steps.

## Decision
Recipes are represented internally as structured data, composed of an ordered list of components.  

Each component has its own ingredients and ordered steps.

Markdown is treated as a rendering and publishing format, not as the conceptual source of truth.

## Consequences
- Supports recipes with an arbitrary number of components.
- Simplifies future features such as richer metadata, linking, scaling, and structured editing.
- Requires deterministic Markdown generation and (for MVP) constrained parsing.
- Reduces reliance on general-purpose Markdown parsing logic.

## Non-goals
- Supporting arbitrary freeform Markdown editing as a primary workflow.
- Modelling ingredient quantities or units beyond plain strings in v1.