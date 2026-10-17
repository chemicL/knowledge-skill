# Discovery and verification recipes

Use `WebFetch` for every check. URL-encode query parameters. An item passes only when the returned record matches the candidate's **title and author**, and the year where one is known. A partial or fuzzy match on a different work is a failure, so drop the item. Never output a URL you haven't fetched or built by the rules below.

## Finding books (discovery, before verification)

Run these for every track you'll show. Rule 3 in SKILL.md requires the book search to actually happen.

Subject searches also return **fiction** (novels, science fiction), so drop those. In Open Library, check `subject` for "fiction". In Biblioteka Narodowa, check the `genre` field: keep non-fiction such as `Opracowanie` or `Literatura popularnonaukowa`, and drop `Powieść`, `Fantastyka` and similar.

**Children's books (English):**
```
https://openlibrary.org/search.json?q=<topic>+juvenile+literature&fields=key,title,author_name,first_publish_year,ebook_access,subject&limit=10
```
Try both the asker's wording and the field's term (e.g. `solar+systems` and `exoplanets`).

**Popular and academic books (English):**
```
https://openlibrary.org/search.json?q=subject:<topic>&fields=key,title,author_name,first_publish_year,ebook_access,publisher&limit=15
```
Also use WebSearch for the field's standard textbooks and university-press monographs.

**Polish books on a topic (Biblioteka Narodowa subject search):**
```
https://data.bn.org.pl/api/institutions/bibs.json?subject=<Polish subject term>&kind=książka&limit=20
https://data.bn.org.pl/api/institutions/bibs.json?title=<Polish keywords>&kind=książka&limit=20
```
- Use Polish subject terms (e.g. `Egzoplanety`, `Czarne dziury`). Without `kind=książka` the results are mostly journal articles.
- Popular Polish journal articles from the same catalogue (e.g. Świat Nauki, Wiedza i Życie) are also valid 📄 candidates.

**Polish children's books:** use WebSearch for `książka dla dzieci <temat>` and `site:lubimyczytac.pl <temat> dla dzieci`. Then confirm each candidate in BN by title, as below.

## Verifying books (any language): Open Library
```
https://openlibrary.org/search.json?title=<title>&author=<author>&fields=key,title,author_name,first_publish_year,isbn,ebook_access,language&limit=3
```
- Match the title and author. Take `first_publish_year` and the ISBNs (prefer a 13-digit ISBN from a recent English edition).
- `ebook_access`: `public` → 🆓 `Free: https://openlibrary.org<key>`. `borrowable` → 🔑 `Free: Open Library borrow https://openlibrary.org<key>`. Anything else → there is no free copy from Open Library.
- About (English): `https://openlibrary.org<key>`

## Verifying books: Polish editions (Biblioteka Narodowa)
Always search **by title, never by author alone**. Author-only searches return nothing or unrelated records.
1. Try the **original title** first. BN often stores it next to the Polish title (e.g. `Nowe Ziemie … / Alien Earths …`):
   `https://data.bn.org.pl/api/institutions/bibs.json?title=<original title>&kind=książka&limit=10`
2. If nothing comes back, use WebSearch for `"<original title>" <author> polskie wydanie` to learn the Polish title, then search BN with `title=<Polish title>`.
3. Confirm the author in the record's `author` field. The response has `bibs[]` with `title`, `author`, `publisher`, `publicationYear` and `isbnIssn`.
4. Pick the most recent edition. Use its publisher, year and ISBN for `PL: Publisher Year` and for buy links.
5. If none of these steps finds a Polish edition, there is none. Don't guess.

- Polish About page: fetch `https://lubimyczytac.pl/szukaj/ksiazki?phrase=<Polish title>`. Search by **title**, because author-only searches are fuzzy. Take the matching `https://lubimyczytac.pl/ksiazka/...` URL.
- Free Polish copy: search `https://polona.pl` (via WebSearch `site:polona.pl <title>`) for public-domain works only.
- Library e-book access (e.g. Legimi through Polish public libraries) **can't be verified**, because those sites block automated checks. Don't mark a book 🔑 on that basis. Use 🔑 only for free access you actually confirmed: Open Library borrowing, or a site that needs only registration.

## Buy links (search URLs, built from the verified ISBN, not fetched)
**Polish output only:**
- Allegro: `https://allegro.pl/listing?string=<ISBN>`
- empik: `https://www.empik.com/szukaj/produkt?q=<ISBN>`
- Amazon: `https://www.amazon.pl/s?k=<ISBN>`

Use the Polish edition's ISBN when one exists. Otherwise use the original edition's ISBN.

**Any other output language:**
- Amazon: `https://www.amazon.com/s?k=<ISBN>`

Always label these links "search".

## Papers, review articles: OpenAlex (primary)
```
https://api.openalex.org/works?search=<title or keywords>&per_page=3&select=display_name,publication_year,cited_by_count,open_access,doi,authorships,primary_location
```
- Match the title. Use `cited_by_count` as a quality signal.
- **Prefer an arXiv or other open-repository link** over a publisher PDF. Publisher sites (Annual Reviews, IOP, Elsevier) often block automated checks, and their URLs change. Check for an arXiv version with WebSearch `site:arxiv.org <title>`, then fetch the abstract page `https://arxiv.org/abs/<id>` to confirm it's the same paper.
- Linking:
  - arXiv version exists → 🆓, link `https://arxiv.org/abs/<id>`
  - no arXiv version, but `open_access.is_oa: true` → 🆓, link `open_access.oa_url`
  - neither → link the `doi` and mark 💰, which needs `Why paid:`
- Fallback when OpenAlex has no match: Semantic Scholar `https://api.semanticscholar.org/graph/v1/paper/search?query=<title>&fields=title,year,authors,citationCount,openAccessPdf&limit=3`. It often rate-limits (HTTP 429), so don't retry in a loop.

## YouTube videos and lecture series
```
https://www.youtube.com/oembed?url=<full video or playlist URL>&format=json
```
- Success returns `title` and `author_name` (the channel). Use these real values, not remembered ones. An error means drop the item.
- Find candidate URLs with WebSearch (`site:youtube.com <topic> <channel>`). Never guess video IDs.

## Podcasts
1. Confirm the show or episode exists with the iTunes Search API:
   ```
   https://itunes.apple.com/search?term=<show or episode>&entity=podcast&limit=3
   https://itunes.apple.com/search?term=<episode title>&entity=podcastEpisode&limit=3
   ```
   Match `collectionName`/`artistName` (show) or `trackName` (episode).
2. **Link the creator's own episode page** when it exists, especially if it has a transcript. Find it with WebSearch, then fetch it to confirm. Fall back to `trackViewUrl` or `collectionViewUrl`.

## Articles, blogs, courses, institutional sites, simulations, documentaries
- WebFetch the URL with a prompt like "Return the page title, author/byline, publisher and date". Confirm they match the candidate, and that the page is the real content, not a 404, paywall stub or redirect to the home page.
- Courses: confirm the course page exists, and note if registration is needed (🔑).
- Documentaries: link an official page or the broadcaster's page. Mark 💰 if it's only on a paid streaming service.
- Places (🏛️): link the official site and mark them 🎟️ if a ticket is needed. Places don't need `Why paid:`.

## Budget
Run independent fetches in parallel. Don't refetch something already verified in this run. If a source type keeps failing (rate limits, blocks), move on to other candidates rather than stalling.
