# Tutor Data Pipeline

Systematic process for collecting, enriching, and managing tutor data for the UK Tutors directory.

---

## Overview

| Component | Details |
|-----------|---------|
| **Data Source** | Google Maps via Outscraper API |
| **Enrichment** | Jina AI for content extraction |
| **Storage** | Supabase (Project: araqigsimkjsmwhnjesv) |
| **Website** | exampulse.co.uk/tutors/ |

---

## Supabase Schema

### Current Fields

```sql
CREATE TABLE tutors (
  id              SERIAL PRIMARY KEY,
  name            TEXT NOT NULL,
  email           TEXT,
  phone           TEXT,
  location        TEXT,
  subjects        TEXT[],  -- JSON array: ["Maths", "Physics"]
  levels          TEXT[],  -- JSON array: ["GCSE", "A-Level"]
  price           INTEGER,
  experience      INTEGER,
  bio             TEXT,
  rating          FLOAT,
  reviews         INTEGER,
  verified        BOOLEAN,
  created_at      TIMESTAMP DEFAULT NOW()
);
```

### New Fields (To Be Added)

```sql
-- Run these in Supabase SQL Editor

-- Location & Mapping
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS website TEXT;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS latitude FLOAT;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS longitude FLOAT;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS place_id TEXT;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS opening_hours TEXT;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS photos_count INTEGER;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS image_url TEXT;

-- Enrichment (via Jina)
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS qualifications TEXT;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS teaching_mode TEXT;  -- 'online', 'in-person', 'both'
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS special_needs BOOLEAN;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS free_trial BOOLEAN;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS gender TEXT;  -- 'male', 'female', 'any'
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS years_experience INTEGER;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS full_bio TEXT;

-- Pipeline metadata
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS source TEXT;  -- 'outscraper', 'manual', 'api'
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS scraped_at TIMESTAMP;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS enriched_at TIMESTAMP;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS data_quality_score FLOAT;  -- 0-1
```

---

## Step 1: Scrape with Outscraper

### Prerequisites

```bash
# Set API key
export OUTSCRAPER_API_KEY="your_key_here"

# Or add to ~/.openclaw/.env
echo 'OUTSCRAPER_API_KEY=your_key_here' >> ~/.openclaw/.env
```

### Scrape Command

```bash
# Single city (max 500 results)
curl -s "https://api.outscraper.cloud/google-maps-search?query=tutors, Northampton, UK&limit=500&region=GB" \
  -H "X-API-KEY: $OUTSCRAPER_API_KEY" \
  -o northampton_tutors.json

# London (split by area for more results)
for area in "Central London" "South London" "North London" "East London" "West London"; do
  curl -s "https://api.outscraper.cloud/google-maps-search?query=tutors, $area, UK&limit=500&region=GB" \
    -H "X-API-KEY: $OUTSCRAPER_API_KEY" \
    -o "london_${area// /_}.json"
done
```

### Outscraper Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| query | "tutors, {CITY}, UK" | Search query |
| limit | 500 | Max results (max 500) |
| region | GB | UK results only |
| async | false | Synchronous (for <500) |

### Response Fields (Outscraper)

```json
{
  "name": "Kip McGrath Northampton North",
  "phone": "+44 1604 790844",
  "address": "10 Brookfield, Northampton NN3 6WL",
  "latitude": 52.2468,
  "longitude": -0.8902,
  "place_id": "ChIJK...",
  "rating": 5.0,
  "reviews": 12,
  "website": "http://www.kipmcgrath.co.uk/northamptonnorth",
  "image": "https://lh3.googleusercontent.com/...",
  "hours": "Mon-Fri: 4pm-7pm",
  "types": ["tutor", "school"]
}
```

---

## Step 2: Transform Data

### Python Script: transform_tutors.py

```python
import json
import csv

def transform_outscraper(input_file, output_file):
    """Transform Outscraper JSON to Supabase-ready CSV"""
    
    with open(input_file, 'r') as f:
        data = json.load(f)
    
    # Outscraper returns array in data[0]
    tutors = data.get('data', [])
    
    output = []
    for t in tutors:
        record = {
            'name': t.get('name', ''),
            'phone': t.get('phone', ''),
            'location': t.get('address', ''),
            'latitude': t.get('latitude'),
            'longitude': t.get('longitude'),
            'place_id': t.get('place_id'),
            'rating': t.get('rating'),
            'reviews': t.get('reviews'),
            'website': t.get('website'),
            'image_url': t.get('image'),
            'opening_hours': t.get('hours'),
            'source': 'outscraper'
        }
        output.append(record)
    
    # Save as CSV for Supabase import
    with open(output_file, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=output[0].keys())
        writer.writeheader()
        writer.writerows(output)
    
    return len(output)

# Usage
count = transform_outscraper('northampton_tutors.json', 'tutors_clean.csv')
print(f"Transformed {count} tutors")
```

---

## Step 3: Import to Supabase

### Option A: Via CSV Upload

1. Go to Supabase Dashboard → Table Editor → tutors
2. Click "Insert" → "Insert from CSV"
3. Upload the transformed CSV

### Option B: Via API

```bash
# Upload single tutor
curl -X POST "https://araqigsimkjsmwhnjesv.supabase.co/rest/v1/tutors" \
  -H "apikey: $ANON_KEY" \
  -H "Authorization: Bearer $ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Tutor",
    "phone": "+44 7700 900123",
    "location": "London",
    "rating": 4.8,
    "source": "outscraper"
  }'
```

### Get Keys

| Key | Where to Find |
|-----|---------------|
| ANON_KEY | Supabase → Settings → API → `anon` key |
| SERVICE_KEY | Supabase → Settings → API → `service_role` key (keep secret!) |

---

## Step 4: Enrich with Jina

### Purpose
Extract qualifications, bio details, teaching mode from tutor websites.

### Jina Extraction

```bash
# Extract content from tutor website
curl -s "https://r.jina.ai/http://www.kipmcgrath.co.uk/northamptonnorth" | \
  jq -r '.content' | \
  head -c 2000
```

### Python Script: enrich_tutors.py

```python
import requests
import time

JINA_API = "https://r.jina.ai/http://"

def enrich_tutor(website_url):
    """Extract info from tutor website"""
    if not website_url:
        return {}
    
    # Clean URL
    url = website_url
    if not url.startswith(('http://', 'https://')):
        url = 'http://' + url
    
    try:
        resp = requests.get(JINA_API + url, timeout=10)
        content = resp.json().get('content', '')
        
        # Extract key info (simplified - could use AI for better extraction)
        info = {
            'full_bio': content[:1000],  # First 1000 chars
            'qualifications': extract_qualifications(content),
            'teaching_mode': extract_teaching_mode(content),
        }
        return info
    except Exception as e:
        print(f"Error enriching {website_url}: {e}")
        return {}

def extract_qualifications(text):
    keywords = ['BSc', 'MSc', 'PhD', 'PGCE', 'QTS', 'degree']
    found = [k for k in keywords if k.lower() in text.lower()]
    return ', '.join(found) if found else None

def extract_ teaching_mode(text):
    text_lower = text.lower()
    online = 'online' in text_lower or 'virtual' in text_lower
    in_person = 'face to face' in text_lower or 'in person' in text_lower
    
    if online and in_person:
        return 'both'
    elif online:
        return 'online'
    elif in_person:
        return 'in-person'
    return None

# Run enrichment
for tutor in get_tutors_without_enrichment():
    info = enrich_tutor(tutor['website'])
    update_tutor_in_supabase(tutor['id'], info)
    time.sleep(1)  # Rate limit
```

---

## Step 5: Quality Scoring

### Score Formula

```
data_quality_score = 
  (has_phone ? 0.15 : 0) +
  (has_website ? 0.15 : 0) +
  (has_image ? 0.15 : 0) +
  (has_rating ? 0.15 : 0) +
  (has_qualifications ? 0.2 : 0) +
  (has_full_bio ? 0.2 : 0)
```

---

## Cities to Scrape (Priority Order)

### Tier 1 (P1) - Major Cities
| City | Est. Tutors | Command |
|------|-------------|---------|
| London (5 areas) | 2,000+ | Split by area |
| Birmingham | 500+ | `tutors, Birmingham, UK` |
| Manchester | 500+ | `tutors, Manchester, UK` |
| Leeds | 300+ | `tutors, Leeds, UK` |
| Glasgow | 300+ | `tutors, Glasgow, UK` |

### Tier 2 (P2)
| City | Est. Tutors |
|------|-------------|
| Liverpool | 250+ |
| Sheffield | 250+ |
| Bristol | 200+ |
| Edinburgh | 200+ |
| Newcastle | 150+ |

### Tier 3 (P3)
| City | Est. Tutors |
|------|-------------|
| Nottingham | 150+ |
| Southampton | 120+ |
| Oxford | 80+ |
| Cambridge | 80+ |

---

## Cost Estimate

| Item | Cost |
|------|------|
| Outscraper | ~$3 per 1,000 records |
| Jina | Free tier (100k chars/month) |
| Supabase | Free tier (500MB) |
| **Total for 1,000 tutors** | ~$3 |

---

## Pipeline Automation (Future)

```bash
# Cron job to scrape new tutors weekly
0 6 * * 0 /path/to/scrape_cities.sh

# Daily enrichment
0 8 * * * /path/to/enrich_new_tutors.sh
```

---

## Current Data Status (March 5, 2026)

| City | Count | Source |
|------|-------|--------|
| Northampton | 16 | Outscraper |
| London | 1 | Manual |
| Manchester | 1 | Manual |
| Birmingham | 1 | Manual |
| **Total** | **21** | |

---

## Reproduce This Pipeline

1. Get Outscraper API key: https://outscraper.com
2. Run scrape commands (see Step 1)
3. Transform data (see Step 2)
4. Import to Supabase (see Step 3)
5. Enrich with Jina (see Step 4)

---

## Files in This Directory

- `README.md` - This file
- `transform_tutors.py` - Data transformation script
- `enrich_tutors.py` - Website enrichment script
- `scrape_city.sh` - Bash script for scraping
- `cities.json` - Target cities list
