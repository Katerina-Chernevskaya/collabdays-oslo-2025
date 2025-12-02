# LAB 15 — Connect tools into an Azure AI Foundry agent

*Augment your Azure AI Foundry agent with external tools for search, data, and actions.*

## 🤔 Why This Matters

Grounded data is great, but real-world agents also need to call APIs—search, databases, or business systems. Tools let your agent fetch fresh context or trigger actions while keeping instructions clean.

Common challenges solved by this lab:
- "My agent needs to look up live data." 
- "I want the agent to call business APIs without exposing secrets." 
- "How do I test tool calls safely before wiring them into apps?"

## 🌐 Introduction

You will extend the **Caffio Foundry Agent** with multiple tools: a web search connector, an Azure Function for inventory, and a Power Platform connector call. You will configure tool definitions, pass required parameters, and validate tool execution from the Playground before exposing the agent to other callers.

## 🎓 Core Concepts Overview

|Concept|Why it matters|
|--|--|
|Tool definitions|Describe available actions and required parameters for the agent.|
|Authentication|Managed identity, OAuth, or key-based auth keeps secrets out of prompts.|
|Execution review|Thread logs show when a tool was called and with what arguments.|
|Safety controls|Rate limits and allowlists prevent risky actions.|

## 📄 Documentation and Additional Training Links

- [Add tools to an AI Foundry agent](https://learn.microsoft.com/azure/ai-foundry/agents/how-to/tools)
- [Web search tool](https://learn.microsoft.com/azure/ai-foundry/agents/how-to/tools-web-search)
- [Call Power Platform connectors](https://learn.microsoft.com/azure/ai-foundry/agents/how-to/tools-power-platform)

## ✅ Prerequisites

- Completion of **LAB 12** (agent created) and **LAB 13** (HTTP trigger pattern) recommended.
- Access to create or reference an Azure Function and a Power Platform custom connector.
- Required credentials or managed identity permissions to call downstream services.

## 🎯 Summary of Targets

By the end of this lab you will:
- Add multiple tools to a Foundry agent (search, Azure Function, Power Platform connector).
- Configure authentication and parameters for each tool.
- Validate tool execution in Playground and inspect logs.

***

## 🛠️ Instructions

### Add a web search tool

1. Open the **Caffio Foundry Agent** → **Tools** → **+ Add tool** → **Web search**.
2. Configure scope:
   - Trusted domains: add coffee-related sites (e.g., `sprudge.com`, `perfectdailygrind.com`).
   - Max results: 3–5 to avoid noisy outputs.
   - Citation requirement: enabled.
3. Save and note that the tool is now available to the agent.

### Add an Azure Function tool

1. Choose **Custom HTTP** tool and provide:
   - **Name**: `getInventory`.
   - **Description**: "Returns current coffee bean inventory and roast dates." 
   - **HTTP method**: `GET`.
   - **URL**: your Azure Function endpoint (e.g., `https://<function>.azurewebsites.net/api/inventory`).
   - **Authentication**: 
     - If using a Function Key, store it in Azure Key Vault and reference via managed identity if available.
     - Prefer **Managed identity** if the Function is secured with Entra ID.
2. Define parameters (JSON schema) so the agent knows what it can send:
```
{
  "type": "object",
  "properties": {
    "sku": { "type": "string", "description": "Coffee SKU to check" },
    "location": { "type": "string", "description": "Warehouse or cafe location" }
  },
  "required": ["sku"]
}
```
3. Save the tool.

### Add a Power Platform connector tool

1. Select **Power Platform connector** → choose an existing connector or create one that wraps a Dataverse table or Power Automate flow.
2. Name the tool `logOrder` and set a description like "Create a roast order in Dataverse".
3. Map required parameters (e.g., `customerName`, `drink`, `size`).
4. Use **Managed identity** or **OAuth** depending on your connector security model.

### Test tools in Playground

1. Open **Try in Playground** for the agent.
2. Use prompts that should trigger tools:
   - "Use web search to find a trending pumpkin spice recipe and summarize it."
   - "Check SKU `ESP-01` at the Oslo cafe and tell me if we can fulfill 10 bags." (invokes `getInventory`).
   - "Create a roast order for Alex, flat white, medium size." (invokes `logOrder`).
3. After each run, open **Thread logs** → **Tool calls** to confirm:
   - Which tool executed.
   - Parameters sent.
   - Response payload returned to the agent.

### Apply safeguards

1. Set rate limits or throttling on your tools (Function app or connector side).
2. Update agent instructions to remind the model when to use or avoid tools, for example: "Use web search only when the answer is not in the knowledge base." 
3. If a tool fails, ensure the agent politely reports the issue and suggests a fallback.

***

## 🧾 Summary

You enhanced your Azure AI Foundry agent with multiple tools, including live search, serverless functions, and Power Platform connectors. The agent can now gather fresh context and perform actions while keeping security and observability intact.

## 🔑 Golden rules

- Prefer managed identity or OAuth over embedding keys in prompts.
- Provide clear parameter schemas so the agent calls tools correctly.
- Test tool calls in Playground before exposing them to users.
- Monitor tool responses and failures in thread logs to tune instructions.
