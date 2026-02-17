# Deploy Skill

Deploy marketing assets to GitHub Pages.

## Workflow

### 1. Build
- Generate landing page as static HTML
- Or use Next.js build for static export

### 2. Deploy to GitHub Pages
```bash
# Commit to gh-pages branch
git checkout gh-pages
git add -A
git commit -m "Deploy: [project-name]"
git push origin gh-pages
```

### 3. Report
- Return the live URL
- Report to Griptide for tracking

## Output
Live URL posted to `deploys/[date]-project-url.md`
