# Migration Plan: UK Tutors → ExamPulse Subsection

## Objective
Move `uk-tutors-directory` content to a `/tutors/` subsection of `exam-pulse-marketing`, creating a unified site that serves as both a tutor directory and AI revision lead magnet.

**New Domain:** https://exampulse.co.uk (purchased March 2026)

---

## Phase 1: Audit & Preparation (Week 1)

### 1.1 Content Audit ✅ COMPLETED
| UK Tutors (Old) | ExamPulse (Existing) |
|-----------------|---------------------|
| index.html | index.html (homepage) |
| list.html | quiz.html |
| blog/ | blog.html |
| sitemap.xml | blog/ |
| robots.txt | quiz.html |
| | grade-calculator.html |
| | gap-diagnostic.html |

### 1.2 URL Mapping
| Old URL (github.io) | New URL (exampulse.co.uk) |
|---------------------|--------------------------|
| `/` | `/tutors/` |
| `/list.html` | `/tutors/search` |
| `/blog/*` | `/tutors/blog/*` |
| `/faq` | `/tutors/faq` |
| `/sitemap.xml` | `/sitemap.xml` |
| `/robots.txt` | `/robots.txt` |

**Note:** After migration, set up redirects:
- `exampulse.co.uk` → `exampulse.co.uk/tutors/` (or keep ExamPulse homepage)
- Old `uk-tutors-directory` repo: 301 to `exampulse.co.uk/tutors/`

### 1.3 SEO Preparation
- [x] Export all metadata (titles, descriptions) from UK Tutors → `migration-metadata.md`
- [ ] Note current backlink profile (if any) - **TODO: Manual check in GSC**
- [x] Plan 301 redirects → included in `migration-metadata.md`

---

## Phase 2: Structure & Design (Week 1-2)

### 2.1 Site Architecture
```
exam-pulse-marketing/
├── index.html          # ExamPulse homepage (existing) @ exampulse.co.uk
├── quiz.html           # Lead magnet (existing)
├── tutors/             # NEW SECTION @ exampulse.co.uk/tutors/
│   ├── index.html      # UK Tutor directory home
│   ├── search.html    # Tutor search (from list.html)
│   ├── blog/          # Tutor-related blog posts
│   └── faq.html       # Tutor FAQ
├── blog/              # ExamPulse blog @ exampulse.co.uk/blog
└── tools/             # Existing tools (quiz, grade calc, etc.)
```

### 2.2 Shared Elements
- [x] **Navigation bar structure:** Added via index.html
- [x] "Tutors" link in header → `/tutors/` (already present in main nav)
- [x] Shared footer with cross-links
- [x] Unified styling (slightly adapted for tutors section)
- [x] Cross-sell CTA in tutor pages: "Need instant revision help? Try ExamPulse"

### 2.3 Design Decisions
- [x] Keep tutor directory look/feel but align with ExamPulse brand ✅
- [x] Mobile responsiveness requirements ✅
- [x] Contact form integration (Supabase - preserved)

---

## Phase 3: Content Migration (Week 2)

### 3.1 Core Pages
- [x] Create `/tutors/index.html` — Main tutor landing page
- [x] Migrate search functionality → `/tutors/search.html`
- [x] Migrate blog posts → `/tutors/blog/how-to-choose-tutor.html`

### 3.2 New Content for Tutors Section
- [x] "Why use ExamPulse tutors?" — differentiate from directory
- [x] Tutor verification badges (showcase)
- [x] Added FAQ page

### 3.3 Lead Magnet Integration
- [x] Add ExamPulse CTA to tutor pages
- [x] "Get early access to AI revision" banner
- [x] Added register page for tutor signups

---

## Phase 4: Technical Implementation (Week 2-3)

### 4.1 File Structure
- [x] Create `tutors/` directory
- [x] Move/copy relevant files
- [x] Update all internal links

### 4.2 Analytics
- [x] Update PostHog events for new URLs (added to search + register pages)
- [ ] Create funnels: Tutor search → ExamPulse signup (can do in PostHog)
- [ ] Track cross-sell clicks (can add more tracking later)

### 4.3 SEO
- [x] Add canonical URLs for tutor pages
- [x] Add hreflang if needed (using en-GB)
- [x] Update sitemap.xml with new URLs
- [ ] Submit new sitemap to GSC

---

## Phase 5: Redirects & Launch (Week 3)

### 5.1 Redirects (Critical!)
- [x] Redirects not needed - UK Tutors was never live
- [x] Created `_redirects` file for future reference

### 5.2 Launch Checklist
- [x] **Custom Domain:** Already configured ✅
- [x] Site deployed and live at https://www.exampulse.co.uk
- [ ] Full site test (links, forms, CTAs) - **Manual test needed**
- [ ] Mobile test - **Manual test needed**

### 5.3 Post-Launch
- [ ] Monitor 404s in GSC
- [ ] Check SEO rankings (may dip temporarily)
- [ ] A/B test cross-sell CTAs

---

## Budget & Resources

| Item | Estimate |
|------|----------|
| Development | 8-12 hours |
| Content migration | 4 hours |
| Testing | 2 hours |
| **Total** | **~14-18 hours** |

---

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| SEO ranking drop | Proper 301 redirects, same-content migration |
| Brand confusion | Clear nav: "ExamPulse" vs "Find a Tutor" |
| Broken links | Comprehensive redirect map + post-launch audit |
| Form breakage | Test Supabase integration thoroughly |

---

## Next Steps

1. **Approve this plan?** ✅ Nick approved: ExamPulse homepage stays, tutors as subsection with nav link
2. **Content audit** — Start listing existing pages
3. **Begin Phase 1** — Audit current UK Tutors content
