# Migration Plan: UK Tutors → ExamPulse Subsection

## Objective
Move `uk-tutors-directory` content to a `/tutors/` subsection of `exam-pulse-marketing`, creating a unified site that serves as both a tutor directory and AI revision lead magnet.

---

## Phase 1: Audit & Preparation (Week 1)

### 1.1 Content Audit
- [ ] List all pages in `uk-tutors-directory` (index, blog posts, etc.)
- [ ] List all pages in `exam-pulse-marketing`
- [ ] Identify duplicate/overlapping content
- [ ] Map URL redirects (critical for SEO)

### 1.2 URL Mapping
| Old URL | New URL |
|---------|---------|
| `/` | `/tutors/` |
| `/blog/*` | `/tutors/blog/*` |
| `/faq` | `/tutors/faq` |
| `/search` | `/tutors/search` |

### 1.3 SEO Preparation
- [ ] Export all metadata (titles, descriptions) from UK Tutors
- [ ] Note current backlink profile (if any)
- [ ] Plan 301 redirects

---

## Phase 2: Structure & Design (Week 1-2)

### 2.1 Site Architecture
```
exam-pulse-marketing/
├── index.html          # ExamPulse homepage (existing)
├── quiz.html           # Lead magnet (existing)
├── tutors/             # NEW SECTION
│   ├── index.html      # UK Tutor directory home
│   ├── search.html    # Tutor search
│   ├── blog/          # Tutor-related blog posts
│   └── faq.html       # Tutor FAQ
├── blog/              # ExamPulse blog (existing)
└── tools/             # Existing tools
```

### 2.2 Shared Elements
- [ ] Update header nav: "Tutors" link + "ExamPulse" logo
- [ ] Shared footer with cross-links
- [ ] Unified styling (or slight variation for tutors section)
- [ ] Cross-sell CTA in tutor pages: "Need instant revision help? Try ExamPulse"

### 2.3 Design Decisions
- [ ] Keep tutor directory look/feel or align with ExamPulse brand?
- [ ] Mobile responsiveness requirements
- [ ] Contact form integration (keep Supabase?)

---

## Phase 3: Content Migration (Week 2)

### 3.1 Core Pages
- [ ] Create `/tutors/index.html` — Main tutor landing page
- [ ] Migrate search functionality → `/tutors/search.html`
- [ ] Migrate blog posts → `/tutors/blog/`

### 3.2 New Content for Tutors Section
- [ ] "Why use ExamPulse tutors?" — differentiate from directory
- [ ] Tutor verification badges (showcase)
- [ ] Parent testimonials

### 3.3 Lead Magnet Integration
- [ ] Add ExamPulse CTA to tutor pages
- [ ] "Get early access to AI revision" banner
- [ ] "Download free GCSE revision guide" popup

---

## Phase 4: Technical Implementation (Week 2-3)

### 4.1 File Structure
- [ ] Create `tutors/` directory
- [ ] Move/copy relevant files
- [ ] Update all internal links

### 4.2 Analytics
- [ ] Update PostHog events for new URLs
- [ ] Create funnels: Tutor search → ExamPulse signup
- [ ] Track cross-sell clicks

### 4.3 SEO
- [ ] Add canonical URLs for tutor pages
- [ ] Add hreflang if needed
- [ ] Update sitemap.xml with new URLs
- [ ] Submit new sitemap to GSC

---

## Phase 5: Redirects & Launch (Week 3)

### 5.1 Redirects (Critical!)
- [ ] 301 `/` → `/tutors/` (if replacing homepage)
- [ ] 301 `/blog/*` → `/tutors/blog/*`
- [ ] 301 `/faq` → `/tutors/faq`
- [ ] Test all redirects

### 5.2 Launch Checklist
- [ ] Full site test (links, forms, CTAs)
- [ ] Mobile test
- [ ] Analytics verification
- [ ] Search Console re-submit
- [ ] Update GitHub Pages settings if needed

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

1. **Approve this plan?** 
2. **Content audit** — Start listing existing pages
3. **Decision:** Replace ExamPulse homepage with tutor directory, or keep ExamPulse as homepage with tutors as section?
