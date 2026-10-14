---
name: unslop
description: Remove AI-writing tells from prose while keeping the author's meaning and voice. Use when writing or editing docs, READMEs, PR descriptions, commit messages, emails, messages, or any prose a person will read.
---

# Unslop

Write prose that sounds like a specific person with a point. Write it clean as you draft. A cleanup pass afterward misses most of these. Keep the author's meaning, tone, technical terms, humor, and formality. The goal is intentional writing, not bland writing.

## Punctuation and format

1. No em dashes or en dashes used as dashes. End the sentence or use a comma.
2. A colon goes before a list or an example, not as a connector in the middle of a sentence.
3. Fold parenthetical asides into the sentence or cut them. Don't swap dashes for parentheses.
4. Bold only what a reader needs to find. A bold label that restates its own line ("**Performance:** Performance improved") becomes plain prose.
5. Sentence-case headings, straight quotes, no decorative emoji.

## Words

6. Plain words: use, help, many, if, start, is, has. Not utilize, leverage, facilitate, numerous, in the event that, commence, serves as, stands as, boasts.
7. Watch the model's favorites when they're filler: additionally, crucial, delve, enhance, fostering, garner, intricate, landscape, pivotal, robust, seamless, showcase, tapestry, testament, underscore, vibrant.
8. Concrete nouns over technical-sounding metaphors: base not substrate, way not vector, add not wedge in, last phase not endgame. Keep jargon that is the actual technical term.
9. One name per thing. Don't rotate synonyms to avoid repetition.
10. Cut adverbs propping up weak verbs. "Runs quickly" becomes the number. "Significantly improves" becomes the measured change.
11. Delete filler: "it is important to note that", "in order to", "due to the fact that". Collapse stacked hedges to the real level of doubt.

## Sentences

12. Say what it does, not how it feels. "A column rename fails the build" beats "types that follow your schema". If a sentence could sit unchanged in another project's docs, it says nothing about this one.
13. Active voice with a named actor, unless the actor truly doesn't matter.
14. One idea per sentence when a sentence gets hard to parse. Vary length otherwise.
15. Write whole sentences. No arrows, dropped articles, or verbless fragments the reader has to decode.
16. Skip these shapes: "not just X, but Y", forced groups of three, "from X to Y" when X and Y aren't a range, trailing "-ing" phrases (highlighting, ensuring, reflecting), "despite challenges, X continues to thrive".
17. Name sources. "Experts believe" and "some argue" get a real source or get cut.

## Structure

18. Start with the useful information. No restating the prompt, no "here's why this matters" paragraph.
19. End on the decision, plan, or fact. No summary of what was just said, no "the future looks bright".
20. No chatbot lines: "Great question", "You're absolutely right", "I hope this helps", "Let me know if".
21. Let paragraphs be different shapes. Uniform symmetry reads generated.

## Final read

Read the result once without looking at the original and ask what still sounds generated. Fix that. Then check you didn't add opinions, certainty, or emotion the author didn't have.
