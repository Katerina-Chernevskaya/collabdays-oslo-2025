# LAB 5 — Intercept "AI‑generated response" and post‑process

*Create a topic that halts auto‑send, extracts the first recipe from the AI response, and returns an aggregated message with a shopping list.*

## 🤔 Why This Matters

Interception gives you editorial control. You can enrich or sanitize before users see the message.

## 🌐 Introduction

You’ll switch the topic trigger to An AI‑generated response is about to be sent, set System.ContinueResponse = false, run a Prompt to extract ingredients, and compose a final message.

## 🎓 Core Concepts Overview

|Concept|Why it matters|
|--|--|
|Pre‑send interception|Prevents premature delivery of raw outputs.|
|System variables|Fine‑grained control of send/continue behavior.|
|Structured parsing prompt|Converts free‑form text into actionable lists.|
|Aggregated messaging|Combines original content with value‑add artifacts.|

## 📄 Documentation and Additional Training Links

- [Variables overview](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-variables-about)
- [Work with variables](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-variables)
- [Orchestrate agent behavior with generative AI](https://learn.microsoft.com/en-us/microsoft-copilot-studio/advanced-generative-actions)

## ✅ Prerequisites

- [Lab 3](../lab-3-create-tool/README.md) tool available or equivalent extraction prompt.
- Permission to create Topics and modify triggers.

## 🎯 Summary of Targets

- Create a topic that intercepts the AI response.
- Populate an input variable with Response.FormattedText.
- Produce a clean ingredient list into shopping_list and send a single, aggregated message.

***

## 🛠️ Instructions

1. Create a new topic: in your Agent navigate to **Topics**, select **Add a topic** -> **From blank**.
2. Hover near the topic trigger name, select the double arrows, and choose **An AI‑generated response is about to be sent**.
![Change trigger](../../assets/5-change-trigger.png)
3. Prevent immediate sending:
   - Add **Set variable value** node.
   - Select variable `System.ContinueResponse`.
   - Set value to `false`.
4. Add a new node **Tool** of type **Prompt**.
5. In the prompt configuration:
   - **Name**: `extract recipe`.
   - **Model**: `GPT‑4.1`.
   - **Instructions**:
    ```
    You are a shopping list extractor. Input is a full assistant message that may include multiple recipes, emojis, bullets, and commentary.
    Task: extract ingredients ONLY from the FIRST complete coffee recipe. Output must be a formatted list with bullets, one ingredient per line. Do not include steps, serving twists, metadata, or commentary.
    Normalization rules:
    - Remove emojis and decorative symbols.
    - Keep ingredient names clean.
    - “1 shot espresso” → “30 ml espresso”.
    - “1 cup milk” (liquid) → “240 ml milk”.
    - If quantity or unit is missing, list the ingredient without inventing numbers.
    - Merge duplicates.
    - Final result = only the shopping list.
    Assistant input (verbatim user‑visible content to parse): <ai_response>
    Output: return only the shopping list as formatted text.
    ```
   - Replace `<ai_response>` with a **Text** variable (insert via /).
   - Add the following sample text to variable:
   ```
    Here are two festive coffee recipes perfect for the holiday season, each with a unique twist and easy-to-follow steps:
        
    1. Santa’s Cookie Latte
    Ingredients:
    
    1 shot espresso
    200 ml steamed milk
    1 tbsp vanilla syrup
    Whipped cream
    Christmas cookie
    Preparation Steps:
    
    Combine the espresso and vanilla syrup in your cup.
    Add the steamed milk and stir gently.
    Top with a generous swirl of whipped cream.
    For a festive touch, place half a Christmas cookie into the cream.
    Serving Twist: Garnish with the cookie for a delightful holiday treat.
    
    2. Gingerbread House Cappuccino
    Ingredients:
    
    1 shot espresso
    Steamed milk
    Gingerbread syrup
    Mini gingerbread man
    Preparation Steps:
    
    Prepare a classic cappuccino with espresso and steamed milk.
    Mix in gingerbread syrup to taste.
    Place a mini gingerbread man on the rim of the cup.
    Dust with nutmeg for extra warmth.
    Serving Twist: Decorate with a gingerbread man and a sprinkle of nutmeg for a cozy, spiced aroma.
    
    These recipes are sure to bring holiday cheer to your coffee moments!
    
    Now, I'll prepare a shopping list for you.
   ```
   - Select **Test** to confirm the extracted list appears in the right pane.
   ![Test prompt](../../assets/5-test-prompt.png)
   - **Save** the prompt.
6. In the Prompt node, set variables:
   - Map **ai_response** to `Response.FormattedText` (system variable).
   - For **predictionOutput**, create a new variable `shopping_list`.
   ![Prompt node](../../assets/5-prompt-node.png)
7. Add a **Message** node to send an aggregated response (AI recipes + extracted shopping list).
8. Rename the topic to `shopping_list` and **Save**.
9. Start a new conversation and test with: `I want a yummy christmass recipe`. Expect a single message containing the recipes and the extracted shopping list.

## (Homework) Replace text message with Adaptive card

1. Explore [here](https://adaptivecards.io/samples/) Adaptive card samples and select one.
2. In the Topic add a new node **Message** and add to the Message **Adaptive card**.
![Add Adaptive card](../../assets/5-add-adaptive-card.png)
3. Click **Edit Adaptive Card**. Replace JSON in the field **Card payload editor** with the JSON from the sample you've selected (from the **Template JSON** field). Adjust the copied JSON according to your needs and click **Save** -> **Close**.

You can also copy the following simple JSON:
```
{
    "type": "AdaptiveCard",
    "body": [
        {
            "type": "TextBlock",
            "text": "${recipe}",
            "wrap": true
        },
        {
            "type": "TextBlock",
            "text": "${shopping_list}",
            "wrap": true
        }
    ],
    "$schema": "https://adaptivecards.io/schemas/adaptive-card.json",
    "version": "1.5"
}
```

4. In **Adaptive Card Property** switch to the **Formula**.
![Switch from JSON to Formula](../../assets/5-switch-to-formula.png)
5. Add variables `System.Response.FormattedText` and `Topic.shopping_list.text` to Adaptive card.
![Add variables to adaptive card](../../assets/5-add-var-to-adaptive-card.png)
6. Save Topic and test it.
![Test topic](../../assets/5-test-card.png)

***

**🏅 Congratulations! You’ve completed the Lab 5!**

## 📑 Summary of Learnings

- Interception enables quality gates and value‑add steps.
- System variables are your circuit breakers.

## 🔑 Golden rules

- Stop the send before you transform.
- Keep parsing prompts strict and observable.
- Pass only the required text into the tool.
- Return one consolidated message to avoid spam.
- Log all transformations for traceability.
