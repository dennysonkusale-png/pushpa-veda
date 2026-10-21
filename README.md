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

**Interactive tools** — advanced multi-facet search; compare two or three species
side by side (19 attributes); a quiz with easy/medium/hard levels; a personal
collection with private notes and CSV export; and an **Image Manager** that lets you
attach real photographs to any species (see §5).

**Multilingual UI** — English / हिन्दी / मराठी interface chrome, a theme switcher, a
language selector and a favourites counter in the navigation.

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

## 7. Path to the full-stack deployment

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

## 8. Safety, disclaimers and scope

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

## 9. Accessibility & performance

- Semantic HTML, landmark regions, skip link, labelled controls, keyboard-operable
  cards and menus, `role`/`aria-label` on interactive elements.
- Light and dark themes with contrast-aware palettes.
- `prefers-reduced-motion` respected throughout.
- No external runtime dependencies beyond web fonts (with system fallbacks); the page
  renders and functions offline.

---

*Pushpa Veda — पुष्पवेद · Discover the beauty, science and ancient wisdom of flowers.*
