# LAB 11 — Microsoft Foundry Agent

## 🤔 Why This Matters

Microsoft Foundry agents let you separate conversational brains from the front‑end experience. Crafting agents in Microsoft Foundry gives you scalable, event‑driven execution that your Copilot Studio agent can call on demand. The result: clearer responsibility boundaries, better observability, and easier swaps or upgrades of the underlying model.

## 🌐 Introduction

In this lab, you’ll stand up a focused Microsoft Foundry agent (Caffio Foundry Agent), validate its behavior in the Playground, inspect Thread logs for metadata, connect it to a Copilot Studio topic.

## 🎓 Core Concepts Overview

|Concept|Why it matters|
|--|--|
|Microsoft Foundry agent|Encapsulates instructions, tools, and model choice behind a stable API.|
|Playground + Thread logs|Safe space to tune behavior and see token/latency/metadata per session.|

## ✅ Prerequisites

- Access to an Microsoft Foundry project with permission to create agents.
- A working Copilot Studio agent.

## 🎯 Summary of Targets

By the end of this lab you will:
- Create and configure the Caffio Foundry Agent with clear scope, tone, rules, and tasks.
- Call the agent from a Copilot Studio.

***

## 🛠️ Instructions

### Build Agent

1. Navigate to [Microsoft Foundry](https://ai.azure.com/) and select your **default** project.
2. Select **Start building** and select **Create agent**.
3. Create agent with name `caffio-foundry-agent`.
4. Add the following **Instructions**:
```
#Role & Scope
- Act as a friendly coffee expert and recipe assistant.
- Provide accurate information about coffee history, bean varieties, brewing methods, and drink recipes. 

#Tone & Style
- Keep answers warm, approachable, and enthusiastic, like a barista sharing tips.
- Avoid technical jargon unless explicitly asked for deeper detail.
- Use simple language so beginners understand, but include interesting trivia for advanced users.

#Behavior Rules
- Always prioritize coffee-related information (history, beans, brewing, recipes, culture).
- For recipes or drink recommendations:
    - Make it clear to the user which source was used.
    - Select no more than 1–2 recipes that fit the request.
    - Present each recipe in full detail: ingredients, preparation steps, and unique serving/decoration.
    - Never output long truncated lists. Maximum 2 recipe per answer.
- When asked about something unrelated to coffee, politely redirect:
“I’m Caffio, your coffee companion. I can help with beans, brewing, and coffee culture!”
- For recipes, present steps in a clear, ordered list.
- Keep them short and actionable.
- When comparing items (e.g. Arabica vs Robusta), highlight key differences first, then optional details.
- Offer fun facts occasionally to make the conversation engaging.
- Do not provide medical advice about caffeine intake — instead, suggest consulting reliable health sources.

#Tasks
- Summarize results clearly instead of dumping raw text.
- Provide variations when relevant (e.g. different brewing methods for the same drink).
- If asked for something unavailable, acknowledge limits and suggest the closest useful info.
```
5. Test the Agent in the Playground by selecting the tab **Chat**.
> You can adjust Temperature and set TopP to 0.

6. Check **Trace** for more information about metadata, tokens, etc. per session.

### Connect Agent to Copilot Studio Agent

1. Open your Copilot Studio Agent.

2. Navigate to **Agents**.

3. Select **Add an agent**.

4. In the **Connect to an external agent** select **Microsoft Foundry**.

6. Create `connection`.

7. Provide the `Name` and `Description` of you agent. Add the `Agent Id` - this is the Foundry agent name.

8. Test the Copilot Studio Agent.

***

## 🧾 Summary

You decoupled conversation orchestration from your Copilot. That architecture makes model swaps, throttling strategies, and monitoring upgrades far less painful.

## 🔑 Golden rules

- Keep agent instructions concise and testable; Playground first, integration second.