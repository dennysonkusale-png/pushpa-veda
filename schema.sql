-- ============================================================================
-- PUSHPA VEDA — PostgreSQL schema (production path)
-- Normalised model for a flowers + Ayurveda encyclopedia.
-- Every medical / botanical / safety field supports a review status, and
-- important content keeps a revision history (see revisions table).
-- ============================================================================

CREATE TYPE review_status AS ENUM (
  'draft', 'research_required', 'expert_review_required',
  'verified', 'published', 'under_revision'
);
CREATE TYPE ayurveda_status AS ENUM ('classical', 'partial', 'not_classical');
CREATE TYPE evidence_level AS ENUM (
  'phytochemistry', 'in_vitro', 'animal', 'human_trial', 'toxicology', 'review'
);
CREATE TYPE toxicity_severity AS ENUM ('none_known', 'caution', 'danger', 'fatal');

-- ---------- Taxonomy ----------
CREATE TABLE families (
  id           SERIAL PRIMARY KEY,
  name         TEXT NOT NULL UNIQUE,           -- e.g. 'Fabaceae'
  common_note  TEXT
);

CREATE TABLE flowers (
  id             SERIAL PRIMARY KEY,
  slug           TEXT NOT NULL UNIQUE,          -- stable URL id
  common_name    TEXT NOT NULL,
  scientific_name TEXT NOT NULL,               -- accepted name (Kew POWO / IPNI)
  genus          TEXT NOT NULL,
  species        TEXT NOT NULL,
  family_id      INTEGER NOT NULL REFERENCES families(id),
  plant_type     TEXT,
  growth_habit   TEXT,
  height         TEXT,
  spread         TEXT,
  flower_shape   TEXT,
  petal_structure TEXT,
  leaf           TEXT,
  fragrance      TEXT,
  flowering_period TEXT,
  pollination    TEXT,
  fruit_seed     TEXT,
  lifespan       TEXT,
  native_distribution TEXT,
  natural_habitat     TEXT,
  ecological_role     TEXT,
  botanical_fact      TEXT,
  cultural_significance TEXT,                  -- labelled as interpretation in the UI
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_flowers_family ON flowers(family_id);
CREATE INDEX idx_flowers_name ON flowers USING gin (to_tsvector('simple', common_name || ' ' || scientific_name));

CREATE TABLE synonyms (
  id         SERIAL PRIMARY KEY,
  flower_id  INTEGER NOT NULL REFERENCES flowers(id) ON DELETE CASCADE,
  name       TEXT NOT NULL,
  note       TEXT
);

-- ---------- Regional / multilingual names ----------
CREATE TABLE languages (code TEXT PRIMARY KEY, name TEXT NOT NULL);  -- en, hi, mr, sa, ta ...

CREATE TABLE regional_names (
  id         SERIAL PRIMARY KEY,
  flower_id  INTEGER NOT NULL REFERENCES flowers(id) ON DELETE CASCADE,
  lang_code  TEXT NOT NULL REFERENCES languages(code),
  name       TEXT NOT NULL,
  script     TEXT,                              -- e.g. 'Devanagari'
  is_verified BOOLEAN NOT NULL DEFAULT false,   -- never present unverified as accepted
  source_id  INTEGER REFERENCES sources(id)
);
CREATE INDEX idx_regional_names_flower ON regional_names(flower_id);

-- ---------- Facets (many-to-many) ----------
CREATE TABLE colors  (id SERIAL PRIMARY KEY, name TEXT UNIQUE NOT NULL, hex TEXT);
CREATE TABLE seasons (id SERIAL PRIMARY KEY, code TEXT UNIQUE NOT NULL, name TEXT, description TEXT);
CREATE TABLE regions (id SERIAL PRIMARY KEY, code TEXT UNIQUE NOT NULL, name TEXT,
                      status TEXT CHECK (status IN ('native','introduced','cultivated','naturalized')));
CREATE TABLE categories (id SERIAL PRIMARY KEY, code TEXT UNIQUE NOT NULL, name TEXT, description TEXT);

CREATE TABLE flower_colors    (flower_id INT REFERENCES flowers(id) ON DELETE CASCADE, color_id INT REFERENCES colors(id),    PRIMARY KEY (flower_id, color_id));
CREATE TABLE flower_seasons   (flower_id INT REFERENCES flowers(id) ON DELETE CASCADE, season_id INT REFERENCES seasons(id),  PRIMARY KEY (flower_id, season_id));
CREATE TABLE flower_regions   (flower_id INT REFERENCES flowers(id) ON DELETE CASCADE, region_id INT REFERENCES regions(id),  PRIMARY KEY (flower_id, region_id));
CREATE TABLE flower_categories(flower_id INT REFERENCES flowers(id) ON DELETE CASCADE, category_id INT REFERENCES categories(id), PRIMARY KEY (flower_id, category_id));

-- ---------- Gardening ----------
CREATE TABLE gardening_profiles (
  flower_id     INTEGER PRIMARY KEY REFERENCES flowers(id) ON DELETE CASCADE,
  sunlight      TEXT, water TEXT, soil TEXT, temperature TEXT, humidity TEXT,
  propagation   TEXT, planting_season TEXT, fertiliser TEXT, pruning TEXT,
  pests_diseases TEXT, container_ok BOOLEAN, indoor_ok BOOLEAN,
  time_to_flower TEXT, difficulty TEXT, india_suitability TEXT, wildlife_benefits TEXT,
  review_status review_status NOT NULL DEFAULT 'draft'
);

-- ---------- Ayurveda / traditional knowledge ----------
CREATE TABLE ayurveda_profiles (
  flower_id       INTEGER PRIMARY KEY REFERENCES flowers(id) ON DELETE CASCADE,
  classical_status ayurveda_status NOT NULL DEFAULT 'not_classical',
  sanskrit_name   TEXT,
  part_used       TEXT,
  rasa            TEXT,
  guna            TEXT,
  virya           TEXT,
  vipaka          TEXT,
  dosha           TEXT,
  notes           TEXT,
  review_status   review_status NOT NULL DEFAULT 'draft',
  reviewed_by     INTEGER REFERENCES users(id),
  reviewed_at     TIMESTAMPTZ
);

CREATE TABLE traditional_uses (
  id          SERIAL PRIMARY KEY,
  flower_id   INTEGER NOT NULL REFERENCES flowers(id) ON DELETE CASCADE,
  kind        TEXT CHECK (kind IN ('classical','folk','culinary','aromatic','cosmetic','ritual')),
  description TEXT NOT NULL,
  source_id   INTEGER REFERENCES sources(id),
  review_status review_status NOT NULL DEFAULT 'draft'
);

CREATE TABLE preparations (
  id       SERIAL PRIMARY KEY,
  use_id   INTEGER NOT NULL REFERENCES traditional_uses(id) ON DELETE CASCADE,
  name     TEXT NOT NULL,
  note     TEXT
);

-- ---------- Research ----------
CREATE TABLE studies (
  id             SERIAL PRIMARY KEY,
  flower_id      INTEGER NOT NULL REFERENCES flowers(id) ON DELETE CASCADE,
  evidence_level evidence_level NOT NULL,
  summary        TEXT NOT NULL,
  authors        TEXT,                          -- recorded during editorial verification
  year           INTEGER,
  journal        TEXT,
  doi            TEXT,
  url            TEXT,
  limitations    TEXT,
  source_id      INTEGER REFERENCES sources(id),
  review_status  review_status NOT NULL DEFAULT 'draft'
);
CREATE INDEX idx_studies_flower ON studies(flower_id);

-- ---------- Safety ----------
CREATE TABLE safety_notes (
  id         SERIAL PRIMARY KEY,
  flower_id  INTEGER NOT NULL REFERENCES flowers(id) ON DELETE CASCADE,
  severity   toxicity_severity NOT NULL DEFAULT 'caution',
  note       TEXT NOT NULL,
  review_status review_status NOT NULL DEFAULT 'draft'
);

-- ---------- Conservation ----------
CREATE TABLE conservation (
  flower_id  INTEGER PRIMARY KEY REFERENCES flowers(id) ON DELETE CASCADE,
  status_label TEXT,                            -- shown only if attributable to an authority
  authority  TEXT,                              -- e.g. 'IUCN Red List'
  basis      TEXT,
  verified   BOOLEAN NOT NULL DEFAULT false
);

-- ---------- Media ----------
CREATE TABLE images (
  id         SERIAL PRIMARY KEY,
  flower_id  INTEGER REFERENCES flowers(id) ON DELETE CASCADE,
  role       TEXT CHECK (role IN ('flower','petal','bud','leaf','plant','fruit','habitat','illustration')),
  asset_url  TEXT NOT NULL,
  alt_text   TEXT NOT NULL,                     -- required for accessibility
  credit     TEXT,
  licence    TEXT,
  is_vector  BOOLEAN NOT NULL DEFAULT false
);

-- ---------- Sources & citations ----------
CREATE TABLE sources (
  id          SERIAL PRIMARY KEY,
  authority   TEXT NOT NULL,                    -- e.g. 'Kew POWO', 'IUCN', 'AYUSH'
  reference   TEXT NOT NULL,
  url         TEXT,
  accessed_on DATE
);

-- ---------- Editorial ----------
CREATE TABLE articles (
  id         SERIAL PRIMARY KEY,
  slug       TEXT UNIQUE NOT NULL,
  title      TEXT NOT NULL,
  tag        TEXT,
  body       TEXT,
  status     review_status NOT NULL DEFAULT 'draft',
  published_at TIMESTAMPTZ,
  author_id  INTEGER REFERENCES users(id)
);

-- ---------- Users, collections, translations, revisions ----------
CREATE TABLE users (
  id         SERIAL PRIMARY KEY,
  email      TEXT UNIQUE NOT NULL,
  display_name TEXT,
  role       TEXT NOT NULL DEFAULT 'viewer' CHECK (role IN ('viewer','editor','expert','admin')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE collections (
  id        SERIAL PRIMARY KEY,
  user_id   INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name      TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE collection_items (
  id          SERIAL PRIMARY KEY,
  collection_id INTEGER NOT NULL REFERENCES collections(id) ON DELETE CASCADE,
  flower_id   INTEGER NOT NULL REFERENCES flowers(id) ON DELETE CASCADE,
  note        TEXT,
  observed_on DATE,
  UNIQUE (collection_id, flower_id)
);

CREATE TABLE translations (
  id          SERIAL PRIMARY KEY,
  entity      TEXT NOT NULL,                    -- e.g. 'flower'
  entity_id   INTEGER NOT NULL,
  field       TEXT NOT NULL,
  locale      TEXT NOT NULL,
  value       TEXT NOT NULL,
  is_machine  BOOLEAN NOT NULL DEFAULT true,
  is_verified BOOLEAN NOT NULL DEFAULT false,   -- never claim machine translation is expert-verified
  UNIQUE (entity, entity_id, field, locale)
);

CREATE TABLE revisions (
  id          SERIAL PRIMARY KEY,
  entity      TEXT NOT NULL,
  entity_id   INTEGER NOT NULL,
  field       TEXT NOT NULL,
  old_value   TEXT,
  new_value   TEXT,
  review_status review_status NOT NULL DEFAULT 'draft',
  reviewer_id INTEGER REFERENCES users(id),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_revisions_entity ON revisions(entity, entity_id);
