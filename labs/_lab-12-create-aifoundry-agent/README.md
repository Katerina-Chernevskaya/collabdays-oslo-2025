# LAB 12 — Create an agent in Azure AI Foundry

*Build a grounded AI Foundry agent with clear guardrails, tools, and evaluation hooks.*

## 🤔 Why This Matters

Azure AI Foundry agents give you deterministic behavior, centralized governance, and the ability to reuse the same intelligence across channels. Getting the first agent right—scoped instructions, data connections, and evaluation—sets the tone for every integration that follows.

Common challenges solved by this lab:
- "I don’t know where to start with instructions in Foundry."
- "How do I add data and keep responses grounded?"
- "How can I prove the agent behaves before wiring it into apps?"

## 🌐 Introduction

You will create a dedicated agent called **Caffio Foundry Agent** inside your Azure AI Foundry project. You will configure instructions, connect a data source for grounding, test behavior in the Playground, and capture evaluation metrics from thread logs before exposing the agent to other systems.

## 🎓 Core Concepts Overview

|Concept|Why it matters|
|--|--|
|Agent instructions|Establishes scope, tone, and rules that every run must obey.|
|Connections (data sources)|Ground responses with approved content and citations.|
|Playground|Fast feedback loop to validate behavior and tweak parameters.|
|Thread logs|Visibility into messages, tokens, and latency for each run.|

## 📄 Documentation and Additional Training Links

- [Azure AI Foundry agents overview](https://learn.microsoft.com/azure/ai-foundry/agents/overview)
- [Connect data to an agent](https://learn.microsoft.com/azure/ai-foundry/agents/how-to/data)
- [Use Playground to iterate](https://learn.microsoft.com/azure/ai-foundry/agents/how-to/playground)

## ✅ Prerequisites

- Access to an Azure AI Foundry project with permission to create agents and connections.
- A storage-backed data source you can connect (e.g., Azure Blob with PDFs) or a public website for quick grounding.
- A modern browser and the ability to sign in to https://ai.azure.com/.

## 🎯 Summary of Targets

By the end of this lab you will:
- Create the **Caffio Foundry Agent** with explicit scope, tone, and rules.
- Add at least one data connection for grounding.
- Validate the agent in Playground with deterministic parameters.
- Review thread logs to understand token usage and latency.

***

## 🛠️ Instructions

### Create the Agent shell

1. Navigate to [Azure AI Foundry](https://ai.azure.com/) and open your **default** project.
2. Select **Agents** → **+ New agent**.
3. Name it `Caffio Foundry Agent` and select a reliable model (e.g., `gpt-4o-mini` or `gpt-4.1-mini`).
4. Add the following **Instructions**:
```
# Role & Scope
- Be a friendly coffee expert and recipe assistant.
- Stay focused on coffee history, beans, brewing methods, and drink recipes.

# Tone & Style
- Warm, approachable, barista-like.
- Use concise sentences and avoid heavy jargon.

# Behavior Rules
- Always cite the connected data source when answering.
- Offer 1–2 focused recipes with ingredients and steps when requested.
- If asked about non-coffee topics, redirect politely and restate what you can help with.
- Keep answers short, scannable, and action-oriented.

# Tasks
- Summarize user intent, then provide the best answer with citations.
- Provide step-by-step brewing guidance when relevant.
- If information is missing, acknowledge limits and suggest the closest useful option.
```
5. Save the agent.

### Ground the agent with data

1. In the agent view, open **Connections**.
2. Choose a data type that fits your workshop setup:
   - **Website**: Add a trusted coffee site (e.g., a blog article with brewing guides).
   - **Azure Blob Storage**: Point to a container with your curated coffee PDFs.
   - **SharePoint**: Use a document library if available.
3. Enable **Use citations** to keep responses traceable.
4. Save and start indexing. Wait until the connection status is **Ready**.

### Validate in Playground

1. Click **Try in Playground**.
2. Set parameters for deterministic tests:
   - **Temperature**: `0`.
   - **Top P**: `0`.
3. Run at least two prompts, for example:
   - "Give me a V60 recipe using 20g of coffee."
   - "What’s the difference between Arabica and Robusta?"
4. Confirm responses cite the connected data and follow tone rules.
5. Adjust instructions if the agent over-answers or misses citations, then retest.

### Inspect thread logs

1. From the Playground session, open **Thread logs**.
2. Review:
   - Message history and roles.
   - Token counts and latency per run.
   - Which connection content was used.
3. Capture notes on any prompts that caused drift so you can iterate later.

***

## 🧾 Summary

You now have a production-ready Azure AI Foundry agent with scoped instructions, grounded data, and observable runs. This becomes the building block for downstream integrations.

## 🔑 Golden rules

- Keep instructions tight; shorter rules are easier to evaluate.
- Always enable citations when grounding with your own data.
- Use Playground and thread logs before exposing the agent to other systems.
- Prefer deterministic parameters (Temperature/Top P) while iterating, then loosen if needed for creativity.
