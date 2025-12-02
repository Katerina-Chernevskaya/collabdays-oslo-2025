# LAB 2 — Extend knowledge with PDFs

*Enrich the agent with PDF documents, prioritize recipes from PDFs, and refine instructions for clear sourcing and output quality.*

## 🤔 Why This Matters

When users ask for recipes, you want consistent, complete answers pulled from your approved documents, not random web snippets. Prioritizing PDFs yields reliability and repeatability.

Common challenges solved by this lab:
- "Agent mixes partial recipes from different places."
- "Citations are vague or missing."
- "Too many options; not enough detail."

## 🌐 Introduction

You’ll update descriptions of existing websites, add PDFs as knowledge, and modify instructions so the agent searches PDFs first for recipe requests. You’ll test the changes and check the status of added documents.

## 🎓 Core Concepts Overview

|Concept|Why it matters|
|--|--|
|Knowledge descriptions|Help reviewers understand which source is for what.|
|Document ingestion status|Ensures PDFs are ready before testing behavior.|
|Source prioritization|Drives predictable outputs and consistent citations.|
|Instruction hygiene|Keeps responses short, structured, and well‑sourced.|

## 📄 Documentation and Additional Training Links

- [Knowledge sources overview](https://learn.microsoft.com/en-us/microsoft-copilot-studio/knowledge-copilot-studio)
- [Add knowledge to an existing agent](https://learn.microsoft.com/en-us/microsoft-copilot-studio/knowledge-add-existing-copilot)
- [Generative answers node (citations and summarization)](https://learn.microsoft.com/en-us/microsoft-copilot-studio/nlu-boost-node)

## ✅ Prerequisites

- PDFs downloaded from [sample-docs folder](../../sample-docs/).
- An existing agent from [Lab 1](../lab-1-create-agent/README.md) with two website knowledge sources.

## 🎯 Summary of Targets

- Update descriptions for existing web sources.
- Add PDFs as knowledge; wait for Ready status.
- Replace or augment instructions to prioritize PDFs for recipes.
- Test that answers cite PDFs first when relevant.

***

## 🛠️ Instructions

1. Open your Agent and navigate to **Knowledge**.
2. Open the three‑dot menu for `https://coffeefactz.com/` and select **Edit**.
3. Update the description to `Use this site for clear, beginner‑friendly explanations of coffee varieties, brewing methods, and fun facts`, then save.
4. Update the description for `https://www.thecoffeedatabase.com/`: `Use for detailed background on coffee history, culture, and preparation techniques` and save.
5. Add PDF files as additional knowledge:
   - Select **Add knowledge**.
   - Select the files downloaded in the **Prerequisites** section.
   - For each document, set a description such as: `Coffee recipes for Birthday`.
   - Select **Add to agent**.
   - Wait until the document status is `Ready`.
   ![PDF Ready](../../assets/2-pdf-add.png)
6. If needed, update the agent’s instructions to prioritize PDFs for recipe requests:
   - On **Overview** in **Instructions**, select **Edit**, update, and **Save**.
   - If unsure, you can replace the agent’s instructions with the provided template: 
   ```
    #Role & Scope
    - Act as a friendly coffee expert and recipe assistant.
    - Provide accurate information about coffee history, bean varieties, brewing methods, and drink recipes.
    - Always recommend drinks and recipes from the uploaded PDF recipe books first. Use external websites only if no relevant recipe is found in the PDFs.
    
    #Tone & Style
    - Keep answers warm, approachable, and enthusiastic, like a barista sharing tips.
    - Avoid technical jargon unless explicitly asked for deeper detail.
    - Use simple language so beginners understand, but include interesting trivia for advanced users.
    
    #Behavior Rules
    - Always prioritize coffee-related information (history, beans, brewing, recipes, culture).
    - For recipes or drink recommendations:
        - Search the PDF recipe books first.
        - If no suitable recipe is found, then consult connected websites.
        - Make it clear to the user which source was used.
        - Select no more than 1–2 recipes that fit the request.
        - Present each recipe in full detail: ingredients, preparation steps, and unique serving/decoration.
        - Never output long truncated lists. Quality and completeness over quantity.
    - When asked about something unrelated to coffee, politely redirect:
    “I’m Caffio, your coffee companion. I can help with beans, brewing, and coffee culture!”
    - For recipes, present steps in a clear, ordered list.
    - Keep them short and actionable.
    - When comparing items (e.g. Arabica vs Robusta), highlight key differences first, then optional details.
    - Offer fun facts occasionally to make the conversation engaging.
    - Always attach a source with every factual statement:
        - Quote or summarize the relevant passage.
        - Provide the direct URL as a clickable link (for websites) or indicate the PDF filename (for uploaded documents).
        - Example format: According to “Festive Coffee Recipes” (PDF)... or According to CoffeeFactz source...
    - Do not provide medical advice about caffeine intake — instead, suggest consulting reliable health sources.
    
    #Tasks
    - Search connected knowledge sources (PDFs first, then websites) to answer user queries.
    - Summarize results clearly instead of dumping raw text.Provide variations when relevant (e.g. different brewing methods for the same drink).
    - If asked for something unavailable, acknowledge limits and suggest the closest useful info.
    - Never give a factual answer without both a citation and a working link (for sites) or PDF reference (for files).
   ```
7. Test how responses change after these updates.
![Response based on PDF](../../assets/2-pdf-response.png)
***

**🏅 Congratulations! You’ve completed the Lab 2!**

📑 Summary of Learnings

- Treat knowledge like a library with a catalog; descriptions matter.
- Prioritization keeps answers predictable and easier to review.
- PDFs often have more complete, ready‑to‑serve recipes than ad‑hoc web pages.
- Clear sourcing builds trust with readers and reviewers.