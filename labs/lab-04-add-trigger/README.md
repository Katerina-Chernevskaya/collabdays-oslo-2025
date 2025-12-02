# LAB 4 — Extract recipe from email newsletter

*Add an Outlook trigger that ingests newsletter emails and routes the body to your agent for recipe extraction.*

## 🤔 Why This Matters

Inbound automation converts passive content into actionable data with zero copy‑paste.

## 🌐 Introduction

Configure `When a new email arrives (V3)` to watch for a specific subject and pass the content to the agent with additional instructions. This sets the stage for unattended ingestion.

## 🎓 Core Concepts Overview

|Concept|Why it matters|
|--|--|
|Event‑driven triggers|Bring fresh data to the agent without manual steps.|
|Connector health|Green status avoids silent failures.|
|Targeted subject filters|Prevents noisy or irrelevant processing.|
|Trigger‑specific instructions|Tailor the agent’s behavior for this pathway.|

## 📄 Documentation and Additional Training Links

- [Event triggers overview](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-triggers-about)
- [Office 365 Outlook connector](https://learn.microsoft.com/en-us/connectors/office365/)
- [Email triggers in Power Automate - When a new email arrives (V3)](https://learn.microsoft.com/en-us/power-automate/email-triggers)

## ✅ Prerequisites

- Working agent from [Lab 1](../lab-1-create-agent/README.md) and [Lab 2](../lab-2-extend-knowledge/README.md).
- Office 365 Outlook connector available and authenticated.
- Permission to add Triggers in the agent.

## 🎯 Summary of Targets

- Create a trigger named Recipe from Newsletter with a subject filter.
- Provide concise additional instructions to extract the "recipe of the day".
- Validate end‑to‑end with a sample email.

***

## 🛠️ Instructions

1. On the agent **Overview** page, navigate to **Triggers** and select **Add trigger**.
2. Select **When a new email arrives (V3)** and **Next**.
![](../../assets/4-select-trigger.png)
3. Rename the trigger to `Recipe from Newsletter`.
4. Confirm that **Microsoft Copilot Studio** and **Office 365 Outlook** connectors show green status.
![](../../assets/4-configure-connections.png)
5. Select **Next**.
6. Configure:
   - **Subject Filter**: `Caffio Newsletter`
   - **Additional instructions to the agent when it’s invoked by this trigger**: `A new coffee newsletter has arrived — read it and extract the “recipe of the day” from Body`.
   ![](../../assets/4-configure-trigger.png)
7. Select **Create trigger**.
8. Close the testing pop‑up.
9. In Outlook, send yourself an email titled **Caffio Newsletter** with the following body:
```
☕ Coffee Horizons Newsletter
Fresh ideas brewed daily
Date: September 19, 2025
________________________________________
🌟 Recipe of the Day
Maple Pecan Latte 🍁
Ingredients (for 1 serving):
•	1 shot espresso (30 ml)
•	180 ml steamed milk
•	1 tbsp maple syrup
•	1 tbsp crushed pecans (plus a little extra for garnish)
•	Pinch of cinnamon
Steps:
1.	Brew a fresh shot of espresso.
2.	Stir maple syrup into the espresso until blended.
3.	Add steamed milk and mix gently.
4.	Sprinkle crushed pecans on top.
5.	Dust lightly with cinnamon.
Serving twist: Serve in a clear glass mug with a cinnamon stick stirrer for a cozy autumn look.
________________________________________
📖 Coffee Fun Fact
In Canada, maple syrup has been used as a natural sweetener for centuries — now it adds warmth and depth to seasonal lattes around the world.
```
10. Return to the agent, open **Triggers**, and select **Test trigger**.
11. Select the event and **Start testing**.
![](../../assets/4-test-trigger.png)
12. Review the trigger output in the **Test pane**.
![](../../assets/4-trigger-output.png)

***

**🏅 Congratulations! You’ve completed the Lab 4!**

## 📑 Summary of Learnings

- Triggers transform inbox noise into structured inputs.
- Clear, narrow instructions prevent over‑parsing.

## 🔑 Golden rules

- Keep subject filters specific.
- Document what the trigger injects into the agent.
- Fail safe: log when no recipe is found.
- Test with realistic newsletter formats.
- Disable the trigger when running unrelated tests.
