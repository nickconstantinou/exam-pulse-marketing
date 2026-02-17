---
name: market-researcher
description: Deep-dive research into GCSE revision pain points using Tavily
type: skill
version: 2.0.0
---

# Market Researcher - ExamPulse Edition

## Goal
Find raw human pain points. Not "the market is growing" — find what pisses students off.

## Research Protocol

### 1. Neural Sweep (Tavily)
Search for:
- "GCSE revision Reddit complaints"
- "ChatGPT wrong answers exams"
- "past papers inefficient"
- "AI homework help doesn't work"

### 2. Sentiment Extraction
Find:
- Raw complaints (not summaries)
- Emotional language: frustrated, overwhelmed, stuck, confused
- What's NOT working for students

### 3. Competitor Vibe Check
- What do users hate about existing apps?
- Where do they go for help currently?
- What are the "I tried X and it sucked" stories?

### 4. Pain Points Matrix
```
| Pain Point | Emotional State | Current "Solution" |
|------------|-----------------|-------------------|
| ChatGPT lies | Frustrated, betrayed | Still using it anyway |
| Don't know what to revise | Overwhelmed, paralysed | Guesswork |
| Past papers take forever | Exhausted | Avoid them |
| Tutoring is expensive | Guilty, stressed | Make do without |
```

## Output
Save to `campaigns/[campaign-name]/research.md`:
- Raw quotes from users
- Emotional triggers
- Positioning opportunities

## Tools
- Tavily search (primary)
- Web fetch for Reddit threads
