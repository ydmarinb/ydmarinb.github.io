---
layout: default
title: Advanced Prompt Engineering Techniques
description: What are key techniques for effective prompt engineering?
---



A detailed but short guide on the different prompt engineer techniques and how to use them.

## 1. Zero-Shot Prompts
This approach involves presenting a task or question to the AI model without any prior examples or context. The model relies on its pre-existing knowledge and training to respond.

```markdown
Question: What is the capital of France?
```

## 2. Few-Shot Prompts
A few examples are provided to the AI model before presenting the actual task, helping the model understand the desired output or style of response.

```markdown
Example 1: 2 + 2 = 4
Example 2: 5 + 3 = 8
Question: 7 + 1 = ?
```

## 3. Chain of Thought (CoT) Prompting
This technique involves breaking down a problem into manageable parts and addressing them step-by-step before providing a final answer, similar to human problem-solving.

```markdown
Question: "If a cake recipe for 4 people requires 2 eggs, how many eggs do I need for 6 people?"
Response: "First, calculate the eggs per person by dividing 2 eggs by 4 people. Then, multiply that by 6 people."
```

## 4. Self Consistency
Involves running the same prompt multiple times with different outputs and selecting the most coherent or common response.

```markdown
Question: "What is the boiling point of water?"
Responses: "100°C", "100°C", "99°C." The most consistent answer is "100°C."
```

## 5. General Knowledge Prompting
Augmenting prompts with additional general knowledge to enhance the AI's response.

```markdown
Question: "Considering the economic recession, what are some viable investment strategies?"
```

## 6. ReAct (Reasoning + Act)
Alternates between generating reasoning and task-specific actions until a final answer is reached.

```markdown
Question: "How should we respond to a customer complaint about a faulty product?"
Response: "First, verify the customer's purchase. Then, offer a replacement or refund."
```

## 7. Data Extraction
Creating prompts to guide AI models to extract specific data or information from a given input.

```markdown
Question: "Extract all dates mentioned in this paragraph."
Paragraph: "The Treaty of Versailles was signed on June 28, 1919."
```

## 8. Creative Writing
Formulating prompts that encourage imaginative and original content creation.

```markdown
Task: "Write a short poem about the ocean."
```

## 9. Extension of Context
Adding detailed background or contextual information to a prompt to generate more specific and relevant responses.

```markdown
Question: "Given that global warming is accelerating, what are some innovative green technologies?"
```

## 10. Focused Content Analysis
Crafting prompts that direct AI models to analyze specific aspects or elements within a larger content set.

```markdown
Question: "Analyze the impact of social media on teenage mental health."
```

## 11. Filling Out the Template
Using a predefined structure for prompts where specific information is filled in.

```markdown
Template for a Book Review:
Title: [Book Title]
Author: [Author]
Synopsis: [Brief Synopsis]
Personal Opinion: [Your Opinion]
```

## 12. Prompt Reframing
Altering or rephrasing an existing prompt to better suit the requirements or to yield more effective results.

```markdown
Original Prompt: "Describe climate change."
Reframed Prompt: "Explain the impact of human activities on climate change and potential solutions."
```

## 13. Prompt Combination
Merging multiple queries or instructions into a single, cohesive prompt.

```markdown
Combined Prompt: "Considering current health trends and dietary preferences, suggest a concept for a new health food product."
```
## 14. Iterative Prompting
Refining the initial prompt based on the responses received.

```markdown
First Prompt: "What are the latest trends in renewable energy?"
Following Prompt (based on response): "How can solar power be integrated into these trends?"
```

## 15. Interactive Storytelling and Role-Playing
Creating scenarios where users or AI models assume specific roles or characters within a narrative.

```markdown
Scenario: "You are a detective in a mystery novel. Describe your nextstep in solving the case."
```

## 16. Giving Implicit Information
Incorporating subtle underlying messages or context into prompts without stating them explicitly.

```markdown
Implicit Prompt: "Discuss the potential consequences of unchecked urban expansion."
```

## 17. Nuanced Language Translation
Crafting prompts to guide AI models to translate text while preserving original context, cultural nuances, and subtleties.

```markdown
Translation Prompt: "Translate 'La dolce vita' while maintaining its cultural connotations."
```

## 18. Automatic Prompt Engineer
Using tools or methods that automatically generate effective prompts for interacting with advanced models.

```markdown
Automatic Prompting Tool: Generate a prompt for an article about the benefits of yoga.
Generated Prompt: "List five key benefits of practicing yoga daily."
```

# Sources

* https://www.promptingguide.ai/techniques
* https://www.mlq.ai/prompt-engineering-advanced-techniques/







