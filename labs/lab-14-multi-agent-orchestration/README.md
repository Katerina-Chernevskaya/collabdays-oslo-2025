# LAB 14 — Craft a multi-agent scenario

*Design an orchestrated flow that delegates to specialized agents and returns a consolidated answer.*

## 🤔 Why This Matters

Single agents struggle when asked to cover conflicting goals (e.g., creative recipe ideas plus compliance checks). Multi-agent patterns let you split responsibilities, reduce hallucinations, and keep outputs auditable.

Common challenges solved by this lab:
- "My agent gives generic answers across different domains."
- "I need a safety/compliance review before responding."
- "I want to reuse niche expertise without bloating one mega-instruction set."

## 🌐 Introduction

You will build a simple orchestration pattern with three roles:
- **Router** (Copilot Studio topic): decides which expert(s) to call.
- **Expert agents** (Azure AI Foundry): `Caffio Brewer` for recipes and `Caffio Safety` for safe-consumption guidance.
- **Aggregator** (Copilot Studio): merges answers and presents a concise response with citations.

## 🎓 Core Concepts Overview

|Concept|Why it matters|
|--|--|
|Routing prompts|Ensures the right expert handles the request.|
|Specialized instructions|Keeps each agent narrow, improving quality and safety.|
|Parallel or sequential calls|Lets you balance latency vs. completeness.|
|Aggregation|Provides a single, user-friendly answer from multiple sources.|

## 📄 Documentation and Additional Training Links

- [Prompt flow patterns for routing](https://learn.microsoft.com/azure/ai-services/openai/how-to/rag-build-rag)
- [Copilot Studio variables and conditions](https://learn.microsoft.com/microsoft-copilot-studio/advanced-logic)

## ✅ Prerequisites

- Completion of **LAB 12** to understand creating agents in Azure AI Foundry.
- Familiarity with **LAB 13** pattern for calling Foundry agents from Copilot Studio.
- Two Foundry agents you can create/configure in your project.

## 🎯 Summary of Targets

By the end of this lab you will:
- Create two specialized Foundry agents for brewing guidance and safety checks.
- Implement routing logic in Copilot Studio to choose which agent(s) to call.
- Aggregate multiple responses into a single user-facing message.

***

## 🛠️ Instructions

### Create specialized agents in Azure AI Foundry

1. In your AI Foundry project, create **Caffio Brewer** with instructions:
```
# Role & Scope
- Provide detailed coffee brewing recipes and techniques.

# Behavior Rules
- Offer 1–2 recipes max, with ingredients and step-by-step instructions.
- Cite connected data or reference content used.
- Keep responses concise and action-focused.
```
2. Add a data connection (website or blob) with your curated brewing guides and enable citations.
3. Create **Caffio Safety** with instructions:
```
# Role & Scope
- Act as a safety and moderation checker for coffee-related advice.

# Behavior Rules
- Identify potential health risks or equipment hazards.
- Use cautious, factual language; avoid medical advice and encourage consulting professionals.
- When unsure, recommend safer alternatives.
```
4. (Optional) Add a small knowledge base for safety guidelines or public references.

### Build routing and aggregation in Copilot Studio

1. In Copilot Studio, create a topic `Coffee router`.
2. Trigger phrases: `Help with coffee`, `Need a coffee plan`, `Coffee safety`.
3. Add **Ask a question** node to capture the user request → variable `user_request`.
4. Add a **Condition** node to route:
   - If the request contains `safe`, `pregnant`, `health`, route to **Safety path**.
   - Else, route to **Brewing path**.
   - For complex requests (e.g., "recipe and is it safe?"), branch to call **both** experts.
5. For each path, add an **HTTP Request** node (pattern from LAB 13) to call the respective Foundry agent via Logic App trigger, passing `Topic.user_request`.
6. Capture each response into variables `brewer_response` and/or `safety_response`.
7. Add an **Aggregate** step (Message node) that:
   - If both responses exist, combines them with headings "Brew plan" and "Safety check".
   - If only one exists, present that answer.
   - Include thread IDs if you want to allow follow-up runs.

### Optional: parallelize for speed

1. If latency is high, split the Logic App into two endpoints (one per agent) and call them in parallel branches within Copilot Studio.
2. Use a merge condition to wait for both responses before aggregating.

***

## 🧾 Summary

You now have a multi-agent orchestration where Copilot Studio routes to specialized Foundry agents and aggregates their answers. This pattern keeps expertise focused and responses safer.

## 🔑 Golden rules

- Keep each expert agent tightly scoped; avoid instruction sprawl.
- Make routing rules explicit and test edge cases (mixed intents, safety flags).
- Return structured JSON from each agent call so aggregation stays simple.
- Monitor latency; parallelize calls when the user experience needs it.
