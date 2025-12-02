# LAB 13 — Connect Azure AI Foundry agent to Copilot Studio

*Expose your Azure AI Foundry agent through a secure HTTP trigger and consume it from a Copilot Studio topic.*

## 🤔 Why This Matters

Copilot Studio becomes more powerful when it can call specialized agents. By fronting your Azure AI Foundry agent with a callable endpoint, you keep conversational logic in Copilot Studio while offloading deep reasoning to a reusable service.

Common challenges solved by this lab:
- "How do I let Copilot Studio talk to a Foundry agent?"
- "What’s the cleanest way to secure the call?"
- "How do I return structured data back into the topic flow?"

## 🌐 Introduction

You will expose the **Caffio Foundry Agent** via a Logic Apps HTTP trigger (using managed identity) and call it from a Copilot Studio topic. The flow creates a thread, starts a run with the user’s prompt, polls for completion, and returns structured JSON so the Copilot topic can display the agent’s answer.

## 🎓 Core Concepts Overview

|Concept|Why it matters|
|--|--|
|Logic Apps HTTP trigger|Provides a secure, callable surface for Copilot Studio.|
|Managed Identity + RBAC|Removes secrets and limits permissions to the AI project.|
|Thread + Run pattern|Ensures each conversation stays scoped while calling the agent.|
|Copilot Studio HTTP node|Bridges the topic flow to external systems and maps outputs to variables.|

## 📄 Documentation and Additional Training Links

- [Trigger an agent using Logic Apps (Preview)](https://learn.microsoft.com/azure/ai-foundry/agents/how-to/triggers)
- [Copilot Studio HTTP request node](https://learn.microsoft.com/microsoft-copilot-studio/advanced-topic-handling-http)

## ✅ Prerequisites

- Completion of **LAB 12** with the **Caffio Foundry Agent** created.
- Permission to create Logic Apps (Consumption) and enable system-assigned managed identity.
- Permission to add topics in Copilot Studio and use HTTP request nodes.

## 🎯 Summary of Targets

By the end of this lab you will:
- Deploy a Logic App trigger that can call your Foundry agent securely.
- Map the Logic App response into a Copilot Studio topic.
- Validate end-to-end conversation from Copilot Studio through Foundry and back.

***

## 🛠️ Instructions

### Deploy the Logic App trigger

1. In the Azure AI Foundry agent Playground, select **Create trigger** → **Consumption** plan for Logic Apps.
2. Configure the deployment:
   - Subscription and new resource group.
   - Name: `la-caffio-agent` (or similar).
   - Region: close to your AI project (e.g., `Sweden Central`).
   - Enable **System assigned** managed identity and **Log Analytics** if available.
3. After deployment, open the Logic App resource → **Identity** → enable **System assigned**.
4. In the Azure portal, navigate to your AI Foundry project → **Access control (IAM)** → **Add role assignment**.
   - Role: **Azure AI Project Manager**.
   - Assign to: the Logic App’s managed identity.
5. Open **Logic app designer** and add a trigger **When an HTTP request is received** with this schema:
```
{
  "type": "object",
  "properties": {
    "message": { "type": "string" },
    "thread_id": { "type": "string" }
  }
}
```
6. Save to generate the callback URL.

### Call the agent from the Logic App

1. Add **Create Thread** action using the AI project endpoint (same as in LAB 11 if completed).
2. Add **Create Run** action:
   - **Thread ID**: output of **Create Thread** (or incoming `thread_id` when provided).
   - **Agent ID**: ID of your `Caffio Foundry Agent`.
   - **Additional_messages** (entire array):
```
[
  {
    "role": "user",
    "content": @{triggerBody()?['message']}
  }
]
```
3. Add **Delay** for 30–60 seconds.
4. Add **List Messages** for the thread and capture the latest assistant reply.
5. Add **Response** action with body:
```
{
  "response": "@{body('List_Messages')['data'][0]['content'][0]['text']['value']}",
  "thread_id": "@{outputs('Create_Thread')?['id'] ?? triggerBody()?['thread_id']}"
}
```
6. Save the workflow.

### Connect from Copilot Studio

1. Open your Copilot Studio agent → **Topics** → **New topic** called `Foundry bridge`.
2. Add trigger phrases such as: `Ask Foundry for help`, `Send to Caffio Foundry Agent`.
3. Add **Ask a question** node:
   - Message: "What should I ask the Foundry agent?"
   - Identify: `User's entire response` → variable `foundry_prompt`.
4. Add **HTTP Request** node:
   - **URL**: Logic App trigger URL.
   - **Method**: `POST`.
   - **Body** (JSON content → Edit formula):
```
{
  message: Topic.foundry_prompt
}
```
   - **Request timeout**: `70000` ms.
   - **Get schema from sample JSON**:
```
{
  "response": "string",
  "thread_id": "string"
}
```
   - Save as variable `foundry_result`.
5. Add **Message** node to show `Topic.foundry_result.response` to the user.
6. Save and test the topic in the **Test bot** pane.

***

## 🧾 Summary

You connected Copilot Studio to your Azure AI Foundry agent through a secure Logic App trigger, enabling reusable deep reasoning without embedding secrets in the topic.

## 🔑 Golden rules

- Use managed identities instead of static keys for cross-service calls.
- Return structured JSON (`response`, `thread_id`) to keep topics maintainable.
- Keep delays minimal; adjust based on model latency.
- Monitor Logic App run history when debugging Copilot flows.
