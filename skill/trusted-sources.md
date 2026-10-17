# Trusted sources

Shared default hints for `/knowledge`. Entries here are preferred, but **still verified** every time. Nothing here is exhaustive. For any field, the skill also works out the field's own authorities (see the first section).

Don't put personal preferences here, because reinstalling overwrites this file. Use `~/.claude/knowledge/my-sources.md` instead (created by `install.sh`). Its entries and blocklist take precedence over this file.

## Inferring trust for any field

Most questions fall outside the examples below. For each question, identify the field and find its authorities. Use these categories, in the asker's language as well as in English:

| Category | How to find it | Examples |
|---|---|---|
| Learned and professional societies | "<field> society", "<field> association", "towarzystwo <dziedzina>" | Royal Society of Chemistry, American Historical Association, Polskie Towarzystwo Matematyczne |
| Flagship and review journals | the field's "Annual Review of …", top journals by OpenAlex citation count | Annual Reviews, Trends in …, Nature Reviews … |
| Standard textbooks | "standard textbook <field>", university course reading lists | the book most syllabi assign |
| University departments and institutes | leading departments, national research institutes | Max Planck institutes, PAN institutes (instytuty Polskiej Akademii Nauk) |
| Public institutions | museums, archives, national agencies, statistics offices | national libraries, national museums, GUS |
| Recognized communicators and critics | people the field itself cites, reviews or awards | prize-winning popularizers in the field |

Red flags in any field: a single author with no credentials in the field, a commercial motive (e.g. selling supplements or courses), no sources cited, content-farm layout, or AI-generated text.

## Book series (any field)
- EN: Oxford *Very Short Introductions*, Cambridge *Companions*, Princeton *Primers*, DK *Eyewitness* (kids), Usborne (kids)
- PL: Polish editions of the Very Short Introductions, in two series: *Krótkie Wprowadzenie* (Wydawnictwo Uniwersytetu Łódzkiego, 2017–) and *Bardzo Krótkie Wprowadzenie* (Prószyński i S-ka, 1997–)

## Publishers & presses
- University presses: Oxford, Cambridge, Princeton, MIT, Chicago, Yale, Harvard, Columbia, California
- Trade non-fiction: Basic Books, W. W. Norton, Penguin/Allen Lane, Bodley Head, Profile Books
- Polish: Wydawnictwo Naukowe PWN, Prószyński i S-ka, Copernicus Center Press, Wydawnictwo Czarne (non-fiction), Znak (non-fiction), Wydawnictwo Uniwersytetu Jagiellońskiego, Wydawnictwo Uniwersytetu Łódzkiego, Wydawnictwo Uniwersytetu Warszawskiego, Ossolineum
- Polish children's non-fiction: Nasza Księgarnia, Wydawnictwo Dwie Siostry

## Open textbooks, courses & free libraries
- OpenStax, LibreTexts, Open Textbook Library, MIT OpenCourseWare, Open Yale Courses, Khan Academy, edX, Coursera
- Internet Archive, Project Gutenberg, HathiTrust, Europeana
- Polish: Zintegrowana Platforma Edukacyjna (zpe.gov.pl), Khan Academy po polsku, Navoica, Polona, Wolne Lektury, Federacja Bibliotek Cyfrowych

## Reference works by field
- Philosophy: Stanford Encyclopedia of Philosophy, Internet Encyclopedia of Philosophy
- History & art: museum collection pages, Smarthistory, Google Arts & Culture (institution-provided content)
- Medicine & health: MedlinePlus, NHS, Cochrane summaries, WHO. Polish: Narodowy Instytut Zdrowia Publicznego PZH, mp.pl (Medycyna Praktyczna)
- Law: official legislation databases (e.g. ISAP for Poland, legislation.gov.uk), Cornell LII
- Data & statistics: Our World in Data, Gapminder, national statistics offices. Polish: GUS

## Journalism & expert writing (cross-field)
- Quanta Magazine, Nature News, Scientific American, The Conversation (written by academics), Knowable Magazine, Aeon/Psyche, BBC Future
- Polish: Wiedza i Życie, Świat Nauki, Polityka (Niezbędnik, Pomocnik Historyczny), Nauka w Polsce (PAP), Delta

## Academic entry points
- Annual Reviews (any field), Nature Reviews, Trends in …, Reviews of Modern Physics, Living Reviews, review articles on arXiv, SSRN or PubMed Central (open access)

## Institutions, museums & interactive
- Science: NASA, ESA, CERN, ESO, NOAA, USGS, PhET simulations
- Culture & history: British Museum, Smithsonian, Metropolitan Museum of Art, Rijksmuseum, national archives
- Polish: Centrum Nauki Kopernik, Muzeum Narodowe (Warsaw/Kraków), Muzeum POLIN, Muzeum Historii Polski, CAMK PAN, culture.pl, Ninateka

## YouTube (cross-field first, then by field)
- EN cross-field: CrashCourse, Khan Academy, TED-Ed, university channels (MIT, Stanford, Yale, Royal Institution)
- EN by field: 3Blue1Brown and Numberphile (math), PBS Space Time (physics), Kurzgesagt and Veritasium (general science), Smarthistory (art), Extra History (history)
- PL: Nauka. To lubię, Uwaga! Naukowy Bełkot, Astrofaza, Pi-stacja, Centrum Nauki Kopernik

## Podcasts
- EN: BBC In Our Time (any field), BBC Radio 4 documentaries, Sean Carroll's Mindscape, Radiolab
- PL: Radio Naukowe (any field)

## Blocklist
Shared, well-justified exclusions only (e.g. known misinformation outlets). Personal dislikes belong in `my-sources.md`.
