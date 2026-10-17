# /knowledge

*Created by [Dariusz Jędrzejczyk](https://github.com/chemicL) · [github.com/chemicL/knowledge-skill](https://github.com/chemicL/knowledge-skill)*

A Claude skill that turns a question into a **verified study map** instead of an answer. It returns books first, plus papers, open courses, articles, videos and podcasts, grouped into *For kids*, *Popular knowledge* and *Academic* tracks. Free sources come first, and the depth matches how the question is asked.

```
/knowledge are there more solar systems in our galaxy?
/knowledge --level expert how do CRDTs handle concurrent deletes?
/knowledge czy w naszej galaktyce są inne układy planetarne?
/knowledge --kids why do volcanoes erupt?
```

Options:
- `--level beginner|intermediate|expert` overrides the level the skill infers from how you asked.
- `--kids` gives children's material only, split into age bands (3-6, 7-10, 11-14).

If a question can mean several things, the skill asks you which one before searching.

Every reference is checked live (Open Library, Biblioteka Narodowa, OpenAlex, YouTube oEmbed, iTunes, page fetch). Anything that can't be confirmed is dropped.

## Languages

**English and Polish are supported by design.** The output language follows the question.
- **Polish question:** Polish sources come first in every track, found through the Polish national library catalogue (Biblioteka Narodowa), lubimyczytac.pl and Polish institutions and media. English material is a last resort, marked 🇬🇧 and explained with a `Why English:` line. Buy links point to Allegro, empik and Amazon.pl.
- **English question:** English sources. A Polish edition is noted when one exists. Buy links point to Amazon only.

Other languages get output in that language, but the catalogue lookups, trusted sources and shops are only tuned for English and Polish.

## Install

### Claude Code (terminal, IDE extensions, and the Code tab of the desktop app)

```
git clone https://github.com/chemicL/knowledge-skill.git
cd knowledge-skill
./install.sh
```

This copies `skill/` to `~/.claude/skills/knowledge/` and creates your personal sources file (see below). Run it again after editing, and start a new session to pick up changes. The desktop app's **Code** tab loads skills from `~/.claude/skills/` too, so this one install covers the terminal, IDEs and the desktop Code tab. Type `/knowledge` there.

### Claude desktop / web app (regular chat)

1. Build the upload package:
   ```
   ./package.sh
   ```
   This creates `dist/knowledge.zip`. The packaged `SKILL.md` drops the `argument-hint` field, because the chat app rejects uploads that contain it, and it replaces the Claude Code-only `$ARGUMENTS` placeholder.
2. In the app, turn on **Settings → Capabilities → Code execution and file creation**. Skills need it.
3. Go to **Customize → Skills** (claude.ai/customize/skills), click **+ → Create skill → Upload a skill**, and choose `dist/knowledge.zip`. Some docs describe the menu as *Settings → Features*.
4. Turn on **web search** in the chat (the **+** button in the message box).

Limitations of the chat version:
- **No slash command.** Chat skills are picked automatically from their description, so ask naturally: *"Build me a knowledge map: are there more solar systems in our galaxy?"* You can add `--level expert` or `--kids` to the message.
- **Verification may be weaker.** The skill looks up catalogues such as openlibrary.org and data.bn.org.pl. In chat, those requests depend on your network settings. Under **Settings → Capabilities**, set *Allow network egress* to **Full** for the most reliable results. With restricted access, some checks can fail, and unverifiable items get dropped, so expect shorter lists.
- **No personal sources file.** The chat app can't read `~/.claude/knowledge/my-sources.md`. To use your own preferences there, add them to `skill/trusted-sources.md` in a private copy before packaging.
- Skills uploaded to the chat app may also show up in Claude Code sessions. If you see `/knowledge` twice, disable one of them.

## Layout

| Path | What |
|---|---|
| `skill/SKILL.md` | Workflow, rules, output format |
| `skill/verification.md` | How each source type is found and verified; buy-link formats |
| `skill/trusted-sources.md` | Shared default hints, how to infer trust in any field, and the blocklist (keep generic) |
| `templates/my-sources.md` | Template for your personal layer |
| `install.sh` | Installs for Claude Code |
| `package.sh` | Builds `dist/knowledge.zip` for the desktop/web chat app |

## Personal preferences

Your own trusted sources and blocklist go in `~/.claude/knowledge/my-sources.md`. The installer creates it once and never overwrites it. It takes precedence over `skill/trusted-sources.md`, so this folder stays a clean slate you can share. This applies to Claude Code only; see the limitations above for the chat app.

## License

[MIT](LICENSE) © 2026 Dariusz Jędrzejczyk. If you share a modified version, keep the copyright notice and a link back to [github.com/chemicL/knowledge-skill](https://github.com/chemicL/knowledge-skill).
