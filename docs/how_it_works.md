# How Everything Works — End to End

## 1. The Story

We wrote Rahul's therapy journey in `stories/rahul_journey.md` — 8 weeks of treatment at Lumio covering his anxiety diagnosis, CBT therapy, medication, setbacks, and progress.

**Characters:** Rahul (patient), Dr. Sharma (therapist), Dr. Mehta (psychiatrist), Anita (coordinator), Priya (wife)

---

## 2. Story → Knowledge Graph

We extracted every fact from the story and converted it into **nodes** and **relationships** using Cypher queries, pushed directly to **Neo4j Aura** cloud database via MCP.

```
Story text → Identify entities → Write Cypher CREATE statements → MCP executes on Neo4j
```

**Result:** 43 nodes (17 types) + 66 relationships (36 types) — all live in Neo4j.

### Node Types Created

| Node Type          | Count | Example                                    |
|--------------------|-------|--------------------------------------------|
| Session            | 6     | Session 1 (intake), Session 5 (therapy)    |
| Transcription      | 6     | Transcript for each session                |
| Symptom            | 5     | insomnia, worry, rumination, nausea, hopelessness |
| Assessment         | 4     | PHQ-9: 18, GAD-7: 15, PHQ-9: 14, GAD-7: 12 |
| Insight            | 4     | "Work deadlines trigger anxiety spirals"   |
| Diagnosis          | 2     | GAD (F41.1), MDD (F32.1)                  |
| Medication         | 2     | Sertraline, Tramadol (interaction ref)     |
| CarePlan           | 2     | Plan v1, Plan v2                           |
| Topic              | 2     | work deadline pressure, sleep improvement  |
| Member             | 1     | Rahul Kapoor                               |
| FamilyMember       | 1     | Priya Kapoor                               |
| Therapist          | 1     | Dr. Ananya Sharma                          |
| Psychiatrist       | 1     | Dr. Vikram Mehta                           |
| CareCoordinator    | 1     | Anita Desai                                |
| TherapyType        | 1     | CBT                                        |
| TherapeuticTechnique | 1   | Thought Record                             |
| JournalEntry       | 1     | "Can't stop thinking about presentation"   |
| MoodLog            | 1     | mood: low, energy: 3, sleep: 3.5hrs       |

### Key Relationship Types (36 total)

| Relationship         | What it connects              | Example                                |
|----------------------|-------------------------------|----------------------------------------|
| TREATED_BY           | Member → Therapist            | Rahul → Dr. Sharma                     |
| DIAGNOSED_WITH       | Member → Diagnosis            | Rahul → GAD                            |
| EXHIBITS             | Member → Symptom              | Rahul → insomnia                       |
| TAKES                | Member → Medication           | Rahul → Sertraline                     |
| ATTENDED             | Member → Session              | Rahul → Session 1                      |
| ASSESSED_WITH        | Member → Assessment           | Rahul → PHQ-9: 18                      |
| MANIFESTS_AS         | Diagnosis → Symptom           | GAD → excessive worry                  |
| CAUSES               | Medication → Symptom          | Sertraline → nausea                    |
| PRODUCED             | Session → Insight             | Session 8 → "Sleep regression from dose" |
| COMPARED_TO          | Assessment → Assessment       | PHQ-9: 18 → PHQ-9: 14 (improved)      |
| PRECEDED_BY          | Symptom → Symptom             | insomnia → rumination (always)         |
| EVOLVED_TO           | Diagnosis → Diagnosis         | GAD → MDD                              |
| INTERACTS_WITH       | Medication → Medication       | Sertraline → Tramadol (danger)         |

---

## 3. The Streamlit App

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        STREAMLIT APP                         │
│                                                              │
│  ┌──────────────┐     ┌──────────────────────────────────┐  │
│  │   SIDEBAR     │     │          MAIN AREA                │  │
│  │               │     │                                    │  │
│  │ [Story btn]   │     │  [ English question input box ]    │  │
│  │               │     │  [ Search button ]                 │  │
│  │ Node Legend    │     │                                    │  │
│  │  ● Member     │     │  ┌──────────────────────────────┐ │  │
│  │  ● Therapist  │     │  │                              │ │  │
│  │  ● Symptom    │     │  │   Interactive Graph (pyvis)  │ │  │
│  │  ● ...        │     │  │   - drag nodes               │ │  │
│  │               │     │  │   - zoom in/out              │ │  │
│  │ Quick Queries │     │  │   - click for details        │ │  │
│  │  [Full Graph] │     │  │   - physics simulation       │ │  │
│  │  [Care Team]  │     │  │                              │ │  │
│  │  [Symptoms]   │     │  └──────────────────────────────┘ │  │
│  │  [Scores]     │     │                                    │  │
│  │  [Sessions]   │     │  Answer: "Rahul's PHQ-9 improved  │  │
│  │  [Medication] │     │  from 18 to 14 over one month..." │  │
│  │  [Insights]   │     │                                    │  │
│  │  [Triggers]   │     │                                    │  │
│  └──────────────┘     └──────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow

```
User types English question
        │
        ▼
┌─────────────────┐
│  Groq LLM       │  (Llama 4 Scout — free)
│  Converts to    │
│  Cypher query   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Neo4j Aura     │  (cloud graph database)
│  Executes query │
│  Returns nodes  │
│  + relationships│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Pyvis (vis.js) │  (same engine as Neo4j browser)
│  Renders graph  │
│  - drag & drop  │
│  - physics      │
│  - click panels │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Groq LLM       │  (explains results in plain English)
│  "Rahul's PHQ-9 │
│  improved..."   │
└─────────────────┘
```

### Two Ways to Query

1. **Quick Queries (sidebar buttons)** — Pre-written Cypher stored in `config/quick_queries.json`. Instant, always correct. No LLM needed.

2. **English Search (input box)** — Type any question. Groq/Llama converts it to Cypher. Has safety fallback: if the LLM generates bad Cypher (multiple queries, UNION ALL), it auto-corrects to a broad match.

---

## 4. Project Structure

```
anchor-research/
├── app.py                          # Main Streamlit entry (~80 lines)
├── .env                            # Secrets (Neo4j + Groq keys)
├── requirements.txt                # pip dependencies
├── config/
│   └── quick_queries.json          # Pre-written Cypher for sidebar buttons
├── src/
│   ├── prompts/
│   │   ├── cypher_generation.txt   # System prompt: English → Cypher
│   │   └── explain_results.txt     # System prompt: results → explanation
│   ├── graph/
│   │   └── neo4j_client.py         # Neo4j connection, queries, schema
│   ├── llm/
│   │   └── groq_client.py          # Groq/Llama client + safety fallback
│   └── ui/
│       └── graph_renderer.py       # Pyvis graph + click panel + legend
├── stories/
│   └── rahul_journey.md            # The story (Rahul's 8-week journey)
├── plan/
│   ├── 01_knowledge_graph_basics.md
│   ├── 02_nodes_explained.md       # All 17 node types with examples
│   ├── 03_relationships_explained.md # All 37 relationship types
│   └── 04_full_example_walkthrough.md
└── docs/
    └── how_it_works.md             # This file
```

---

## 5. Tech Stack

| Component        | Technology                          | Why                          |
|------------------|-------------------------------------|------------------------------|
| Graph Database   | Neo4j Aura (cloud, free tier)       | Purpose-built for graphs     |
| Graph Protocol   | neo4j+ssc:// (encrypted, skip cert) | Aura free tier compatibility |
| LLM              | Llama 4 Scout 17B via Groq (free)   | Free, fast, good at Cypher   |
| Visualization    | Pyvis (vis.js)                      | Same engine as Neo4j browser |
| UI Framework     | Streamlit                           | Rapid Python web apps        |
| MCP              | Neo4j MCP Server                    | Claude ↔ Neo4j bridge        |

---

## 6. Key Design Decisions

1. **Pre-written Cypher for quick queries** — LLMs are unreliable at generating valid Cypher (UNION ALL errors, multiple queries). Sidebar buttons bypass the LLM entirely.

2. **Safety fallback in LLM client** — If the LLM generates bad Cypher (multiple RETURNs, UNION ALL), auto-rewrite to a broad `MATCH (m)-[r]->(x) RETURN m, r, x` pattern.

3. **vis.js for graph rendering** — Same physics engine Neo4j's own browser uses. Drag nodes, zoom, pan. Click-to-inspect panel built with injected JavaScript.

4. **Schema as LLM context** — The Cypher generation prompt includes live schema (node types, properties, sample data, relationship patterns) so the LLM knows exactly what exists in the graph.

5. **Story as Streamlit dialog** — Opens in a large centered modal overlay, not cramped in the sidebar. Close button to dismiss.
