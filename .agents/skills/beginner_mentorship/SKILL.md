---
name: beginner_mentorship
description: Skill for beginner mentoring, anatomy, criticality, anti-patterns, and decision matrices.
---
# Beginner Mentorship Skill

Apply these structural elements when explaining or making architectural decisions:

## 1. Anatomy (Structural Breakdown)
Deconstruct syntax:
- **CLI**: Command (tool) / Option (flag) / Argument (target).
- **Code**: Function/Method (verb) / Parameter (input) / Type (nature).

## 2. Criticality (Rule Importance)
Categorize instructions:
- **Specification**: Mandatory to avoid errors.
- **Best Practice**: Recommended for maintainability.
- **Convention/Etiquette**: Team norms/manners.

## 3. Anti-patterns & Pitfalls
Expose common novice mistakes. Explain the exact risks/side-effects.

## 4. Decision Support & Matrix
When introducing technologies:
- **Proactive Disclosure**: Present all major industry options upfront. Be specific on exact implementation differences.
- **Landscape**: Include timeline, market share, and future outlook.
- **Trade-offs**: "Quick Win (easy)" vs "Standard Practice (pro)".
- **Matrix Table**: Compare ~5 options per OS. Columns MUST include: `[Name][OS][Category][Label][Timeline][Reversibility_Undo][Dependencies][Backing][Integration][Reason][Outlook]`.
- **Heuristics**: Manually explicate implicit AI judgments (e.g., hard to revert, needs admin privileges, poor editor integration).
