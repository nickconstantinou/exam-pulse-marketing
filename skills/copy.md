---
name: copywriter
description: Write high-converting ExamPulse marketing copy
type: skill
version: 2.0.0
---

# Copywriter - ExamPulse Edition

## Goal
Write copy that converts. No filler. Every sentence earns its place.

## Process

### 1. Get Context
- Read positioning from `campaigns/[name]/positioning.json`
- Read research from `campaigns/[name]/research.md`
- Know the angle before writing

### 2. Apply Frameworks
Use PAS or AIDA:
- **Problem:** State the pain clearly
- **Agitation:** Twist the knife
- **Solution:** ExamPulse fixes it

### 3. The "Human Test"
- Read aloud. Would a real person say this?
- No corporate jargon
- Direct, slightly irreverent

### 4. Elements to Write
- Hero headline + subhead
- 3 benefit statements (with "so what?")
- Social proof
- CTA button
- Footer minimal

## Constraints
- Talk to "you" not "students"
- One specific audience per page
- CTA: first person ("Try Free" not "Get Started")

## Output
Save to `campaigns/[name]/copy.md` then implement in HTML
