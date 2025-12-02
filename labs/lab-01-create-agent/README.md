# LAB 1 — Create an agent in Copilot Studio with public weblinks as knowledge

*Build a Copilot Studio agent, give it clear operating instructions, and connect two public websites as knowledge sources.*

## 🤔 Why This Matters

For makers building their first production‑ready agent: getting the basics right saves you from chaotic behavior and inconsistent answers. An agent with explicit scope, tone, and guardrails is faster to test and safer to ship.

Common challenges solved by this lab:
- "The agent wanders off topic."
- "Responses feel random or too technical."
- "No citations or unclear sourcing."
- "I don’t know where to put behavior rules."

## 🌐 Introduction

You’ll stand up a focused agent called **Caffio**. It behaves like a friendly coffee expert and recipe assistant. You’ll author explicit instructions (scope, tone, behavior, and tasks) and connect two public websites as knowledge sources. You’ll also map the agent to a solution via advanced settings and validate the conversation in the Test pane.

## 🎓 Core Concepts Overview

|Concept|Why it matters|
|--|--|
|Agent instructions|Set the non‑negotiables: scope, tone, behavior rules, and tasks to guide every response.|
|Knowledge sources (web)|Provide the factual backbone so the agent can cite and summarize reliable content.|
|Solution mapping|Keeps assets organized for ALM, transport, and environment hygiene.|
|Test pane|Fast feedback loop for validating behavior before going live.|

## 📄 Documentation and Additional Training Links

- [Microsoft Copilot Studio documentation hub](https://learn.microsoft.com/en-us/microsoft-copilot-studio/)
- [Write agent instructions](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-instructions)
- [Knowledge sources overview](https://learn.microsoft.com/en-us/microsoft-copilot-studio/knowledge-copilot-studio)
- [Solutions in Power Apps](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/solutions-overview)

## ✅ Prerequisites

- A prepared workshop environment, or the ability to create a new one per prerequisites.
- Access to an environment in [make.powerapps.com](https://make.powerapps.com) with permissions to create solutions and agents.

## 🎯 Summary of Targets

In this lab, you will:
- Create a new Solution for workshop assets.
- Create an Agent with defined scope, tone, behavior rules, and tasks.
- Add two web knowledge sources and descriptions.
- Map the agent to your Solution using Advanced Settings.
- Validate the agent’s answers using the Test pane.

***

## 🛠️ Instructions

1. Navigate to [make.powerapps.com](https://make.powerapps.com), sign in, and open the environment you prepared for the workshop. If you haven’t prepared it yet, create a new environment as described on the [prerequisite page](../../README.md).
2. Create a new solution. Name it `Caffio`.
3. Navigate to https://copilotstudio.preview.microsoft.com/ and select `New agent`.
4. In the creation chat, enter the following description:
```
My agent is called Caffio. It should act like a friendly coffee expert and recipe assistant. The goal is to help people with everything related to coffee: history, bean varieties, brewing methods, and drink recipes.
The tone should be warm, approachable, and enthusiastic, like a barista giving tips. Use simple, clear language for beginners, but add interesting trivia or fun facts for advanced coffee lovers. Avoid heavy technical jargon unless the user explicitly asks for it.
Behavior rules:
- Always focus on coffee topics. If the user asks about something else, gently redirect with: “I’m Caffio, your coffee companion. I can help with beans, brewing, and coffee culture!”
- For recipes, give clear, numbered steps. Keep them short and actionable.
- When comparing (e.g., Arabica vs Robusta), highlight the main differences first, then add extra details.
- Add fun facts occasionally to keep the chat lively.
- Every factual answer must include a source. Quote or summarize the relevant passage and provide a clickable URL.
- Never give medical advice about caffeine intake; instead, suggest consulting reliable health sources.
Tasks:
- Search connected knowledge sources (docs, websites, AI Search) to answer user questions.
- Summarize results clearly; don’t dump raw text.
- Provide variations when possible (e.g., alternative brewing methods).
- If information isn’t available, acknowledge the limit and suggest the closest helpful content.
```
5. Follow the configuration dialogue. You can update the agent name and add additional instructions.
6. In the configuration dialogue, add the following sites as knowledge:
   - https://coffeefactz.com/
   - https://www.thecoffeedatabase.com/
7. Select the three dots in the upper‑right corner and choose `Update advanced settings`. In the pop‑up, select the solution you created. If required, update the agent schema name.
8. Test the agent in the right‑hand Test pane.
9. When satisfied, select `Create` to create the agent.
After creation, use the Test pane to ask coffee‑related and unrelated questions and observe differences in responses.

***

**🏅 Congratulations! You’ve completed the Lab 1!**

## 📑 Summary of Learnings

- Scope before style: a tight scope prevents drift.
- Grounding is a feature: explicit knowledge sources raise answer quality.
- Organize assets: mapping to a solution helps with ALM and governance.
- Test early and often: use the Test pane to catch issues before release.

## 🔑 Golden rules

- Author instructions that are short, testable, and source‑aware.
- Ground answers in curated sites; require citations.
- Validate redirect behavior with off‑topic prompts.
- Store the agent in a Solution for lifecycle management.