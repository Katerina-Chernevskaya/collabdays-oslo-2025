# LAB 10 — UX Evaluation

*Add lightweight memory, classify user turns, and send custom telemetry to Application Insights for observability.*

> Learn more about built-in Model Evaluation available n Azure AI Foundry in [this video](https://www.youtube.com/watch?v=cphCsX7KWNA) 

## 🤔 Why This Matters

If you can’t observe it, you can’t improve it. Telemetry turns anecdotes into evidence.

## 🌐 Introduction

You’ll initialize a conversation history variable, log both user and agent messages, run a classification prompt, and emit a customEvents record to App Insights. Then you’ll query the data with KQL.

## 🎓 Core Concepts Overview

|Concept|Why it matters|
|--|--|
|Lightweight memory|Preserves context without heavy persistence.|
|Turn classification|Enables routing, analytics, and intent insights.|
|Custom telemetry|Bridges Copilot Studio with operational analytics.|
|KQL dashboards|Turns raw events into actionable views.|

## 📄 Documentation and Additional Training Links

- [Application Insights telemetry with Copilot Studio (guidance)](https://learn.microsoft.com/en-us/dynamics365/guidance/resources/copilot-studio-appinsights)
- [Variables overview](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-variables-about)
- [Work with variables](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-variables)
- [Power Fx reference — Table](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-table)
- [Power Fx reference — Concat](https://learn.microsoft.com/en-us/power-platform/power-fx/reference/function-concatenate)

## ✅ Prerequisites

- Application Insights resource and connection string.
- Permission to edit Advanced settings in the agent.
- Ability to create topics and prompts.

## 🎯 Summary of Targets

- Seed a history table at Conversation Start.
- Append user and agent turns to history.
- Classify the last user message and log the JSON result as a custom event.
- Run the provided KQL to view structured insights.

***

## 🛠️ Instructions

### Initialize the history variable (agent memory)

1. Open your Agent.
2. Open the **Conversation Start** topic.
3. Add **Set variable value** at the end.
4. Create a **global variable** `history` and set the value to:
```
Table(
    {
        id: 1,
        role: "agent",
        msg: "Hello, I'm " & System.Bot.Name & ", a virtual assistant. Just so you are aware, I sometimes use AI to answer your questions. If you provided a website during creation, try asking me about it! Next try giving me some more knowledge by setting up generative AI."
    }
)
```
5. **Save** the topic.

### Append AI‑generated messages
    
1. Create a topic `On AI response generated`.
2. Change trigger to `AI response generated`.
3. Add **Set variable value** and set `Global.history` to:
```
Table(
    Global.history,
    {
        id: Last(Global.history).id+1,
        role: "agent",
        msg: System.Response.FormattedText
    }
)
```
4. **Save** the topic.

### Append user messages
1. Create a topic `On msg received`.
2. Change trigger to `A message is received`.
3. Add **Set variable value** and set `Global.history` to:
```
Table(
    Global.history,
    {
        id: Last(Global.history).id+1,
        role: "user",
        msg: System.Activity.Text
    }
)
```
4. Add a **Prompt** node with the following instructions exactly:
```
You are a classifier for chatbot conversations. 
Your only task: classify the LAST USER message in the conversation history into EXACTLY ONE category.
Use the full context of the conversation to decide.

Categories (mutually exclusive):

- NEW_TOPIC — a new question or intent unrelated to the previous turn. Supports multi-topic bursts (several unrelated mini-questions in one message).
- CLARIFICATION — a follow-up where the user asks for more detail about the current topic or the agent’s previous answer.
- DATA_PROVIDED — the user supplies requested information or fields. Supports partial vs. complete payloads.
- ACTION_REQUEST — an explicit instruction to perform an action (refund, cancel, connect to human, etc.).
- COMPLAINT_ESCALATION — dissatisfaction, objection, or a demand for escalation/human handoff.
- OFFSCOPE_EXPLORATION — boundary testing, playful, or irrelevant questions not tied to the service.
- ACK_OR_CLOSURE — short acknowledgments or explicit closure (e.g. “Thanks,” “That’s all,” “Goodbye”).

Subtypes (optional):
- multi_topic → for NEW_TOPIC when multiple unrelated mini-questions are asked at once.
- partial → for DATA_PROVIDED when the payload is incomplete.
- complete → for DATA_PROVIDED when all required fields are present.

Output format:
Return ONLY a single valid JSON object with this schema:

{
    "activity": "<one category>",
    "activity_subtype": "<subtype or null>",
    "confidence": <float between 0 and 1>,
    "is_topic_switch": <true or false>,
    "rationale": "<one short neutral sentence>"
}

Conversation so far:
<chat_history>

Classify ONLY the last USER message.
```
5. Change model to `GPT‑4.1`. **Test** and **Save**.
6. For **input**, use:
```
Concat(
Global.history,
id & ") " & role & ": " & msg & Char(10)
)
```
7. For **output**, create `classification` variable.
8. Add **Log custom telemetry event** with **Event name** = `msg_classification_info` and **Properties** = `classification`.
9. **Save** the topic.

### Connect Copilot Studio to Application Insights

1. If you deployed via Bicep in [Lab 6](../lab-6-deploy-azure-resources/README.md), skip this. Otherwise, create an **Application Insights** resource in **Sweden Central**.
2. In Application Insights, copy the **Connection string** from **Overview**.
3. In your agent **Settings** → **Advanced**, expand **Application Insights** and paste the connection string.
4. **Save** and **Publish** agent.


## Test the agent
1. Chat flow:
    - `please provide a recipe for the Birthday`
    - `do you have another recipe?`
    - `read my destiny in coffee`
2. Inspect intent classifications:
    - Open **Application Insights** → **Logs**.
    - Query **customEvents** and expand **msg_classification_info** events.
3. Switch to **KQL mode** and run the following query to produce an analyzable table:
```
// Last 3 days
customEvents
| where timestamp > ago(72h)
// structuredOutput as JSON-строка in customDimensions
| extend dims = customDimensions
| extend so   = parse_json(tostring(dims["text"]))
// IDs
| extend conversationId = tostring(dims["conversationId"])
        , sessionId      = tostring(session_Id)              
        , channelId      = tostring(dims["channelId"])
// Fields from structuredOutput
| extend activity        = tostring(so.activity)
        , activity_subtype= iif(isnull(so.activity_subtype) or so.activity_subtype=="", tostring(so["activity_subtype"]), tostring(so.activity_subtype))
        , confidence      = todouble(so.confidence)
        , is_topic_switch = tobool(so["is_topic_switch"])
        , rationale       = tostring(so.rationale)
// Tokens
| extend promptTokens     = tolong(todouble(dims["promptTokens"]))
        , completionTokens = tolong(todouble(dims["completionTokens"]))
        , totalTokens      = tolong(todouble(dims["totalTokens"]))
// Calculate if no completion token
| extend completionTokens = iif(isnull(completionTokens) and not(isnull(totalTokens)) and not(isnull(promptTokens)),
                                totalTokens - promptTokens, completionTokens)
// Filter
| where isnotempty(activity)
// Flat table
| project
    Timestamp = timestamp,
    conversationId,
    sessionId,
    channelId,
    activity,
    activity_subtype,
    confidence,
    is_topic_switch,
    rationale,
    promptTokens,
    completionTokens,
    totalTokens
| order by Timestamp asc
```
4. Export as **CSV** or connect to **Power BI** as needed.

***

**🏅 Congratulations! You’ve completed the Lab 10!**

## 📑 Summary of Learnings

- Memory plus telemetry enables iterative UX improvements.
- KQL is your lens on agent behavior at scale.

## 🔑 Golden rules

- Log less but better: capture structured JSON, not prose.
- Keep IDs consistent across sessions and channels.
- Fail classification gracefully; don’t block replies.
- Start with a few key metrics, then expand.
- Review telemetry weekly and tune prompts accordingly.