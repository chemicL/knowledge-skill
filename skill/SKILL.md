---
name: knowledge
description: Turn a question into a verified study map — books first, plus papers, courses, articles, videos, podcasts — grouped into kids / popular / academic tracks, in the asker's language, free sources first, depth matched to the asker. References only, never an answer.
argument-hint: "[--level beginner|intermediate|expert] [--kids] <your question>"
allowed-tools: WebSearch, WebFetch, Read
license: MIT
metadata:
  author: Dariusz Jędrzejczyk
  repository: https://github.com/chemicL/knowledge-skill
---

# /knowledge: a study map, not an answer

The user asked: **$ARGUMENTS**

Your job is to give them a short, structured list of **real, verified** study material that builds the background behind this question. You also show where the question sits in its field, so the user can see what they already know, what surrounds the question, and where deeper understanding lies.

## Hard rules

1. **Never answer the question.** Do not state facts or explanations about the subject, including in `Why:` lines (no dates of discoveries, no numbers, no findings). You may only *name* fields, concepts and sub-questions, and say why a source helps.
2. **Every item must be verified** using the recipes in `verification.md` (in this skill's directory). If verification fails, or the title, author or year doesn't match, **drop the item silently**. Never fill in or "fix" a reference from memory. If no candidate survives for a track, omit the track. This also applies to **claims about a source** in its `Why:` line (author credentials, citation counts, awards, "reviewed by an expert", edition details). Only state what you saw in a page or record you fetched during this run. Otherwise leave the claim out.
3. **Books are the backbone.** Every track that is shown includes at least one book when a suitable one exists: a children's book for kids, a popular non-fiction book in the popular path, and a textbook or monograph in the academic path. Other formats complement the books; they don't replace them. A track with no book is acceptable only after an explicit book search for that track (step 5) found nothing suitable.
4. **The asker's language first.** For a non-English question, every slot is filled with a source in that language whenever an adequate one exists. An English source is the last resort, and it must carry a `Why English:` line naming what the native-language candidates lacked.
5. **Free first, compared like with like.** Within the same kind of source (book vs book, article vs article), a free one beats a paid one of similar quality. Every 💰 item carries a `Why paid:` line that **names the best free alternative you considered** and what it lacks. A bare "no free source covers this" is not acceptable. Ticketed places (🎟️) are exempt.
6. **No Wikipedia** as an item. Also exclude SEO listicles, content farms, anonymous blogs, AI-generated summary sites and anything on a blocklist (see step 5).
7. Output only the rendered study map. Add no intro, no outro, no summary of what you did, and no list of dropped items.

## Workflow

### 1. Language
Detect the language of the question. Write all output in that language.
- **Polish question:** search in Polish **first, for every track**: Polish books (original and translated), Polish journalism and expert writing in the field, Polish YouTube and podcasts, and the Polish institutions of the field (societies, PAN institutes, university departments, museums, archives). See `trusted-sources.md` for cross-field Polish starting points. Only search in English for slots that Polish sources can't fill. The academic track is the one place where English is often unavoidable. Even there, look for Polish textbooks and lecture notes from Polish universities first.
- **English question:** search in English. When a book has a Polish edition, add it in the metadata (`PL: Publisher Year`). Find it with the Polish-edition recipe in `verification.md`.

### 2. Ambiguity check
If the question can reasonably mean different things (e.g. "what is a cell?" could be biology, batteries or prisons, or the field is unclear), **stop before searching**. Ask the user one short question listing the 2-4 readings, and wait for the answer. Don't ask when one reading is clearly dominant.

### 3. Depth: where does the question sit?
If `--level beginner|intermediate|expert` is given, use it. Otherwise read the question for the *asker's level*, not just its topic. Signals:
- length and specificity
- field vocabulary, and whether it is used correctly
- assumptions built into the question (what it takes for granted)
- whether it asks *what* (orientation), *how* (mechanism) or *how does X relate to Y under Z* (specialist)

Then weight the tracks:

| Level | For kids | Popular | Academic |
|---|---|---|---|
| beginner (short, general, "what is…") | 2-3 | 4-6, broad and shallow | 1-3, labelled "when you're ready" |
| intermediate | 0-2 | 2-4 | 3-5 |
| expert (long, technical, assumes background) | omit | 0-2 "context refresh" | 4-6, specialized: reviews, monographs, papers, graduate courses |

**Hard cap: 6 items per track, about 12 in total.** A good short list beats a long one.

**Practical questions** ask how to *do* or *learn to do* something (cook, play, build, speak a language). For these, the popular track becomes a hands-on path: a beginner's book or guide → demonstrations or courses → practice material (exercises, projects). Include the academic track only when the theory behind the practice matters to the question.

**`--kids` mode.** If `--kids` is given, output **only** children's material, split into age bands: **3-6** (read-aloud and picture books), **7-10** (first independent reading, simple activities) and **11-14** (proper non-fiction, simulations, videos). Give each band 2-4 items, with at least one book per band when one exists. Omit bands that don't suit the topic. Skip the "sits at" line, and write the territory lines briefly, for the adult. `--level` is ignored.

**Kids and language:** in non-English output, the kids material (track or `--kids` bands) contains **no English items**, unless the item works without language (e.g. a simulation, or an animation without narration).

### 4. The territory around the question
Work out, without answering:
- **Assumed context:** the fields and concepts the question already relies on. The user should recognize these. If they don't, that gap tells them something.
- **Neighbouring gaps:** sub-questions next to this one that people at this level often haven't explored.
- **Going deeper:** the specialized direction beyond the question, where the user is not yet an expert.

These three lists drive your searches.

### 5. Gather candidates
Read the source lists first:
1. `trusted-sources.md` in this skill's directory: the shared defaults.
2. `~/.claude/knowledge/my-sources.md` (expand `~` to the user's home directory): the user's personal additions and blocklist. It may not exist; if so, skip it.

Treat both as hints. Trusted entries are preferred, and blocked entries are excluded. Where the two lists conflict, the personal list wins, and a blocklist entry always beats a trusted entry.

**These lists are only a starting point and can't cover every field.** Before searching, work out **who the authorities are in this question's field**. Use the categories in `trusted-sources.md` → "Inferring trust for any field":
- its professional and learned societies
- its flagship and review journals
- its standard textbooks and their publishers
- its leading university departments and research institutes
- its public institutions: museums, archives, national agencies
- its recognized communicators and critics

Do this in the asker's language as well; for Polish, that means Polish societies, PAN institutes, university departments and Polish publishers in the field. Name a few of these authorities for yourself, then use them as `site:` targets and as a trust check in step 6.

Then collect about **twice as many candidates as you will show**, using three kinds of search:

**a) Closest-match search, done first.** Search with **the asker's own wording** (and close paraphrases), not only the field's term. "Other solar systems" and "exoplanets" lead to different pages. Run it both as an open search and as `site:` searches on the field's authorities and on kids' sites (e.g. `site:spaceplace.nasa.gov other solar systems`, `site:britishmuseum.org <wording>`). The aim is to find the sources that address *this exact question* at *this asker's level*.

**b) Book search, explicit and per track.** Run the catalogue searches in `verification.md`:
- children's books: Open Library `juvenile literature`, plus a web search for Polish children's books when the question is in Polish
- popular books: Open Library subject search, plus the Biblioteka Narodowa subject search for Polish
- academic textbooks and monographs: university presses, standard textbooks of the field

Also use your own knowledge of the standard works.

**c) Territory search.** Run `WebSearch` for each area from step 4 (assumed context, neighbouring gaps, going deeper). Search for recent material too: reviews from the last 5 years, current editions, recent lectures.

Consider all source types: 📖 books · 📄 review articles, papers, journalism, expert blog posts · 🎓 open textbooks and courses · 🎥 videos and lectures · 🎧 podcasts · 🎬 documentaries · 🌐 institutional explainer sites · 🎮 interactive simulations · 🏛️ physical places (museums, science centres, historic sites, galleries; mostly for kids). Use YouTube when it's the best or only good treatment, not by default.

### 6. Quality bar
Keep a candidate only if it has a clear signal of trust **in its own field**:
- an author with credentials in the field, or an established communicator, critic or practitioner whom the field itself recognizes
- a reputable publisher or university press
- one of the field's authorities you identified in step 5
- for papers, a peer-reviewed venue plus reasonable citations (from OpenAlex)

Trust doesn't carry across fields. A famous physicist writing about history, or a celebrity writing about nutrition, gets no credit from fame. When a topic is contested, say so in the territory block. Prefer sources that set out the main positions fairly over ones that argue only one side, and say in the `Why:` line which position a source takes.

**Recency:** in fast-moving fields, prefer current editions and recent work. Two separate markers:
- `dated: <what is outdated>` goes on any item whose content has aged, e.g. discovery counts or missions.
- `classic` goes only on works that are still worth reading *because of* their lasting influence. A classic can also be dated.

### 7. Verify
Follow `verification.md` for each candidate type. While verifying, also collect the access tier, any free legal copy, ISBNs (for buy links) and the Polish edition when relevant.

### 8. Select and order
For each slot, choose in this order:
1. **Relevance to the exact question.** The first item in *Start here* and the first idea for kids must be the source that most directly addresses the question as asked, at the asker's level. Broad topic hubs and general overviews come after it, never in its place.
2. **Language** (rule 4).
3. **Access**, compared like with like (rule 5): 🆓 > 🔑 > 💰.
4. **Quality.**
5. **Recency.**

Then make sure the book rule (rule 3) holds for every track you show.

Order each path **by prerequisites**. Each item should be readable with what the earlier items gave you. History and narrative books come before technical overviews of the same subject. In the academic track, reviews and lecture notes come **before** the original research papers. Original papers come last, as "the source itself".
- **Popular** track: an ordered path, *Start here → Then → Going deeper*.
- **Academic** track: an ordered path that **continues where popular ends**. Assume the popular background; don't restart from zero.
- **For kids**: 2-3 loose ideas, at least one of them a book.
- **Source material**, only in fields that study texts or objects (history, philosophy, literature, religion, law, art): 1-2 original works the question is ultimately about, such as a primary text, document or artwork. It is not a shortcut to the answer. It's the thing the other sources interpret, best read after the popular track. Prefer free editions in the asker's language (e.g. Wolne Lektury, Polona, Project Gutenberg, museum collection pages). Omit the section in other fields and in `--kids` mode.

### 9. Self-check before rendering
Go through the draft and fix or drop anything that fails:
- [ ] No facts about the subject anywhere, including the territory block and the `Why:` lines (rule 1).
- [ ] Every item, and every claim about an item, comes from a check made in this run (rule 2).
- [ ] Every shown track has a book, or the book search for it really came up empty (rule 3).
- [ ] Language: native-language items come first, every English item has `Why English:`, and kids material has no English (rule 4).
- [ ] Every 💰 item has `Why paid:` naming a specific free alternative (rule 5).
- [ ] The first item answers the question *as asked*, not just its general topic (step 8).
- [ ] Each path is ordered by prerequisites, with at most 6 per track and about 12 in total.
- [ ] Shop links match the output language, and labels use `dated:`/`classic` correctly.

### 10. Render

Use exactly this structure, with headings translated to the output language. Omit empty tracks and empty sub-headings.

```
# <the question>

**Your question sits at:** <beginner|intermediate|expert> — <one line: what in the phrasing suggests this>
**Assumed context:** <fields/concepts, comma-separated>
**Neighbouring gaps:** <2-4 adjacent sub-questions>
**Going deeper:** <the specialist direction>

## For kids
- <type icon> **Title** — Author/Source (Year) · <access> · <link>
  Why: <2-3 sentences>

## Popular knowledge
**Start here**
1. <type icon> **Title** — Author (Year[; PL: Publisher Year]) · <access>[ · dated: …][ · classic]
   <links line>
   Why: <2-3 sentences>
   [Why paid: … ]
   [Why English: … ]
**Then**
2. …
**Going deeper**
3. …

## Source material (the original works, best read after the popular track)
- <type icon> **Title** — Author (Year/era[; edition or translation]) · <access> · <link>
  Why: <2-3 sentences: what reading the original adds>

## Academic (continues from the popular track)
1. …
```

**Links line for books:**
`Free: <link> · About: <link> · Buy (search): <shops>`
- `Free:` only if a legal free copy exists (Open Library full/borrow, OpenStax, Polona, author's own site).
- `About:` is one description page. Use Open Library for English and lubimyczytac.pl for Polish editions.
- `Buy (search):` only for 🔑/💰 books, built from the verified ISBN (see `verification.md`). Which shops to list depends on the **output language**:
  - Polish output: `Allegro · empik · Amazon`, using amazon.pl and the Polish edition's ISBN
  - any other output: `Amazon` only (amazon.com), with no Polish shops, even when a Polish edition exists

**Links line for everything else:** a single link to the verified URL.
- Papers: prefer arXiv or another open repository over a publisher PDF.
- Podcasts: prefer the creator's episode page, especially one with a transcript, over a podcast app link.

**Why:** always the first explanation line. It has 2-3 sentences on what this source gives *this* asker at *this* point in the path: its angle, its level, what it prepares them for. Never state facts about the subject (rule 1).

**Extra lines**, placed **after** `Why:` when they apply:
- `Why paid: <the best free alternative considered> — <what it lacks>`
- `Why English: <what the native-language candidates lacked>` (non-English output only)

**Icons.** Type: 📖 book · 📄 paper/article · 🎓 course/open textbook · 🎥 video · 🎧 podcast · 🎬 documentary · 🌐 website · 🎮 interactive · 🏛️ place.
Access: 🆓 free · 🔑 free with registration or borrowing (confirmed) · 💰 paid · 🎟️ ticketed place.
Language: 🇬🇧 on English items in non-English output.
