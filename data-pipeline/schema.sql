-- Tutor Data Pipeline - Database Schema Changes
-- Run these in Supabase SQL Editor (https://supabase.com/dashboard/project/araqigsimkjsmwhnjesv/sql)

-- ============================================
-- NEW COLUMNS FOR TUTORS TABLE
-- ============================================

-- Location & Mapping
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS website TEXT;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS latitude FLOAT;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS longitude FLOAT;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS place_id TEXT;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS opening_hours TEXT;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS photos_count INTEGER;
ALTER TABLE tutors ADD COLUMN IF NOT EXISTS image_url TEXT;

-- Enrichment (via Jina AI)
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

-- ============================================
-- VERIFY COLUMNS ADDED
-- ============================================
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'tutors'
ORDER BY ordinal_position;

-- ============================================
-- SAMPLE QUERIES
-- ============================================

-- Get tutors with images
SELECT name, image_url, rating FROM tutors WHERE image_url IS NOT NULL LIMIT 10;

-- Get data quality score
SELECT 
  name,
  CASE 
    WHEN website IS NOT NULL THEN 0.15 ELSE 0 END +
    WHEN image_url IS NOT NULL THEN 0.15 ELSE 0 END +
    WHEN phone IS NOT NULL THEN 0.15 ELSE 0 END +
    WHEN rating IS NOT NULL THEN 0.15 ELSE 0 END +
    WHEN qualifications IS NOT NULL THEN 0.2 ELSE 0 END +
    WHEN full_bio IS NOT NULL THEN 0.2 ELSE 0 END AS quality_score
FROM tutors
ORDER BY quality_score DESC
LIMIT 20;

-- Count by source
SELECT source, COUNT(*) FROM tutors GROUP BY source;
