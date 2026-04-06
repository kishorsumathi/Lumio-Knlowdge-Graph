# Anchor: Automated Transcript -> Knowledge Graph Pipeline

## Context
Fully automated (no human intervention) pipeline:
**Transcript + metadata in -> LLM extracts entities/relationships -> Structured JSON -> Deterministic Cypher -> Neo4j**

---

## Architecture

```
Transcript + Metadata (member_id, therapist, session_number, date, type, modality, duration)
        |
        v
+-------------------+
|  PREPROCESSOR     |  Chunk if >15K tokens, attach schema context
+--------+----------+
         |
         v
+-------------------+
|  LLM EXTRACTION   |  Step 1: Extract NODES (JSON)
|  (Claude/OpenAI)  |  Step 2: Extract RELATIONSHIPS (JSON, referencing step 1 node IDs)
+--------+----------+
         |
         v
+-------------------+
|  VALIDATION       |  Pydantic models, referential integrity, domain rules
+--------+----------+
         |
         v
+-------------------+
|  CYPHER GENERATOR |  Deterministic: JSON -> parameterized MERGE queries
+--------+----------+
         |
         v
+-------------------+
|  NEO4J WRITER     |  Execute in transaction, retry on failure
+-------------------+
```

---

## Key Design Decisions

1. **Two-step LLM extraction** (nodes first, then relationships) -- better accuracy than single mega-prompt
2. **Structured JSON -> Cypher** (not raw Cypher from LLM) -- safer, validatable, no injection risk
3. **MERGE + deterministic IDs** for idempotency -- reprocessing same transcript = no duplicates
4. **Metadata-derived entities** (Session, Transcription, ATTENDED, CONDUCTED) created deterministically from input, NOT extracted by LLM
5. **LLM-extracted session data** -- mood_before, mood_after, engagement, risk_flags are extracted by the LLM from transcript content, not provided as input
6. **Partial success** -- valid entities proceed even if some fail validation
7. **Abstract LLM layer** -- swap Claude/OpenAI via config change only

---

## Input Format

```python
TranscriptInput(
    metadata=SessionMetadata(
        member_id="MEM-042",
        member_name="Rahul Verma",
        therapist_id="THER-007",
        therapist_name="Dr. Priya Sharma",
        session_number=5,
        session_date=date(2026, 2, 9),
        session_type="therapy",        # intake / therapy / psychiatry / group / crisis / follow_up
        session_modality="voice",      # voice / video / in_person / chat
        duration_minutes=45,
    ),
    transcript="Therapist: How have you been since last week?\nRahul: ...",
)
```

**What the LLM extracts from the transcript** (not given as input):
- mood_before / mood_after (from conversational cues)
- symptoms, diagnoses, topics discussed
- insights, therapeutic techniques used
- medication mentions, side effects
- risk flags, engagement level
- everything else in the schema

---

## Project Structure

```
src/
├── pipeline.py              # Main orchestrator
├── config.py                # Settings, env vars
├── schema/
│   ├── enums.py             # SeverityStage, RiskLevel, SessionType, etc.
│   ├── nodes.py             # 17 Pydantic models (Member, Therapist, Diagnosis...)
│   ├── relationships.py     # 37 Pydantic models (TREATED_BY, EXHIBITS...)
│   ├── registry.py          # Maps labels -> models, generates LLM schema description
│   └── extraction.py        # ExtractionResult container
├── llm/
│   ├── base.py              # Abstract BaseLLMClient
│   ├── claude.py            # Anthropic (tool_use for structured output)
│   ├── openai_client.py     # OpenAI (response_format / function_calling)
│   └── factory.py           # get_llm_client("claude") -> ClaudeClient
├── extraction/
│   ├── extractor.py         # GraphExtractor: orchestrates 2-step extraction
│   ├── prompts.py           # System + user prompt templates
│   └── chunker.py           # Split long transcripts by speaker turns
├── cypher/
│   ├── generator.py         # JSON -> parameterized MERGE queries
│   └── templates.py         # Cypher patterns
├── graph/
│   ├── client.py            # Neo4j driver wrapper
│   ├── writer.py            # Execute Cypher batches in transactions
│   └── schema_setup.py      # Run constraints/indexes (one-time setup)
├── validation/
│   ├── validator.py         # Pydantic + referential integrity + dedup
│   └── rules.py             # Domain rules (ICD-10 format, score ranges, etc.)
└── models/
    ├── input.py             # TranscriptInput, SessionMetadata
    └── output.py            # PipelineResult, ExtractionStats
tests/
├── test_schema/
├── test_cypher/             # Most critical: deterministic, no DB needed
├── test_extraction/         # Mocked LLM
├── test_validation/
├── fixtures/                # Sample transcripts + expected outputs
```

---

## ID Generation (for idempotency)

| Entity | ID Pattern | Example |
|--------|-----------|---------|
| Session | `SES-{member_id}-{session_num}` | `SES-042-005` |
| Transcription | `TRN-{member_id}-{session_num}` | `TRN-042-005` |
| Symptom | `SYM-{name_hash[:6]}` | `SYM-a3f2c1` |
| Topic | `TOP-{name_hash[:6]}` | `TOP-b7d4e2` |
| Insight | `INS-{member_id}-{session}-{seq}` | `INS-042-005-001` |
| Medication | `MED-{generic_name_hash[:6]}` | `MED-c9e1f3` |
| Diagnosis | `DIAG-{icd10}` or `DIAG-{name_hash}` | `DIAG-F41.1` |
| Technique | `TECH-{name_hash[:6]}` | `TECH-d2a4b6` |

Member, Therapist, Psychiatrist, CareCoordinator IDs come from input metadata.

---

## Cypher Strategy

- All queries use **MERGE** on ID, then **SET** properties
- All values **parameterized** (`$var`), never string-interpolated
- Nodes executed first (single transaction), then relationships (single transaction)
- `null` properties skipped (don't overwrite existing data)
- `updated_at` timestamp on every MERGE

---

## Libraries

| Library | Purpose |
|---------|---------|
| `pydantic` v2 | Schema models, validation |
| `anthropic` | Claude API |
| `openai` | OpenAI API |
| `neo4j` | Neo4j driver |
| `tiktoken` | Token counting for chunking |
| `tenacity` | Retry with backoff |
| `python-dotenv` | Env vars |
| `structlog` | Structured logging |

---

## Implementation Order

| # | Phase | Files | Depends On |
|---|-------|-------|------------|
| 1 | Schema models (enums, nodes, rels, registry) | `src/schema/*` | -- |
| 2 | Input/output models | `src/models/*` | Phase 1 |
| 3 | LLM abstraction layer | `src/llm/*` | -- |
| 4 | Cypher generator | `src/cypher/*` | Phase 1 |
| 5 | Extraction logic + prompts | `src/extraction/*` | 1, 2, 3 |
| 6 | Validation | `src/validation/*` | Phase 1 |
| 7 | Neo4j client + writer | `src/graph/*` | Phase 4 |
| 8 | Pipeline orchestrator | `src/pipeline.py` | All above |
| 9 | Tests + sample fixtures | `tests/*` | All above |

---

## Verification Checklist

- [ ] Process sample Rahul intake transcript -> nodes/rels match plan/04 walkthrough
- [ ] Process same transcript twice -> no duplicates in Neo4j (idempotent)
- [ ] Swap LLM provider (Claude <-> OpenAI) -> same extraction quality
- [ ] Feed malformed LLM output -> validation catches it, valid entities still proceed
- [ ] Unit tests for Cypher generation (deterministic, no DB needed)
- [ ] mood_before/mood_after correctly extracted by LLM from transcript cues
