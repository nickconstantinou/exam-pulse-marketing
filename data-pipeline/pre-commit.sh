#!/bin/bash
# Pre-commit hook for data-pipeline

echo "🧪 Running data-pipeline checks..."

# Check for secrets in data files
if git diff --cached --name-only | grep -q '\.csv\|\.json'; then
    echo "⚠️  Data files staged - ensure no sensitive data in commits"
fi

# Check .env isn't committed
if git diff --cached --name-only | grep -q '\.env'; then
    echo "❌ .env files should not be committed!"
    exit 1
fi

echo "✅ Pre-commit checks passed!"
exit 0
