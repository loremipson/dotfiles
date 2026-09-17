---
name: unslop
description: Remove recognizable AI-writing patterns from drafts, rewrites, documentation, messages, and other prose while preserving the author's meaning, intent, voice, and appropriate level of formality. Use whenever generating or editing prose where natural, specific, human-sounding language matters.
---

# Unslop

Edit writing to remove AI patterns and make it sound like a person wrote it.

Preserve the author's meaning, intent, tone, technical accuracy, and level of formality. Do not replace a distinctive human voice with a generic "natural" voice.

The goal is not to make writing casual. The goal is to make it sound intentional.

## Process

Scan for the patterns below.

Rewrite the affected passages rather than mechanically replacing individual words. Preserve useful detail and specificity.

Then read the result as a skeptical human reader and ask:

> What, if anything, makes this sound AI-written?

Fix those things.

Do not add personality, opinions, humor, informality, or first-person language unless the context or author's existing voice calls for them.

## The deslopped effect

Prefer specific statements over polished generalities.

Vary sentence length and rhythm naturally. Do not force every paragraph into the same structure.

Use first person when it accurately reflects the author's perspective. Do not avoid "I" merely because it sounds less formal.

Allow some asymmetry. Human writing does not need every paragraph, sentence, or list to have the same shape.

Prefer concrete observations over abstract reactions.

Instead of:

> This is concerning.

write:

> This lets the worker retry a non-idempotent request three times.

Do not manufacture opinions or emotions that the original does not contain.

## Preserve intent and voice

Do not rewrite simply because a phrase is sophisticated, unusual, informal, or personal.

A word is not "AI-sounding" merely because a model sometimes uses it.

Preserve:

- Deliberate technical terminology.
- Domain-specific vocabulary.
- Personal expressions.
- Humor and personality.
- Intentional repetition.
- Appropriate formality.
- Distinctive sentence structure when it contributes to the author's voice.

Change wording when it is generic, inflated, repetitive, evasive, or needlessly abstract.

## Content

### Cut puffery

Remove phrases that add importance without information:

- "pivotal moment"
- "testament to"
- "evolving landscape"
- "setting the stage for"
- "indelible mark"
- "deeply rooted"

State what happened instead.

### Avoid empty name-dropping

Do not list publications, companies, experts, or organizations merely to imply credibility.

If a source matters, explain what it actually said or did.

Name the relevant source rather than writing:

> Experts believe...

### Remove superficial "-ing" phrases

Watch for phrases such as:

- highlighting...
- ensuring...
- reflecting...
- showcasing...
- fostering...

Especially when they are attached to the end of a sentence without adding information.

Delete them or replace them with the concrete fact they are supposed to convey.

### Cut promotional language

Avoid promotional adjectives in descriptive or technical writing:

- vibrant
- breathtaking
- groundbreaking
- renowned
- stunning
- must-visit
- nestled

Describe the thing itself.

### Make attribution specific

Avoid vague attribution:

> Experts believe...

> Industry reports suggest...

> Some critics argue...

Name the person, organization, study, or source when the attribution matters. Otherwise remove the unsupported claim.

### Avoid fake narrative arcs

Do not use shapes such as:

> Despite challenges, X continues to thrive.

> As the industry evolves...

> This marks a pivotal moment...

State the actual event, change, or result.

## Language

Watch for vocabulary models overuse:

- additionally
- crucial
- delve
- enduring
- enhance
- fostering
- garner
- interplay
- intricate
- landscape
- pivotal
- showcase
- tapestry
- testament
- underscore
- vibrant

These words are not forbidden. Replace them when they are functioning as generic filler or elevated substitutes for a simpler word.

Prefer:

> is

over:

> serves as  
> stands as  
> boasts  
> features

when "is" or "has" is what the sentence means.

### Avoid formulaic contrast

Do not default to:

> not just X, but Y

State the important point directly.

### Avoid forced rule-of-three structure

Do not automatically group ideas into three examples, three clauses, or three adjectives.

Use as many as the content actually requires.

### Avoid synonym cycling

Do not rotate between synonyms merely to avoid repetition.

If a person is the protagonist, main character, central figure, and hero throughout the same passage, pick the appropriate term and use it.

### Avoid false ranges

Do not use:

> from X to Y

unless X and Y represent a meaningful range.

Otherwise, list the actual things being discussed.

## Style

### Avoid em dashes

Do not use em dashes.

Prefer periods or commas. Split the sentence when necessary.

### Avoid parentheses

Avoid parenthetical asides when the information belongs in the sentence itself.

Do not replace every em dash with parentheses. Rewrite the sentence.

### Use colons deliberately

Colons are useful before lists and examples.

Do not use them as a decorative substitute for a normal sentence connection.

### Avoid ornamental formatting

Do not bold every proper noun, acronym, product name, or technical term.

Use emphasis when it communicates structure or meaning.

Avoid inline-header constructions that merely restate the following sentence:

> **Performance:** Performance improved...

A concise lead-in can work when it introduces genuinely new information:

> **Schema in TypeScript.** Tables live in one file.

### Use sentence-case headings

Prefer:

> ## Review process

over:

> ## Review Process

Do not add decorative emoji to headings or bullets.

Use straight quotes rather than curly quotes.

## Communication artifacts

Remove chatbot filler:

- "I hope this helps!"
- "Let me know if..."
- "Of course!"
- "Certainly!"
- "Great question!"
- "You're absolutely right!"
- "Found the smoking gun!"

Do not add throat-clearing before answering.

Start with the useful information.

Remove unnecessary capability disclaimers such as:

> While specific details are limited...

Either find the relevant detail or state the actual limitation plainly.

Do not use sycophantic agreement as filler.

## Filler

Prefer:

> to

over:

> in order to

Prefer:

> because

over:

> due to the fact that

Delete:

> It is important to note that...

when the sentence works without it.

Collapse stacked hedging:

> could potentially possibly be argued that it might...

into the actual level of uncertainty:

> may...

Do not end paragraphs with generic conclusions such as:

> The future looks bright.

State the actual implication, decision, plan, or result.

## Jargon

Avoid abstract nouns that sound technical without adding precision:

- substrate
- wedge
- vector
- locus
- vantage
- nexus
- primitive
- harness
- surface
- bedrock
- scaffolding
- modality
- paradigm
- gold-plating
- ratchet
- evacuate
- endgame
- north star
- flywheel

Use the concrete word they stand in for.

"Substrate" is often "base."

"Wedge in" is often "add."

"Vector" is often "way" or "method."

"Gold-plating" is often "more than the job needs."

"Ratchet" is often "a limit that only tightens."

"Evacuate" is often "move out."

"Endgame" is often "the last phase."

Do not remove technical jargon when it is the actual technical term.

## Plain speech

Name the mechanism, behavior, or result rather than the feeling around it.

Avoid sentences such as:

> The database stays close at hand.

> The API provides a powerful surface for...

> This creates a delightful developer experience.

Prefer concrete statements:

> `.toSQL()` returns the exact string sent to the database.

> Renaming the column fails the build.

> The query runs once per request.

If a sentence does not tell the reader something concrete, either make it concrete or remove it.

Use one idea per sentence as a default when a sentence becomes difficult to parse. Do not force every sentence to be short.

### Prefer active voice

Prefer:

> The compiler validates the query.

over:

> The query is validated by the compiler.

Use passive voice when the actor genuinely does not matter, is unknown, or the passive construction is more natural.

### Cut weak adverbs

Remove adverbs that compensate for imprecise verbs.

Instead of:

> runs quickly

say:

> runs in 40 ms

when the number matters.

Instead of:

> significantly improves

say what changed and by how much.

Prefer precise verbs over padded verbs.

### Prefer the plain word

Examples:

- utilize -> use
- leverage -> use
- facilitate -> help
- numerous -> many
- in the event that -> if
- functionality -> feature, behavior, or capability
- implement -> build or add, when accurate
- commence -> start
- terminate -> end or stop, when accurate

Do not mechanically replace technical terms when the original word is the precise one.

## AI-shaped structure

Watch for structural patterns in addition to individual words.

Avoid:

- An opening sentence that restates the prompt.
- A generic "here's why this matters" paragraph.
- Repeated conclusion sentences.
- Excessively symmetrical paragraphs.
- Identical sentence structures across consecutive paragraphs.
- Predictable "first / second / finally" sequencing without a real need.
- Repeating the same idea in slightly different words.
- "Whether you're X or Y..." constructions used as generic framing.
- A paragraph that exists only to transition to the next paragraph.
- Conclusions that merely summarize what was already said.

Do not remove structure that genuinely helps the reader. Remove structure that exists only because the prose was generated that way.

## Specificity

Prefer concrete details over generic language.

Replace:

> This can improve reliability.

with the actual mechanism:

> Retries now stop after the request becomes non-idempotent.

Replace:

> This is useful for developers.

with the actual benefit:

> The compiler now reports the invalid state before the request reaches the API.

Numbers, examples, names, mechanisms, constraints, and observable outcomes are usually better than adjectives.

## Final pass

After rewriting, read the result once without comparing it to the original.

Ask:

- Does this sound like a person with a point of view wrote it?
- Is every sentence saying something?
- Is any sentence there only because it sounds polished?
- Is the language more specific than before?
- Did I accidentally make the writing more generic?
- Did I preserve the author's actual tone?
- Did I introduce opinions, certainty, or emotion that were not present?
- Did I remove useful technical terminology merely because it sounded sophisticated?
- Does the structure feel natural rather than mechanically balanced?

Fix anything that still feels generated.

Do not "unslop" the text until it becomes bland. The goal is human writing, not uniformly plain writing.
