# पुष्पवेद — Pushpa Veda

**The World of Flowers & Ayurveda** — *"Where Nature Blooms into Knowledge."*

Pushpa Veda is an educational flower encyclopedia: botanical science, Ayurvedic and
traditional knowledge, cultural significance, gardening guidance and conservation —
built on traceable sources, with uncertainty stated plainly rather than papered over.

> **Name.** *Pushpa* (पुष्प) = flower; *Veda* (वेद) = knowledge. The project is named for
> the idea that a flower itself carries knowledge: **पुष्पं वेदयति ज्ञानम्** — "the flower
> imparts knowledge."

---

## 1. What is in this deliverable

| File | What it is |
|---|---|
| `pushpa-veda.html` | The complete, working website — a single self-contained HTML document. Open it in any browser (online or offline). No build step, no server, no dependencies. |
| `README.md` | This document — architecture, data model, how to run, deployment, and the content-verification workflow. |
| `schema.sql` | A normalised PostgreSQL schema for the full-stack version described in the brief. |
| `.env.example` | Example environment variables (placeholders only — no real secrets). |
| `images/` | 163 flower photographs (JPEG) — one for every species, sourced from Wikimedia Commons with per-image credit and licence. |

The site is a fully interactive application, not a mockup: every navigation link,
filter, search box, tab, quiz, comparison and collection control works.

---

## 2. The site as delivered (static edition)

A single self-contained file containing three layers:

- **Design system** — CSS custom properties, light + dark themes, responsive layout,
  reduced-motion support, WCAG-minded contrast and focus states.
- **Data layer** — a JavaScript dataset (`FLOWERS`, `CATEGORIES`, `COLORS`, `SEASONS`,
  `REGIONS`, `ARTICLES`) that mirrors the relational schema in `schema.sql`.
- **Application layer** — hash-based routing, search and multi-facet filtering,
  detail views with tabs, compare tool, quiz engine, and a local-storage collection.

### Features

**Homepage** — hero with global search; Flower of the Day (date-based rotation);
16 flower categories; colour explorer; season explorer; schematic world-region map;
featured learning collections; editorial article cards; full footer with policy links.

**Real flower photographs** — every species now ships with a genuine photograph sourced from
Wikimedia Commons, each with its photographer, licence and a link to the original file page
shown beneath the image (see §5a).

**Flower Encyclopedia** — **139 species across 56 plant families**, each with a dedicated
profile page containing:

- Identification & taxonomy (accepted name, synonyms, family, genus/species,
  Sanskrit/Hindi/Marathi and other regional names, distribution, habitat, conservation)
- Botanical characteristics (type, habit, size, flower & petal structure, leaf,
  fragrance, flowering period, pollination, fruit, lifespan, ecological role)
- Original vector botanical illustrations (see §5)
- Growing & gardening guide (sunlight, water, soil, temperature, humidity, propagation,
  season, fertiliser, pruning, pests, container, indoor/outdoor, time to flower,
  difficulty, Indian-climate suitability, wildlife value)
- Ayurveda profile (marked classical / partly-classical / not-classical)
- Research summary (labelled by study type)
- Safety information
- Cultural significance (labelled as interpretation)
- References & editorial methodology

**Ayurveda library** — a dedicated section that separates classical Ayurveda from folk
practice and modern wellness marketing, explains Rasa/Guna/Virya/Vipaka, and groups
species by their actual classical standing.

**Culture & heritage**, **Gardening**, **Science & research**, **Nature & conservation**
sections; **Articles**; **About**; and a full **Medical & Editorial Disclaimer**.

**Top 20 Flowers — In Depth** — a curated showcase of twenty flagship species, each with
a much fuller profile than the rest of the encyclopedia (see §6): overview, etymology,
taxonomy notes, distinguishing features, detailed botany with growth stages, an expanded
Ayurvedic profile with traditional actions (karma) and formulations, deeper research and
safety, a gardening calendar, cultural depth, and references.

**Flowers with No Ayurvedic Link** — a dedicated section collecting every species with no
classical Ayurvedic standing (82 of 139), grouped by origin and generated from each species'
own Ayurveda profile so it can never drift out of step (see §7).

**Wildflowers — Field List** — a deliberately plain section with **no extra detail by design**:
a compact table (name, family, colour, season, one field note) covering 55 wildflowers — 31 with
full profiles and 24 listed for reference only (see §8).

**Interactive tools** — advanced multi-facet search; compare two or three species
side by side (19 attributes); a quiz with easy/medium/hard levels; a personal
collection with private notes and CSV export; and an **Image Manager** that lets you
attach real photographs to any species (see §5).

**Multilingual UI** — the language switcher localises the **whole interface**, not just the
navigation (see §2a). English / हिन्दी / मराठी, plus a theme switcher and favourites counter.

### What the 139 species cover

The collection is deliberately broad, not just the famous flowers:

- **By origin** — Indian natives and long-naturalised species (124), plus garden,
temperate, tropical, desert, aquatic and Himalayan plants from around the world.
- **By role** — Ayurvedic and medicinal species (46 with a classical Ayurvedic
identity; 39 with research literature), sacred flowers (35), fragrant flowers (40),
edible flowers (21), pollinator plants (67), wildflowers (31), night-blooming flowers
(12), and 12 species flagged **toxic — handle with care** (oleander, datura, glory
lily, yellow oleander, rosary pea, larkspur, ageratum and others, each with prominent
warnings).
- **By habit** — trees, shrubs, vines, bulbs, corms, annuals, alpines, water plants,
epiphytic orchids and desert trees.

If a flower you expect is still missing, it can be added in minutes: copy any species
block in the data section of `pushpa-veda.html`, change the fields, and it appears
automatically in the encyclopedia, the category counts and the search.

### Running it

Just open `pushpa-veda.html`. That's it.

To serve it locally (optional):

```bash
python3 -m http.server 8000
# then open http://localhost:8000/pushpa-veda.html
```

---

## 2a. Interface translation — Hindi and Marathi

The language switcher (English / हिन्दी / मराठी) localises the **whole interface**, not just
the navigation. This was previously a real gap: only the nav translated and the rest of every
page stayed English.

**How it works.** The interface is rendered in English and then translated in the DOM from a
dictionary of **511 Hindi and 511 Marathi entries**, plus **17 pattern rules** for strings with a
variable part (counts, dates, photo credits, "Family: …"). Species names are taken from the
dataset's own Hindi / Marathi / Sanskrit name fields, so a flower appears as **कमल / पद्म**
rather than "Sacred Lotus". Category, colour, season and region names are translated as well.

**What is deliberately left in English:**

- **Latin binomials and family names** — *Nelumbo nucifera*, *Nelumbonaceae*. Scientific names;
  translating them would be wrong.
- **Detailed species prose** — the identification, botany, Ayurveda, research, safety and
  culture sections of every profile, and the in-depth reference text. That is a large body of
  technical botanical and Ayurvedic writing; machine-translating it would introduce errors
  precisely where accuracy matters most. It stays English for now, and the site says so on
  every page.
- **Brand names with no Devanagari form** — Unsplash, Pexels, Flickr and similar.

**Two design decisions worth knowing:**

1. **Paragraphs are translated whole or not at all.** A paragraph is translated only when every
   word of it is in the dictionary; otherwise the entire paragraph stays English. This avoids
   the half-translated sentences that read badly — a mixed paragraph is worse than an English
   one.
2. **A visible notice** appears at the top of each page in Hindi and Marathi, stating plainly
   what is translated and what remains in English.

**Typography.** Devanagari has no true italic, so the synthesised oblique looked wrong and
shifted the baseline. Hindi and Marathi views now switch to **Noto Sans Devanagari** and turn
off italics, with heading sizes tuned for the script.


### Translated species prose (staged)

Beyond the interface, the species prose is being translated in stages. Two stages are in:

- **Stage 1 — the card one-liner** (`fact`), 139 strings.
- **Stage 2 — the origin range** (`native`), 99 unique strings covering all 139 cards. This is
  the line under each flower's name, so the encyclopedia grid itself now reads in Hindi/Marathi.

Measured across the whole site, **English text fell from 100% to 29%** of rendered text runs.
The remaining English is the deep profile prose (identification, botany, Ayurveda, research,
safety, culture), Latin names and brand names.

**How it is done.** Strings go to the platform's translation tool with each item prefixed by
`[n]`. The numbering survives translation and allows exact re-alignment — a plain separator gets
partly mangled in large payloads, which silently corrupts the pairing. Results are written
straight to files, so the bulk text never has to pass through the conversation.

**Remaining stages**, in priority order: the identification fields (height, leaf, flowering —
many short and repeated), the gardening fields, safety notes, Ayurveda notes, research summaries,
cultural notes, then the 20 in-depth profiles.

**Extending it** is one line per string: add an entry to the `I18N` object in the data section
of `pushpa-veda.html` (or to the generator's dictionary in the source). Translating the
remaining prose is a separate editorial job — the mechanism is already in place.

---

## 3. Data model

The dataset is designed to map one-to-one onto a normalised relational schema
(see `schema.sql`). Core entities:

```
flowers ─┬─ taxonomy (family, genus, species, synonyms)
         ├─ regional_names (language, name, script, is_verified)
         ├─ flower_colors / flower_seasons / flower_regions  (many-to-many)
         ├─ ayurveda_profiles (rasa, guna, virya, vipaka, dosha, classical_status)
         ├─ traditional_uses ── preparations
         ├─ studies (type, summary, evidence_level, citation, doi)
         ├─ safety_notes (severity, note)
         ├─ images (asset, credit, licence, alt_text)
         ├─ sources (authority, reference, url, accessed_on)
         └─ categories / tags

articles ── article_sources
users ── collections ── collection_items (note, observed_on)
translations (entity, field, locale, value, is_machine, is_verified)
revisions (entity, field, old_value, new_value, reviewer, review_status, at)
```

**Review status** (required on every medical, botanical and safety field):
`draft → research_required → expert_review_required → verified → published → under_revision`.

---

## 4. Content accuracy & the verification workflow

Accuracy is the point of this project. The rules applied in the dataset:

1. **Botanical names** follow accepted nomenclature (Kew *Plants of the World Online*,
   IPNI). Hybrids carry the `×` marker. Where a name has been revised, the widely-used
   synonym is listed.
2. **Traditional medicine is tiered.** Each species is marked `classical`,
   `partial`, or `not classical`. Species that entered India after the Columbian
   exchange (marigold, frangipani, sunflower, bougainvillea) are explicitly *not*
   presented as classical Ayurvedic drugs.
3. **Research is labelled by study type** — phytochemistry, in-vitro, animal, human
   trial, toxicology. A laboratory finding is never presented as a clinical benefit.
4. **Conservation status** is shown only where it can be attributed to a reliable
   authority (e.g. the IUCN Red List). Where it could not be confirmed, the profile
   says so and asks you to verify — it does not guess.
5. **Missing values are marked, not invented.** "Not established in the consulted
   source" is a valid and frequent entry.
6. **No fabricated citations.** This edition summarises research *themes* and names the
   authoritative sources consulted, rather than listing individual papers that could
   not be verified. Per-study authors/years/journals/DOIs are recorded during editorial
   verification before any claim is marked *verified*.

**Authoritative sources consulted:** Kew Plants of the World Online · IPNI · Botanical
Survey of India · Ministry of AYUSH and official pharmacopoeial references · classical
Ayurvedic texts in reliable editions · PubMed and academic databases · IUCN Red List ·
reputable botanical gardens and herbaria.

---

## 5. The image space — swap in real photographs

The image space is **editable by design**. Every species falls back to an original
vector botanical illustration, and you can replace that with a real photograph at any
time — the site then shows the photograph everywhere the species appears (home cards,
the encyclopedia grid, the Flower of the Day, the detail page and your collection).
If a photograph is removed or fails to load, the illustration reappears automatically.

### Three ways to set an image

**1. In the browser — Tools → Image Manager** (fastest)
Every species gets a row with an **Image URL or path** field, an **Upload a file**
control, and **Credit** and **Licence** fields. Save and the change applies instantly
and is stored in your browser. Two export buttons let you make it permanent:

- **Export image map (JSON)** — a backup you can re-import later.
- **Get code block** — produces a ready-to-paste `const FLOWER_IMAGES = { … };` block.

**2. In the file — edit the `FLOWER_IMAGES` block** (permanent)
Near the end of the data section in `pushpa-veda.html` is an empty, documented
`const FLOWER_IMAGES = {};`. Paste the code block from the Image Manager over that
line, or write entries by hand:

```js
const FLOWER_IMAGES = {
  "nelumbo-nucifera": {
    src: "images/lotus.jpg",                 // URL or relative path
    alt: "Pink sacred lotus in full bloom",  // required for accessibility
    credit: "Jane Doe",                      // shown with the photo
    licence: "CC0"                           // shown with the photo
  },
};
```

A relative `src` like `images/lotus.jpg` resolves next to the HTML file, so you can
keep a folder of photographs beside `pushpa-veda.html` and reference them by name.
This is the recommended approach for a large set of high-resolution photographs
(browsers cap how much can be stored in local storage).

**3. Import a JSON map** — drop a previously exported `pushpa-veda-images.json` into
the Image Manager to restore or move your image set.

### Choosing images you may actually use

Use only images you are permitted to use for **both personal and commercial**
purposes. Good sources include:

- **Your own photographs** (best — no restrictions).
- **CC0 / Public Domain** works — e.g. Wikimedia Commons (public-domain items),
  Openverse filtered to CC0/PDM, and similar archives.
- **Stock services whose licence allows commercial use** — e.g. Pexels, Pixabay,
  Unsplash. Check each image's own page; some contributors set extra conditions and
  some platforms discourage redistribution as a competing service.

Always fill in **credit** and **licence**; both are displayed beneath the photo on the
detail page and as a tooltip on cards. Never use images of unknown origin.

### Practical notes

- **Shape:** cards use a 4:3 crop and the detail hero is roughly square, so a
  landscape photo around **1200 × 900 px** works well across the site.
- **Weight:** aim for under ~300 KB per photo; the site lazy-loads images.
- **Alt text:** write a short description ("Pink sacred lotus in full bloom on still
  water") — the Image Manager generates a sensible default from the species name,
  but you can refine it in the exported block.
- **The vector illustrations remain in the file**, so nothing is lost — clearing a
  photograph restores the original artwork.

The production data model already carries a dedicated `images` table (asset, role,
alt text, credit, licence), so this same workflow scales to the full-stack deployment.

### Where to find free flower photos

Checked against the licence pages themselves. **Commercial use, no attribution required:**

- **Unsplash** — unsplash.com/license. Irrevocable, worldwide licence, commercial use allowed,
  no credit needed. You may not sell unaltered photos or compile them into a competing
  service. (Unsplash+ images are a separate, paid catalogue.)
- **Pexels** — pexels.com/license. Free commercial use, no attribution. No unaltered resale;
  no implying endorsement by people or brands shown.
- **Pixabay** — pixabay.com. The Pixabay Content License allows commercial use with no
  attribution. Uploads made before January 2019 were released as **CC0**, which is even
  more permissive.
- **Also free for commercial use:** StockSnap.io (CC0), Burst by Shopify, Reshot,
  freeforcommercialuse.net (CC0).

**Species-identified photos — check the licence, credit may be required:**

- **Wikimedia Commons** — commons.wikimedia.org. Accepts only free licences. **CC0 and public
  domain** carry no conditions; **CC BY and CC BY-SA require credit**, and ShareAlike means
  any derivative must carry the same licence. This is the best source when you need a photo
  labelled with a scientific name — exactly what a flower encyclopedia needs.
- **Flickr** — flickr.com. Use the licence filter in search: CC0, Public Domain Mark,
  CC BY, CC BY-SA.
- **Openverse** — openverse.org. Searches openly-licensed images across many sources;
  filter to CC0 / public domain for zero conditions.

**Historic botanical illustrations — public domain:**

- **Biodiversity Heritage Library** — biodiversitylibrary.org, with 300,000+ plates also on
  Flickr. Public-domain works are free to reuse **including commercially**; in-copyright
  items sit under CC BY-NC-SA, which is **not** usable commercially. Verify each item's
  copyright status.

**Three cautions worth remembering**

1. A photo licence covers the **photographer's copyright only**. It does not cover model
   releases, or trademarks and logos visible inside the frame.
2. Never resell unaltered photos, and never rebuild a competing stock library from them.
3. Licences can change for new downloads — Pixabay moved from CC0 to its own licence in 2019.
   **Keep a dated note of the licence you downloaded under** with the asset. The site's
   Image Manager already stores credit and licence per photo; use those fields.

**Recommendation for this project:** use **Wikimedia Commons** for species-level photographs
(so the photo genuinely shows the species named) and the **Biodiversity Heritage Library** for
historic botanical plates; fall back to Unsplash/Pexels/Pixabay for general imagery. Record
credit and licence for every image either way.

---

## 5a. The photographs shipped with this edition

**163 photographs** — one for **every** species (139 encyclopedia profiles + 24 listed
wildflowers). All come from **Wikimedia Commons** and all are under licences that permit
commercial use. They are stored in `images/` and referenced by the `FLOWER_IMAGES` block in the
data section of `pushpa-veda.html`.

**Licences used** (no NC or ND anywhere; **125 require attribution, 38 do not**):

| Licence | Count | Attribution required? |
|---|---|---|
| CC BY-SA 4.0 | 72 | Yes |
| CC BY-SA 3.0 | 32 | Yes |
| CC0 | 24 | No |
| CC BY 4.0 | 14 | Yes |
| Public domain | 14 | No |
| CC BY-SA 2.0 | 3 | Yes |
| CC BY 2.0 | 2 | Yes |
| CC BY 3.0 / CC BY 3.0 US | 2 | Yes |

**Attribution is displayed, not just stored.** Every photo shows `Photo: <photographer> ·
<licence> · source` beneath the image, with the "source" being a link to the original Commons
file page. That satisfies the attribution and licence-notice requirements of CC BY and CC BY-SA,
and the images themselves are redistributed **unmodified** (they are the thumbnails Wikimedia
generated, so no derivative-work question arises for ShareAlike).

**How they were chosen — and what to watch for.** Photos were selected by searching Commons for
each species' accepted scientific name, then filtered to reject line drawings and botanical
plates, herbarium sheets, seed-pod and leaf studies, book pages, and near-white images (a
pixel test catches plates on paper). Every image was then reviewed visually and roughly forty
were replaced or hand-picked. **Commons identifications are community-contributed and are not
independently verified here** — treat the species match as provisional and confirm it yourself
before relying on a photograph. The site says this on every profile too.

**Coverage:** every species has a photograph. Where an early automatic pick was wrong (a line
drawing, a book page, seed pods, a bare tree), the image was re-fetched under stricter rules or
chosen by hand from the Commons candidates. Any image can still be replaced through the Image
Manager (see §5), and clearing one now sticks — the built-in photo does not come back.

**Hosting.** The photographs are served from the project's own GitHub Pages site
(`…github.io/pushpa-veda/images/…`), so the single-file `pushpa-veda.html` works online without
any third party being hotlinked. Opened offline with no `images/` folder beside it, the page
degrades gracefully to the vector illustrations.

---

## 6. The Top 20 In-Depth profiles

Twenty species are given the fullest treatment in the project — reachable from the
**Top 20 In Depth** item in the navigation, from the home-page showcase, and from an
**★ In depth** tab that appears on those species' own profile pages.

**The twenty:** Sacred Lotus · Hibiscus · Arabian Jasmine (Mogra) · Damask Rose ·
African Marigold · Butterfly Pea (Shankhapushpi) · Holy Basil (Tulsi) · Neem ·
Ashwagandha · Shatavari · Arjuna · Bael (Bilva) · Moringa · Ashoka · Nagkesar ·
Dhataki · Pomegranate · Sandalwood · Parijat · Chrysanthemum.

**What each in-depth profile contains:**

- **Overview** — two or three paragraphs setting out what the flower is and why it matters.
- **Etymology** — where the botanical and common names come from.
- **Taxonomy notes** — the accepted family and any synonym traps.
- **How to tell it apart** — distinguishing features, including common confusions.
- **Botanical description** — an expanded account of the plant and its structures.
- **Growth stages** — bud, bloom, leaf, fruit and any special stage, as cards.
- **Traditional Ayurvedic profile (expanded)** — part used, Rasa, Guna, Virya, Vipaka,
  Dosha, plus **traditional actions (karma)**, **formulations**, **classical context** and
  **regional variation**.
- **Research (expanded)** — findings grouped by study type, and an explicit note on
  *what would be needed to prove a benefit*.
- **Safety (expanded)** and **Gardening (expanded)** with a seasonal calendar.
- **Culture & meaning**, **Did you know?**, and **References**.

**On the references.** Classical texts are named as a *corpus* — Charaka Samhita,
Sushruta Samhita and the nighantus — and each profile states plainly that exact verses
and formulations must be verified against a reliable edition or an official
pharmacopoeia. No specific verse, page or DOI is asserted. This is deliberate: it is
better to name the source honestly than to invent a citation.

**Which species were chosen, and why.** The twenty span the range of the project: the
most culturally central Indian flowers (lotus, marigold, parijat, mogra), the
best-documented classical Ayurvedic plants (Tulsi, Neem, Ashwagandha, Shatavari,
Arjuna, Bael, Ashoka, Nagkesar, Dhataki, Pomegranate, Sandalwood), a food plant
(Moringa), and a few global favourites (rose, hibiscus, chrysanthemum). Two of them —
the Damask rose and the chrysanthemum — are included *because* they are commonly
mislabelled as Ayurvedic, and their profiles say clearly that they are not classical.

Adding an in-depth profile for another species is straightforward: add an entry to the
`DEEP` object in the data section of `pushpa-veda.html`, keyed by the species id.

---

## 7. The "No Ayurvedic Link" section

The collection is now split explicitly into its two halves. Every species carries an Ayurveda
tab marked **classical**, **partly classical** or **not classical**, and a dedicated section
collects the **not classical** group — **82 of the 139 species (59%)**.

**How it is built — and why it cannot go stale.** The section is generated at render time from
each species' own `ayurveda.classical` value, and the browse tags are derived the same way. A
species is therefore always in exactly one group:

- **Ayurvedic** (classical + partly classical): **57 species**
- **No Ayurvedic link** (not classical): **82 species**
- 57 + 82 = 139, with no overlaps and no gaps.

Change a species' Ayurveda status and it moves itself. This edit also fixed eleven species
whose "Ayurvedic" tag had been missing, so the two groups are now perfectly complementary.

**Where it is reachable:** the navigation ("Non-Ayurvedic"), the home-page category grid, the
footer, and a cross-link at the foot of the Ayurveda page.

**Grouped, not dumped.** The 82 species are presented in three groups rather than one long list:

- **New-World plants** (32) — native to the Americas, so no classical claim about them is even
  possible; they reached India only after the sixteenth-century exchange of crops.
- **Temperate, Mediterranean and East Asian garden flowers** — grown in India chiefly as
  ornamentals and cut flowers, many only in hill gardens.
- **Other ornamentals, orchids and tropical shrubs.**

**Two honest caveats are stated on the page itself.** First, "no Ayurvedic link" does not mean
"no cultural value": Burans, Brahma Kamal, the foxtail orchid and kanakambaram are culturally
important Indian flowers that simply have no classical medicinal standing. Second, a few species
in the section carry regional *folk* uses on their pages — folk practice is not Ayurveda, and it
is labelled as such there. The page also repeats that being outside Ayurveda does not make a
plant safe: several species in it (oleander, yellow oleander, lantana, ageratum, larkspur,
periwinkle) are toxic.

---

## 8. The Wildflower Field List

A separate section, **deliberately plain** — no deep profiles, no expanded panels, no research
tables. Wildflowers are usually identified in the field, quickly and often on poor signal, so a
compact table serves better than a long profile. Each row gives the common name, scientific name,
family, flower colour, flowering time and one field note; species with a full profile link
straight through to it.

**55 species in total:**

- **31 wildflowers with full profiles** — the species already in the encyclopedia that carry the
  "wildflower" tag, shown here in compact form.
- **24 wildflowers listed for reference only** — light entries added specifically for this
  section. They carry **no Ayurveda, research or safety data** beyond a short caution, and they
  are deliberately kept **out** of the main encyclopedia and out of search, because they have no
  full profile yet. Each is marked **listed**.

The 24 listed species are common wild and wayside plants: coat buttons, Mexican poppy, dayflower,
purslane, wood sorrel, little ironweed, lilac tasselflower, wedelia, chicory, dandelion, red
clover, ox-eye daisy, yarrow, St John's wort, common mallow, scarlet pimpernel, field bindweed,
primrose, foxglove, bird's-foot trefoil, sweet violet, evening primrose, creeping buttercup and
chickweed.

**A filter box** narrows the list by name, family or season, and the page states plainly that a
one-line description is never enough to justify eating or using a wild plant. Three of the listed
species — Mexican poppy, foxglove and creeping buttercup — carry a **Toxic** tag.

**Promoting a listed species to a full profile** is a copy-and-paste job: move its entry from
`WILDFLOWER_LIST` into `FLOWERS` in the data section of `pushpa-veda.html` and fill in the
remaining fields. It then joins the encyclopedia, the search and the category counts
automatically.

---

## 9. Path to the full-stack deployment

The static edition is a faithful, runnable slice of the production plan. The brief's
preferred stack maps onto it as follows:

| Brief | This edition | Production target |
|---|---|---|
| Next.js + TypeScript + React | Vanilla JS SPA, single file | Next.js (SSR/SSG), TypeScript |
| Tailwind CSS | Hand-written CSS design system | Tailwind + the same tokens |
| PostgreSQL + ORM | JS dataset | PostgreSQL + Prisma/Drizzle (`schema.sql`) |
| Secure backend API | in-browser logic | Route handlers with validation + rate limiting |
| Headless CMS / admin | review-status model in data | Admin dashboard + review workflow |
| Cloud image storage | vector illustrations | object storage + CDN + optimised images |
| Search | client-side facet filter | indexed search (Postgres FTS / Meilisearch) |

**Installation (production path):**

```bash
npm install
cp .env.example .env        # fill in your own values — never commit .env
npx prisma migrate deploy   # apply schema
npm run seed                # load the flower dataset
npm run dev                 # http://localhost:3000
```

**Deployment:** deploy to a Node host or serverless platform; run migrations against a
managed PostgreSQL instance; put images on object storage behind a CDN; set secrets via
the platform's environment configuration (never in client code). Health-check the API,
enable caching headers for static assets, and rate-limit public endpoints.

**Backup & maintenance:** nightly database backups with tested restore; revision history
retained per the `revisions` table; periodic re-verification of medical and conservation
fields against their cited sources.

---

## 10. Safety, disclaimers and scope

- **Educational use only.** Pushpa Veda is not medical advice, diagnosis or treatment,
  and is not a substitute for professional guidance.
- **Toxicity is real.** Several profiled species (oleander, datura, glory lily) are
  seriously toxic; they are included for education with prominent warnings. Never eat
  or use any plant medicinally based on this site.
- **Misidentification is a leading cause of poisoning.** Confirm a species before any use.
- **Cultural meanings are interpretation**, vary by region and community, and are not
  presented as universal fact.
- **Sample/placeholder content** is labelled as such. Fields awaiting expert review are
  marked "needs verification" rather than asserted.

---

## 11. Accessibility & performance

- Semantic HTML, landmark regions, skip link, labelled controls, keyboard-operable
  cards and menus, `role`/`aria-label` on interactive elements.
- Light and dark themes with contrast-aware palettes.
- `prefers-reduced-motion` respected throughout.
- No external runtime dependencies beyond web fonts (with system fallbacks); the page
  renders and functions offline.

---

*Pushpa Veda — पुष्पवेद · Discover the beauty, science and ancient wisdom of flowers.*
