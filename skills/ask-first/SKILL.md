---
name: ask-first
description: Clarify material ambiguity before acting. Use automatically when unresolved choices could change scope, requirements, UX, architecture, data, security, cost, external effects, or acceptance criteria, and when the user asks to be questioned, grilled, interviewed, or says not to assume. Always use callable structured question UI when available; when it is unavailable, explicitly disclose that limitation and ask exactly one text question per turn. Supports explicit invocation as ask-first.
---

# Ask First

Resolve consequential uncertainty before taking action. Prefer evidence over questions and recommendations over neutral option lists.

## Interaction rule

Before emitting any question, determine whether a callable structured question or elicitation UI is available in the current harness.

- If it is available, use it. Do not render a numbered text list as a substitute.
- If it is unavailable, begin the first question turn with: "Structured question UI is unavailable here, so I'll ask one concise text question at a time."
- In text fallback, ask exactly one question in that turn. Never append a second question, even when it seems related.

Treat a question response as invalid unless it either invokes structured question UI or begins with the required fallback disclosure. Before sending, verify that fallback contains one question only and labels the first option exactly `(Recommended)`.

## 1. Inspect before asking

- Read the conversation, project instructions, relevant files, and safe read-only state first.
- Answer questions through inspection when the answer is discoverable.
- Do not ask the user to repeat information already available.
- Do not mutate project or external state while a material decision remains unresolved.

## 2. Select a confidence policy

Honor a policy the user already supplied. Otherwise, ask which policy to use when a structured question UI is available and the choice would be useful:

1. **Risk-based (Recommended):** ask when ambiguity could materially change the result; infer conventional, reversible details and disclose them.
2. **Threshold:** ask unless confidence meets a user-selected threshold such as 90%.
3. **Strict:** ask about every unspecified choice, including minor implementation details.

Make this policy question non-blocking when the harness supports that behavior. Default to **risk-based** if the user skips it, does not answer, or the harness cannot ask it economically.

## 3. Build the decision queue

Identify unresolved decisions and order them by dependency. Under the default risk-based policy, treat ambiguity as material when it could change any of these:

- goal, scope, acceptance criteria, or user-visible behavior;
- architecture, public interfaces, data meaning, migration, or compatibility;
- privacy, security, permissions, irreversible actions, or external communication;
- meaningful time, money, operational risk, or maintenance burden.

Infer low-impact details only when the choice is conventional, reversible, and unlikely to surprise the user. Keep those assumptions available for a brief disclosure before acting.

## 4. Ask adaptively through UI

Prefer the harness's native structured question or elicitation UI.

For every question:

- ask about one decision dependency;
- provide two or three mutually exclusive choices when possible;
- put the recommended choice first and label it `(Recommended)`;
- explain the impact or tradeoff of every choice in one sentence;
- allow free-form input when the UI supports it;
- base the recommendation on inspected evidence and the user's stated goals.

Ask one question when it is consequential, long, or affects later questions. Batch two or three questions only when they are short, independent, and easier to answer together. Never batch dependent decisions.

After each answer, update the decision queue. Walk the selected branch before opening unrelated branches. Continue until no material ambiguity remains under the active confidence policy.

## 5. Fall back when UI is unavailable

Use the required disclosure from the interaction rule once per interview. Then ask one concise text question at a time with the recommended answer first and the same tradeoff information. Do not pretend a text list is an interactive UI.

## 6. Hand off to action

Before acting:

- summarize resolved decisions when the interview was substantial;
- disclose only the low-risk assumptions that could still matter;
- confirm any separate approval required for destructive, external, or scope-expanding action.

Proceed without further ceremony when the decision queue is empty and the requested action is authorized.
