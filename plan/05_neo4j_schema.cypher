// ============================================================
// ANCHOR — Neo4j Knowledge Graph Schema
// ============================================================
// Run this ONCE when setting up a fresh Neo4j database.
// It creates all constraints, indexes, and example seed data.
// ============================================================


// ────────────────────────────────────────────────────────────
// PART 1: UNIQUENESS CONSTRAINTS
// ────────────────────────────────────────────────────────────
// Every node type gets a unique ID so we never create duplicates.
// Think of it like: "No two Members can have the same id."

// --- Person Nodes ---
CREATE CONSTRAINT member_id        IF NOT EXISTS FOR (n:Member)               REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT therapist_id     IF NOT EXISTS FOR (n:Therapist)            REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT psychiatrist_id  IF NOT EXISTS FOR (n:Psychiatrist)         REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT coordinator_id   IF NOT EXISTS FOR (n:CareCoordinator)      REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT family_id        IF NOT EXISTS FOR (n:FamilyMember)         REQUIRE n.id IS UNIQUE;

// --- Clinical Nodes ---
CREATE CONSTRAINT diagnosis_id     IF NOT EXISTS FOR (n:Diagnosis)            REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT symptom_id       IF NOT EXISTS FOR (n:Symptom)              REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT medication_id    IF NOT EXISTS FOR (n:Medication)           REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT therapy_type_id  IF NOT EXISTS FOR (n:TherapyType)          REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT assessment_id    IF NOT EXISTS FOR (n:Assessment)           REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT care_plan_id     IF NOT EXISTS FOR (n:CarePlan)             REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT technique_id     IF NOT EXISTS FOR (n:TherapeuticTechnique) REQUIRE n.id IS UNIQUE;

// --- Session & Content Nodes ---
CREATE CONSTRAINT session_id       IF NOT EXISTS FOR (n:Session)              REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT transcription_id IF NOT EXISTS FOR (n:Transcription)        REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT journal_id       IF NOT EXISTS FOR (n:JournalEntry)         REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT mood_log_id      IF NOT EXISTS FOR (n:MoodLog)              REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT topic_id         IF NOT EXISTS FOR (n:Topic)                REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT insight_id       IF NOT EXISTS FOR (n:Insight)              REQUIRE n.id IS UNIQUE;


// ────────────────────────────────────────────────────────────
// PART 2: INDEXES FOR FAST LOOKUPS
// ────────────────────────────────────────────────────────────
// Without indexes, Neo4j scans ALL nodes to find a match.
// With indexes, it jumps straight to the answer.
//
// Example: "Find all active members" → without index = slow scan
//          with index on status = instant lookup

// --- Member lookups (most common queries) ---
CREATE INDEX member_status         IF NOT EXISTS FOR (n:Member)       ON (n.status);
CREATE INDEX member_severity       IF NOT EXISTS FOR (n:Member)       ON (n.severity_stage);
CREATE INDEX member_risk           IF NOT EXISTS FOR (n:Member)       ON (n.risk_level);
CREATE INDEX member_name           IF NOT EXISTS FOR (n:Member)       ON (n.name);

// --- Therapist / Psychiatrist by name ---
CREATE INDEX therapist_name        IF NOT EXISTS FOR (n:Therapist)    ON (n.name);
CREATE INDEX psychiatrist_name     IF NOT EXISTS FOR (n:Psychiatrist) ON (n.name);

// --- Diagnosis lookups ---
CREATE INDEX diagnosis_icd10       IF NOT EXISTS FOR (n:Diagnosis)    ON (n.icd10_code);
CREATE INDEX diagnosis_name        IF NOT EXISTS FOR (n:Diagnosis)    ON (n.name);
CREATE INDEX diagnosis_status      IF NOT EXISTS FOR (n:Diagnosis)    ON (n.status);

// --- Symptom lookups ---
CREATE INDEX symptom_name          IF NOT EXISTS FOR (n:Symptom)      ON (n.name);
CREATE INDEX symptom_category      IF NOT EXISTS FOR (n:Symptom)      ON (n.category);

// --- Medication lookups ---
CREATE INDEX medication_generic    IF NOT EXISTS FOR (n:Medication)   ON (n.generic_name);
CREATE INDEX medication_class      IF NOT EXISTS FOR (n:Medication)   ON (n.drug_class);

// --- Session lookups ---
CREATE INDEX session_date          IF NOT EXISTS FOR (n:Session)      ON (n.date);
CREATE INDEX session_type          IF NOT EXISTS FOR (n:Session)      ON (n.type);
CREATE INDEX session_number        IF NOT EXISTS FOR (n:Session)      ON (n.session_number);

// --- Assessment lookups ---
CREATE INDEX assessment_tool       IF NOT EXISTS FOR (n:Assessment)   ON (n.tool_name);
CREATE INDEX assessment_date       IF NOT EXISTS FOR (n:Assessment)   ON (n.date_administered);

// --- Topic lookups ---
CREATE INDEX topic_name            IF NOT EXISTS FOR (n:Topic)        ON (n.name);
CREATE INDEX topic_category        IF NOT EXISTS FOR (n:Topic)        ON (n.category);

// --- Insight lookups ---
CREATE INDEX insight_type          IF NOT EXISTS FOR (n:Insight)      ON (n.type);

// --- Journal & MoodLog by date ---
CREATE INDEX journal_date          IF NOT EXISTS FOR (n:JournalEntry) ON (n.date);
CREATE INDEX moodlog_timestamp     IF NOT EXISTS FOR (n:MoodLog)      ON (n.timestamp);

// --- CarePlan status ---
CREATE INDEX careplan_status       IF NOT EXISTS FOR (n:CarePlan)     ON (n.status);


// ────────────────────────────────────────────────────────────
// PART 3: FULL-TEXT INDEXES (for searching text inside nodes)
// ────────────────────────────────────────────────────────────
// These let you search text INSIDE nodes. Example:
//   CALL db.index.fulltext.queryNodes("insight_text", "sleep regression")
// This finds all Insight nodes where the text mentions "sleep regression".

CALL db.index.fulltext.createNodeIndex(
  "insight_text", ["Insight"], ["text"]
);

CALL db.index.fulltext.createNodeIndex(
  "session_notes_text", ["Session"], ["session_notes"]
);

CALL db.index.fulltext.createNodeIndex(
  "topic_search", ["Topic"], ["name"]
);


// ════════════════════════════════════════════════════════════
// PART 4: SEED DATA — Rahul's Example
// ════════════════════════════════════════════════════════════
// This creates the full Rahul story from the walkthrough doc.
// Use this to test queries and understand how everything connects.


// --- 4.1 Person Nodes ---

CREATE (rahul:Member {
  id:               "MEM-042",
  name:             "Rahul",
  age:              28,
  gender:           "male",
  severity_stage:   "moderate",
  onboarding_date:  date("2026-01-15"),
  primary_concerns: ["anxiety", "insomnia"],
  risk_level:       "low",
  status:           "active"
});

CREATE (priya:FamilyMember {
  id:           "FAM-042-001",
  name:         "Priya",
  relationship: "spouse",
  access_level: "view_progress"
});

CREATE (sharma:Therapist {
  id:              "THER-007",
  name:            "Dr. Priya Sharma",
  specializations: ["CBT", "anxiety disorders"]
});

CREATE (mehta:Psychiatrist {
  id:              "PSY-003",
  name:            "Dr. Rohan Mehta",
  specializations: ["pharmacotherapy", "mood disorders"]
});

CREATE (anita:CareCoordinator {
  id:               "COORD-012",
  name:             "Anita",
  assigned_members: 15
});


// --- 4.2 Care Team Relationships ---
// Rahul ──[TREATED_BY]──→ Dr. Sharma
// Rahul ──[PRESCRIBED_BY]──→ Dr. Mehta
// Rahul ──[COORDINATED_BY]──→ Anita
// Rahul ──[SUPPORTED_BY]──→ Priya

MATCH (m:Member {id: "MEM-042"}), (t:Therapist {id: "THER-007"})
CREATE (m)-[:TREATED_BY {since: date("2026-01-15"), status: "active", sessions_completed: 8}]->(t);

MATCH (m:Member {id: "MEM-042"}), (p:Psychiatrist {id: "PSY-003"})
CREATE (m)-[:PRESCRIBED_BY {since: date("2026-01-15"), last_consultation: date("2026-03-01")}]->(p);

MATCH (m:Member {id: "MEM-042"}), (c:CareCoordinator {id: "COORD-012"})
CREATE (m)-[:COORDINATED_BY {since: date("2026-01-15")}]->(c);

MATCH (m:Member {id: "MEM-042"}), (f:FamilyMember {id: "FAM-042-001"})
CREATE (m)-[:SUPPORTED_BY {access_level: "view_progress", enrolled_date: date("2026-01-15")}]->(f);


// --- 4.3 Clinical Nodes ---

CREATE (gad:Diagnosis {
  id:            "DIAG-042-001",
  name:          "Generalized Anxiety Disorder",
  icd10_code:    "F41.1",
  severity:      "moderate",
  status:        "active",
  date_diagnosed: date("2026-01-15")
});

CREATE (worry:Symptom {
  id:        "SYM-001",
  name:      "excessive worry",
  category:  "emotional",
  severity:  "moderate",
  frequency: "daily"
});

CREATE (insomnia:Symptom {
  id:        "SYM-002",
  name:      "insomnia",
  category:  "physical",
  severity:  "moderate",
  frequency: "daily"
});

CREATE (rumination:Symptom {
  id:        "SYM-003",
  name:      "rumination",
  category:  "cognitive",
  severity:  "moderate",
  frequency: "daily"
});

CREATE (nausea:Symptom {
  id:        "SYM-004",
  name:      "nausea",
  category:  "physical",
  severity:  "mild",
  frequency: "daily"
});

CREATE (hopelessness:Symptom {
  id:        "SYM-005",
  name:      "hopelessness",
  category:  "emotional",
  severity:  "moderate",
  frequency: "episodic"
});

CREATE (sertraline:Medication {
  id:               "MED-001",
  brand_name:       "Zoloft",
  generic_name:     "Sertraline",
  drug_class:       "SSRI",
  dosage:           "100mg",
  frequency:        "once daily",
  start_date:       date("2026-01-15"),
  purpose:          "anxiety, depression",
  side_effects_noted: ["nausea", "insomnia"]
});

CREATE (cbt:TherapyType {
  id:               "TT-001",
  name:             "Cognitive Behavioral Therapy",
  abbreviation:     "CBT",
  modality:         "individual",
  evidence_base:    "NICE recommended for GAD",
  typical_duration: "12-20 sessions"
});

CREATE (thought_record:TherapeuticTechnique {
  id:           "TECH-001",
  name:         "Thought Record",
  therapy_type: "CBT",
  description:  "Write down negative thoughts, find evidence for and against, create balanced thought",
  difficulty:   "beginner"
});


// --- 4.4 Clinical Relationships ---

// Rahul diagnosed with GAD
MATCH (m:Member {id: "MEM-042"}), (d:Diagnosis {id: "DIAG-042-001"})
CREATE (m)-[:DIAGNOSED_WITH {date: date("2026-01-15"), by_clinician: "THER-007", status: "active"}]->(d);

// Rahul exhibits symptoms
MATCH (m:Member {id: "MEM-042"}), (s:Symptom {id: "SYM-001"})
CREATE (m)-[:EXHIBITS {first_reported: date("2026-01-15"), last_reported: date("2026-03-15")}]->(s);

MATCH (m:Member {id: "MEM-042"}), (s:Symptom {id: "SYM-002"})
CREATE (m)-[:EXHIBITS {first_reported: date("2026-01-22"), last_reported: date("2026-03-15")}]->(s);

MATCH (m:Member {id: "MEM-042"}), (s:Symptom {id: "SYM-003"})
CREATE (m)-[:EXHIBITS {first_reported: date("2026-01-15"), last_reported: date("2026-03-01")}]->(s);

MATCH (m:Member {id: "MEM-042"}), (s:Symptom {id: "SYM-004"})
CREATE (m)-[:EXHIBITS {first_reported: date("2026-03-01")}]->(s);

MATCH (m:Member {id: "MEM-042"}), (s:Symptom {id: "SYM-005"})
CREATE (m)-[:EXHIBITS {first_reported: date("2026-03-15")}]->(s);

// GAD manifests as worry and insomnia
MATCH (d:Diagnosis {id: "DIAG-042-001"}), (s:Symptom {id: "SYM-001"})
CREATE (d)-[:MANIFESTS_AS {typical: true}]->(s);

MATCH (d:Diagnosis {id: "DIAG-042-001"}), (s:Symptom {id: "SYM-002"})
CREATE (d)-[:MANIFESTS_AS {typical: true}]->(s);

// Rahul takes Sertraline
MATCH (m:Member {id: "MEM-042"}), (med:Medication {id: "MED-001"})
CREATE (m)-[:TAKES {prescribed_date: date("2026-01-15"), adherence_rate: 0.85, prescribed_by: "PSY-003"}]->(med);

// Sertraline treats GAD, causes nausea
MATCH (med:Medication {id: "MED-001"}), (d:Diagnosis {id: "DIAG-042-001"})
CREATE (med)-[:TREATS {efficacy: "first_line"}]->(d);

MATCH (med:Medication {id: "MED-001"}), (s:Symptom {id: "SYM-004"})
CREATE (med)-[:CAUSES {likelihood: "common", onset: "2 weeks after dose increase to 100mg"}]->(s);

// Rahul undergoing CBT
MATCH (m:Member {id: "MEM-042"}), (tt:TherapyType {id: "TT-001"})
CREATE (m)-[:UNDERGOING {start_date: date("2026-01-22"), sessions_completed: 7, progress: "mid"}]->(tt);

// CBT indicated for GAD
MATCH (tt:TherapyType {id: "TT-001"}), (d:Diagnosis {id: "DIAG-042-001"})
CREATE (tt)-[:INDICATED_FOR {evidence_level: "strong"}]->(d);

// Dr. Sharma specializes in CBT
MATCH (t:Therapist {id: "THER-007"}), (tt:TherapyType {id: "TT-001"})
CREATE (t)-[:SPECIALIZES_IN]->(tt);

// Insomnia preceded by rumination (pattern discovered by AI)
MATCH (s1:Symptom {id: "SYM-002"}), (s2:Symptom {id: "SYM-003"})
CREATE (s1)-[:PRECEDED_BY {pattern: "always"}]->(s2);


// --- 4.5 Assessment Nodes ---

CREATE (phq9_jan:Assessment {
  id:                "ASMT-042-001",
  tool_name:         "PHQ-9",
  full_name:         "Patient Health Questionnaire-9",
  score:             18,
  max_score:         27,
  interpretation:    "moderately severe depression",
  date_administered: date("2026-01-15"),
  administered_by:   "THER-007"
});

CREATE (gad7_jan:Assessment {
  id:                "ASMT-042-002",
  tool_name:         "GAD-7",
  full_name:         "Generalized Anxiety Disorder Scale",
  score:             15,
  max_score:         21,
  interpretation:    "severe anxiety",
  date_administered: date("2026-01-15"),
  administered_by:   "THER-007"
});

CREATE (phq9_feb:Assessment {
  id:                "ASMT-042-003",
  tool_name:         "PHQ-9",
  full_name:         "Patient Health Questionnaire-9",
  score:             14,
  max_score:         27,
  interpretation:    "moderate depression",
  date_administered: date("2026-02-15"),
  administered_by:   "THER-007"
});

CREATE (phq9_mar:Assessment {
  id:                "ASMT-042-004",
  tool_name:         "PHQ-9",
  full_name:         "Patient Health Questionnaire-9",
  score:             12,
  max_score:         27,
  interpretation:    "moderate depression",
  date_administered: date("2026-03-15"),
  administered_by:   "THER-007"
});

// Member assessed with each
MATCH (m:Member {id: "MEM-042"}), (a:Assessment {id: "ASMT-042-001"})
CREATE (m)-[:ASSESSED_WITH {date: date("2026-01-15"), context: "intake"}]->(a);

MATCH (m:Member {id: "MEM-042"}), (a:Assessment {id: "ASMT-042-002"})
CREATE (m)-[:ASSESSED_WITH {date: date("2026-01-15"), context: "intake"}]->(a);

MATCH (m:Member {id: "MEM-042"}), (a:Assessment {id: "ASMT-042-003"})
CREATE (m)-[:ASSESSED_WITH {date: date("2026-02-15"), context: "routine"}]->(a);

MATCH (m:Member {id: "MEM-042"}), (a:Assessment {id: "ASMT-042-004"})
CREATE (m)-[:ASSESSED_WITH {date: date("2026-03-15"), context: "routine"}]->(a);

// Assessment comparisons (PHQ-9 trend: 18 → 14 → 12)
MATCH (a1:Assessment {id: "ASMT-042-001"}), (a2:Assessment {id: "ASMT-042-003"})
CREATE (a1)-[:COMPARED_TO {delta_score: -4, direction: "improved", days_between: 31}]->(a2);

MATCH (a2:Assessment {id: "ASMT-042-003"}), (a3:Assessment {id: "ASMT-042-004"})
CREATE (a2)-[:COMPARED_TO {delta_score: -2, direction: "improved", days_between: 28}]->(a3);


// --- 4.6 Care Plan Nodes ---

CREATE (plan_v1:CarePlan {
  id:            "CP-042-001",
  version:       1,
  goals:         ["reduce GAD-7 below 10", "sleep 7+ hours", "reduce PHQ-9 below 10"],
  interventions: ["weekly CBT", "Sertraline 50mg", "sleep hygiene"],
  review_date:   date("2026-02-15"),
  status:        "revised",
  created_by:    "THER-007"
});

CREATE (plan_v2:CarePlan {
  id:            "CP-042-002",
  version:       2,
  goals:         ["reduce GAD-7 below 10", "sleep 7+ hours", "manage side effects"],
  interventions: ["weekly CBT", "Sertraline 100mg", "sleep hygiene", "psychiatrist review"],
  review_date:   date("2026-04-01"),
  status:        "active",
  created_by:    "THER-007"
});

// Member follows care plan
MATCH (m:Member {id: "MEM-042"}), (cp:CarePlan {id: "CP-042-002"})
CREATE (m)-[:FOLLOWS {adherence: 0.85, last_reviewed: date("2026-03-15")}]->(cp);

// Plan v1 revised to Plan v2
MATCH (cp1:CarePlan {id: "CP-042-001"}), (cp2:CarePlan {id: "CP-042-002"})
CREATE (cp1)-[:REVISED_TO {reason: "medication change + side effects", revised_by: "THER-007", date: date("2026-03-01")}]->(cp2);


// --- 4.7 Session Nodes (Session 1 intake + Session 5 + Session 8) ---

CREATE (s1:Session {
  id:                  "SES-042-001",
  session_number:      1,
  date:                date("2026-01-15"),
  duration_minutes:    60,
  type:                "intake",
  modality:            "video",
  mood_before:         3,
  mood_after:          5,
  severity_at_session: "moderate"
});

CREATE (s5:Session {
  id:                  "SES-042-005",
  session_number:      5,
  date:                date("2026-02-12"),
  duration_minutes:    45,
  type:                "therapy",
  modality:            "voice",
  mood_before:         4,
  mood_after:          6,
  severity_at_session: "moderate"
});

CREATE (s8:Session {
  id:                  "SES-042-008",
  session_number:      8,
  date:                date("2026-03-15"),
  duration_minutes:    45,
  type:                "therapy",
  modality:            "voice",
  mood_before:         4,
  mood_after:          6,
  severity_at_session: "moderate",
  risk_flags:          ["passive_hopelessness"]
});

// Member attended sessions
MATCH (m:Member {id: "MEM-042"}), (s:Session {id: "SES-042-001"})
CREATE (m)-[:ATTENDED {mood_before: 3, mood_after: 5, engagement: "high"}]->(s);

MATCH (m:Member {id: "MEM-042"}), (s:Session {id: "SES-042-005"})
CREATE (m)-[:ATTENDED {mood_before: 4, mood_after: 6, engagement: "high"}]->(s);

MATCH (m:Member {id: "MEM-042"}), (s:Session {id: "SES-042-008"})
CREATE (m)-[:ATTENDED {mood_before: 4, mood_after: 6, engagement: "high"}]->(s);

// Therapist conducted sessions
MATCH (t:Therapist {id: "THER-007"}), (s:Session {id: "SES-042-001"})
CREATE (t)-[:CONDUCTED]->(s);

MATCH (t:Therapist {id: "THER-007"}), (s:Session {id: "SES-042-005"})
CREATE (t)-[:CONDUCTED]->(s);

MATCH (t:Therapist {id: "THER-007"}), (s:Session {id: "SES-042-008"})
CREATE (t)-[:CONDUCTED]->(s);

// Session chain: 1 → ... → 5 → ... → 8
MATCH (s1:Session {id: "SES-042-001"}), (s5:Session {id: "SES-042-005"})
CREATE (s1)-[:FOLLOWED_BY {days_between: 28}]->(s5);

MATCH (s5:Session {id: "SES-042-005"}), (s8:Session {id: "SES-042-008"})
CREATE (s5)-[:FOLLOWED_BY {days_between: 31}]->(s8);

// Session 1 triggered assessments
MATCH (s:Session {id: "SES-042-001"}), (a:Assessment {id: "ASMT-042-001"})
CREATE (s)-[:TRIGGERED_ASSESSMENT {reason: "routine"}]->(a);

MATCH (s:Session {id: "SES-042-001"}), (a:Assessment {id: "ASMT-042-002"})
CREATE (s)-[:TRIGGERED_ASSESSMENT {reason: "routine"}]->(a);

// Session 8 updated care plan
MATCH (s:Session {id: "SES-042-008"}), (cp:CarePlan {id: "CP-042-002"})
CREATE (s)-[:UPDATED {changes_made: ["increased dose", "added side effect monitoring"]}]->(cp);


// --- 4.8 Topics ---

CREATE (work_stress:Topic {
  id:        "TOP-001",
  name:      "work deadline pressure",
  category:  "trigger",
  sentiment: "negative"
});

CREATE (sleep_goal:Topic {
  id:        "TOP-002",
  name:      "sleep improvement",
  category:  "goal",
  sentiment: "neutral"
});

CREATE (hopelessness_topic:Topic {
  id:        "TOP-003",
  name:      "hopelessness about recovery",
  category:  "barrier",
  sentiment: "negative"
});

// Session 5 discussed topics
MATCH (s:Session {id: "SES-042-005"}), (t:Topic {id: "TOP-001"})
CREATE (s)-[:DISCUSSED {depth: "deep", sentiment: "negative", time_spent_minutes: 20}]->(t);

MATCH (s:Session {id: "SES-042-005"}), (t:Topic {id: "TOP-002"})
CREATE (s)-[:DISCUSSED {depth: "moderate", sentiment: "neutral", time_spent_minutes: 10}]->(t);

// Session 8 discussed hopelessness
MATCH (s:Session {id: "SES-042-008"}), (t:Topic {id: "TOP-003"})
CREATE (s)-[:DISCUSSED {depth: "moderate", sentiment: "negative", time_spent_minutes: 15}]->(t);

// Session 5 used Thought Record technique
MATCH (s:Session {id: "SES-042-005"}), (tech:TherapeuticTechnique {id: "TECH-001"})
CREATE (s)-[:USED_TECHNIQUE {member_response: "receptive", homework_assigned: true}]->(tech);

// Rahul assigned & completed Thought Record
MATCH (m:Member {id: "MEM-042"}), (tech:TherapeuticTechnique {id: "TECH-001"})
CREATE (m)-[:ASSIGNED {assigned_date: date("2026-02-12"), due_date: date("2026-02-19"), assigned_by: "THER-007"}]->(tech);

MATCH (m:Member {id: "MEM-042"}), (tech:TherapeuticTechnique {id: "TECH-001"})
CREATE (m)-[:COMPLETED {date: date("2026-02-16"), difficulty_rating: 5, helpfulness_rating: 7}]->(tech);


// --- 4.9 Insights ---

CREATE (ins1:Insight {
  id:             "INS-042-001",
  text:           "Work deadlines consistently trigger anxiety spirals",
  type:           "behavioral_pattern",
  confidence:     0.85,
  source_session: "SES-042-005",
  extracted_by:   "claude-sonnet-4"
});

CREATE (ins2:Insight {
  id:             "INS-042-002",
  text:           "Sleep regression correlates with Sertraline dose increase",
  type:           "treatment_response",
  confidence:     0.75,
  source_session: "SES-042-008",
  extracted_by:   "claude-sonnet-4"
});

CREATE (ins3:Insight {
  id:             "INS-042-003",
  text:           "Passive hopelessness — denies suicidal intent but questions point of treatment",
  type:           "risk_indicator",
  confidence:     0.80,
  source_session: "SES-042-008",
  extracted_by:   "claude-sonnet-4"
});

// Sessions produced insights
MATCH (s:Session {id: "SES-042-005"}), (i:Insight {id: "INS-042-001"})
CREATE (s)-[:PRODUCED {confidence: 0.85}]->(i);

MATCH (s:Session {id: "SES-042-008"}), (i:Insight {id: "INS-042-002"})
CREATE (s)-[:PRODUCED {confidence: 0.75}]->(i);

MATCH (s:Session {id: "SES-042-008"}), (i:Insight {id: "INS-042-003"})
CREATE (s)-[:PRODUCED {confidence: 0.80}]->(i);


// --- 4.10 Journal & Mood Log ---

CREATE (j1:JournalEntry {
  id:         "JRN-042-001",
  date:       datetime("2026-02-14T23:30:00"),
  mood_score: 4,
  themes:     ["work stress", "insomnia"],
  word_count: 150,
  sentiment:  -0.3
});

CREATE (ml1:MoodLog {
  id:          "ML-042-001",
  timestamp:   datetime("2026-02-14T23:45:00"),
  mood:        "low",
  energy_level: 3,
  sleep_hours: 3.5,
  notes:       "can't stop thinking about tomorrow's meeting"
});

// Member wrote journal, logged mood
MATCH (m:Member {id: "MEM-042"}), (j:JournalEntry {id: "JRN-042-001"})
CREATE (m)-[:WROTE]->(j);

MATCH (m:Member {id: "MEM-042"}), (ml:MoodLog {id: "ML-042-001"})
CREATE (m)-[:LOGGED]->(ml);

// Journal mentions work stress, reflects on session 5
MATCH (j:JournalEntry {id: "JRN-042-001"}), (t:Topic {id: "TOP-001"})
CREATE (j)-[:MENTIONS {sentiment: -0.4}]->(t);

MATCH (j:JournalEntry {id: "JRN-042-001"}), (s:Session {id: "SES-042-005"})
CREATE (j)-[:REFLECTS_ON {days_after: 2}]->(s);

// Mood log triggered by work stress
MATCH (ml:MoodLog {id: "ML-042-001"}), (t:Topic {id: "TOP-001"})
CREATE (ml)-[:TRIGGERED_BY {intensity: 8}]->(t);


// --- 4.11 Cross-clinician consultation ---

MATCH (t:Therapist {id: "THER-007"}), (p:Psychiatrist {id: "PSY-003"})
CREATE (t)-[:CONSULTS_WITH {regarding_member: "MEM-042", reason: "medication side effects"}]->(p);


// ════════════════════════════════════════════════════════════
// PART 5: EXAMPLE QUERIES — Test These After Loading
// ════════════════════════════════════════════════════════════

// Q1: Is Rahul getting better? (Follow assessment trend)
// MATCH (m:Member {id: "MEM-042"})-[:ASSESSED_WITH]->(a:Assessment)
// WHERE a.tool_name = "PHQ-9"
// RETURN a.date_administered, a.score, a.interpretation
// ORDER BY a.date_administered;
// Expected: 18 → 14 → 12 (improving!)

// Q2: What are Rahul's current symptoms?
// MATCH (m:Member {id: "MEM-042"})-[r:EXHIBITS]->(s:Symptom)
// RETURN s.name, s.category, s.severity, r.first_reported
// ORDER BY r.first_reported;

// Q3: Is medication causing side effects?
// MATCH (m:Member {id: "MEM-042"})-[:TAKES]->(med:Medication)-[:CAUSES]->(s:Symptom)
// RETURN med.generic_name, med.dosage, s.name AS side_effect;

// Q4: What triggers Rahul's anxiety?
// MATCH (m:Member {id: "MEM-042"})-[:ATTENDED]->(ses:Session)-[:DISCUSSED]->(t:Topic)
// WHERE t.category = "trigger"
// RETURN t.name, count(ses) AS times_discussed
// ORDER BY times_discussed DESC;

// Q5: Full care team
// MATCH (m:Member {id: "MEM-042"})-[r]->(person)
// WHERE type(r) IN ["TREATED_BY", "PRESCRIBED_BY", "COORDINATED_BY", "SUPPORTED_BY"]
// RETURN type(r) AS role, person.name;

// Q6: Session mood trend
// MATCH (m:Member {id: "MEM-042"})-[r:ATTENDED]->(s:Session)
// RETURN s.session_number, s.date, r.mood_before, r.mood_after
// ORDER BY s.session_number;

// Q7: AI-generated insights for Rahul
// MATCH (m:Member {id: "MEM-042"})-[:ATTENDED]->(s:Session)-[:PRODUCED]->(i:Insight)
// RETURN i.text, i.type, i.confidence, s.date
// ORDER BY s.date;

// Q8: Care plan history
// MATCH (cp1:CarePlan)-[r:REVISED_TO]->(cp2:CarePlan)
// WHERE cp1.id STARTS WITH "CP-042"
// RETURN cp1.version, cp1.goals, r.reason, cp2.version, cp2.goals;

// Q9: Homework completion check
// MATCH (m:Member {id: "MEM-042"})-[a:ASSIGNED]->(tech:TherapeuticTechnique)
// OPTIONAL MATCH (m)-[c:COMPLETED]->(tech)
// RETURN tech.name, a.due_date, c.date AS completed_date, c.helpfulness_rating;

// Q10: Cross-member query — find all members on SSRIs with sleep issues
// MATCH (m:Member)-[:TAKES]->(med:Medication {drug_class: "SSRI"}),
//       (m)-[:EXHIBITS]->(s:Symptom {name: "insomnia"})
// RETURN m.name, med.generic_name, med.dosage;
