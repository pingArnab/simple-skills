---
name: demo-first
description: Preview and explicitly approve user-facing changes before production implementation. Use automatically for requests to build or materially change pages, components, UI, UX, flows, interactions, or visual behavior. Also use when the user asks for a demo, prototype, mockup, wireframe, or approval gate. Explicit invocation may force this workflow for any task.
---

# Demo First

Create the smallest useful preview, obtain explicit approval, and only then implement the approved change.

## Interaction rule

Before emitting any question, determine whether a callable structured question or elicitation UI is available in the current harness.

- If it is available, use it.
- If it is unavailable, say: "Structured question UI is unavailable here, so I'll ask one concise text question at a time."
- In text fallback, ask exactly one question in that turn. Defer scope and follow-up decisions to later turns.

## 1. Establish the proposal

- Inspect the project's existing UI stack, conventions, and relevant code with read-only tools.
- Resolve material ambiguity before creating the demo. Use `ask-first` when it is available; otherwise follow an equivalent clarification loop.
- Define what the demo must let the user see or decide.
- Do not auto-activate for backend-only work. If explicitly invoked for non-UI work, explain the mismatch and recommend the design or wireframe mode.

## 2. Let the user choose the demo type

Use structured question UI when available. Honor a demo type the user already selected; otherwise offer all three:

1. **Project-stack prototype:** recommend when an existing runnable UI stack is available and realistic behavior or visual fidelity matters.
2. **Standalone HTML:** recommend when isolation, portability, or a dependency-free preview matters, or when no suitable UI stack exists.
3. **Design or wireframe:** recommend when structure and intent need validation before interaction code is worthwhile.

Recommend the best fit from project context, but let the user override it. If structured UI is unavailable, follow the interaction rule and ask only this demo-type choice in the current turn.

## 3. Enforce the pre-approval boundary

Before approval, create only isolated demo artifacts.

- Do not wire the demo into production routes, builds, APIs, databases, schemas, or deployment paths.
- Do not add or change production dependencies or application configuration.
- Use existing dependencies when creating a project-stack prototype.
- Keep standalone previews and design artifacts outside production code paths.
- Ask permission before any dependency or configuration change that is truly unavoidable.

The demo may be runnable and interactive, but it must remain disposable.

## 4. Make the decision visible

Show the main state, interaction, responsive behavior, and important edge states needed for approval. Match the project's product language and visual system when available. Avoid polishing details that do not affect the decision.

Present the preview where the user can inspect it. State the demo's location and any deliberate limitations.

## 5. Request explicit approval

Prefer a structured approval UI with these outcomes:

- **Approve implementation** when the preview meets the stated goal;
- **Request revisions** when the preview needs changes;
- **Reject or stop** when the direction should not proceed.

Recommend approval only when the demo satisfies the agreed criteria. Otherwise recommend revision and name the gap.

Count either of these as approval:

- a dedicated approval action in the UI;
- unambiguous written authorization such as "approve implementation" or "go ahead."

Do not treat silence, inactivity, generic praise, or "looks good" by itself as approval.

When revisions are requested, update only the isolated demo and ask again. Do not begin production implementation during the revision loop.

## 6. Implement only the approved scope

After approval:

- restate the approved direction and any retained constraints;
- implement the production change using the project's normal conventions;
- validate the result in proportion to risk;
- return to clarification or a revised demo if implementation would materially diverge from what was approved.

Approval covers only the demonstrated scope. Obtain new approval for a materially different direction.
