---
name: podcast-transcribe
description: Download and transcribe podcasts/audio from various sources
metadata:
  {
    "openclaw":
      {
        "emoji": "🎙️",
        "requires": { "bins": ["yt-dlp", "ffmpeg"] },
      },
  }
---

# Podcast Transcribe & Summarize

Use this skill to download podcasts, transcribe them, and create blog posts.

## When to use

- User asks to "transcribe this podcast" or "summarize this episode"
- Convert podcast/audio to blog post
- Extract key insights from audio content

## Process

### Step 1: Find the Source

First, find the podcast or audio URL. Common sources:
- YouTube (podcast episodes)
- Direct audio URLs (.mp3, .m4a)
- Podcast RSS feeds

Use Tavily search to find the episode:
```bash
curl -s -X POST https://api.tavily.com/search \
  -H "Authorization: Bearer $TAVILY_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "your topic podcast episode", "max_results": 5}'
```

### Step 2: Download Audio

**From YouTube:**
```bash
yt-dlp -x --audio-format mp3 -o "/tmp/%(title)s.%(ext)s" "URL"
```

**From direct URL:**
```bash
curl -L "AUDIO_URL" -o "/tmp/podcast.mp3"
```

### Step 3: Transcribe with Whisper

Use whisper.cpp or OpenAI's Whisper API:

**Using whisper.cpp (local):**
```bash
whisper.cpp/models/download-ggml-model.sh base  # Download model
./main -m models/ggml-base.bin -f /tmp/audio.mp3 > /tmp/transcript.txt
```

**Or upload to OpenAI Whisper API** (requires API key):
```bash
curl -X POST -H "Authorization: Bearer YOUR_API_KEY" \
  -F "file=@/tmp/audio.mp3" \
  -F "model=whisper-1" \
  -F "response_format=text" \
  https://api.openai.com/v1/audio/transcriptions
```

### Step 4: Summarize

Use the transcript to create a blog post. Use MiniMax or OpenClaw to:
- Extract key insights
- Create sections with timestamps
- Write actionable takeaways
- Format for blog

### Step 5: Create Blog Post

Create an HTML blog post with:
- Title and date
- Episode description
- Key insights (bullet points)
- Timestamps
- Links back to original

### Step 6: Deploy

Add to the blog section of the marketing site.

## Environment

- `yt-dlp` - Download YouTube/audio
- `ffmpeg` - Audio processing
- `whisper.cpp` or OpenAI Whisper - Transcription
- **MiniMax** - For AI summarization

## Tips

- For long podcasts, split into chunks before transcription
- Start with a 5-minute sample to test
- Include timestamps in the summary for navigation
- Add key takeaways at the top for skimmability
