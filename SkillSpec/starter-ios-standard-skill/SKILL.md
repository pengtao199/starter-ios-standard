---
name: starter-ios-standard-skill
description: Use when bootstrapping a new iOS project from starter-ios-standard, choosing between Lite/Standard/Pro, or generating starter-aligned Features, pages, paywalls, settings sections, and config-driven project structure.
---

# Starter iOS Standard Skill

Use this skill when working inside a project derived from `starter-ios-standard`, or when planning how to derive a new app from it.

## Quick start

1. Read `Rules/AGENTS.md` first.
2. If the task is about project setup, read `references/development-order.md`.
3. If the task is about choosing architecture level, read `references/tier-selection.md`.
4. If the task is about generating code, follow the output contract in `references/output-contract.md`.

## What this skill does

This skill helps with:

1. Choosing `Lite / Standard / Pro`
2. Bootstrapping a new app from the starter
3. Creating a new Feature
4. Creating a new page with `PageStateContainer`
5. Creating a paywall
6. Creating new settings/support/legal sections

## Non-negotiable rules

1. Configuration values must come from `Config/`
2. User-facing text must be added to both `en.lproj` and `zh-Hans.lproj`
3. `Presentation` does not directly call `URLSession`
4. New system-wide actions should integrate through `Settings`, `Support`, or `Legal` instead of ad hoc pages

## Expected output

For generation tasks, always return:

1. Target file locations
2. New or changed config items
3. New localization keys
4. Which rules were applied
