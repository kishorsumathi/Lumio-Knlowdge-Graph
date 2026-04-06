# All Relationships — Explained Simply

A **relationship** = a line connecting two nodes. It always has:
- A **direction** (from → to)
- A **name** (what the connection means)
- **Properties** (extra details about the connection)

```
(Rahul) ──[TREATED_BY]──→ (Dr. Sharma)
  ↑ node      ↑ relationship     ↑ node
              properties: since=Jan 12, status=active
```

---

## Group 1: Who's on Rahul's Care Team?

These relationships connect a **Member** to the **people helping them**.

### TREATED_BY
**Member → Therapist**

```
(Rahul) ──[TREATED_BY]──→ (Dr. Sharma)
  since: 2026-01-12
  status: "active"              ← active or discharged
  sessions_completed: 8
```

**Plain English:** "Rahul has been seeing Dr. Sharma since January 12. They've done 8 sessions so far."

---

### PRESCRIBED_BY
**Member → Psychiatrist**

```
(Rahul) ──[PRESCRIBED_BY]──→ (Dr. Mehta)
  since: 2026-01-12
  last_consultation: 2026-03-01
```

**Plain English:** "Dr. Mehta manages Rahul's medications. They last met on March 1."

---

### COORDINATED_BY
**Member → CareCoordinator**

```
(Rahul) ──[COORDINATED_BY]──→ (Anita)
  since: 2026-01-12
```

**Plain English:** "Anita is managing Rahul's care logistics."

---

### SUPPORTED_BY
**Member → FamilyMember**

```
(Rahul) ──[SUPPORTED_BY]──→ (Priya)
  access_level: "view_progress"
  enrolled_date: 2026-01-10
```

**Plain English:** "Rahul's wife Priya is part of his support system. She can view his progress but not session details."

---

### CONSULTS_WITH
**Therapist → Psychiatrist**

```
(Dr. Sharma) ──[CONSULTS_WITH]──→ (Dr. Mehta)
  regarding_member: "MEM-042"
  reason: "medication side effects"
  frequency: "as_needed"
```

**Plain English:** "Dr. Sharma contacted Dr. Mehta about Rahul's medication side effects."

**Why this matters:** In mental health, the therapist and psychiatrist need to talk to each other. The graph tracks when and why they do.

---

### SPECIALIZES_IN
**Therapist → TherapyType**

```
(Dr. Sharma) ──[SPECIALIZES_IN]──→ (CBT)
```

**Plain English:** "Dr. Sharma is trained in CBT."

---

## Group 2: What's Wrong With Rahul? (Clinical)

These connect a **Member** to their **diagnosis, symptoms, medication, and treatment**.

### DIAGNOSED_WITH
**Member → Diagnosis**

```
(Rahul) ──[DIAGNOSED_WITH]──→ (Generalized Anxiety Disorder)
  date: 2026-01-12
  by_clinician: "THER-007"
  status: "active"
```

**Plain English:** "Rahul was diagnosed with Generalized Anxiety Disorder on Jan 12 by Dr. Sharma. It's still active."

---

### EXHIBITS
**Member → Symptom**

```
(Rahul) ──[EXHIBITS]──→ (insomnia)
  first_reported: "SES-042-001"       ← First mentioned in session 1
  last_reported: "SES-042-008"        ← Most recently mentioned in session 8
  reported_in_sessions: ["SES-042-001", "SES-042-003", "SES-042-005", "SES-042-008"]
```

**Plain English:** "Rahul has insomnia. He first mentioned it in session 1 and it came up again in sessions 3, 5, and 8."

**Why this matters:** If a symptom keeps appearing across sessions, it's persistent. If it stops appearing, maybe it's resolved.

---

### TAKES
**Member → Medication**

```
(Rahul) ──[TAKES]──→ (Sertraline)
  prescribed_date: 2026-01-15
  adherence_rate: 0.85             ← Takes it 85% of the time
  prescribed_by: "PSY-003"
```

**Plain English:** "Rahul takes Sertraline, prescribed by Dr. Mehta. He takes it about 85% of the time."

**Why adherence matters:** If someone only takes their pills 50% of the time, the treatment might fail — but it's not the medicine's fault. The graph tracks this.

---

### UNDERGOING
**Member → TherapyType**

```
(Rahul) ──[UNDERGOING]──→ (CBT)
  start_date: 2026-01-12
  sessions_completed: 8
  progress: "mid"                  ← early / mid / late / maintenance
```

**Plain English:** "Rahul is doing CBT therapy. He's completed 8 sessions and is mid-way through treatment."

---

### ASSESSED_WITH
**Member → Assessment**

```
(Rahul) ──[ASSESSED_WITH]──→ (PHQ-9, score=18)
  date: 2026-01-12
  context: "intake"                ← Why was the test done?
      intake = first visit
      routine = regular check
      discharge = final assessment before leaving
```

**Plain English:** "Rahul took the PHQ-9 test on Jan 12 during intake. He scored 18/27 (moderately severe depression)."

---

### FOLLOWS
**Member → CarePlan**

```
(Rahul) ──[FOLLOWS]──→ (Care Plan v1)
  adherence: 0.85                  ← Following 85% of the plan
  last_reviewed: 2026-02-12
```

**Plain English:** "Rahul is following Care Plan v1. He's sticking to it about 85% of the time."

---

### MANIFESTS_AS
**Diagnosis → Symptom**

```
(Generalized Anxiety Disorder) ──[MANIFESTS_AS]──→ (insomnia)
  typical: true                    ← Is this a common symptom for this diagnosis?
  severity_correlation: "moderate anxiety often disrupts sleep"
```

**Plain English:** "GAD commonly shows up as insomnia."

**Why this matters:** When the AI extracts a symptom, it can automatically link it to the diagnosis because it knows which symptoms are typical.

---

### TREATS
**Medication → Diagnosis**

```
(Sertraline) ──[TREATS]──→ (Generalized Anxiety Disorder)
  efficacy: "first_line"           ← How good is this drug for this problem?
      first_line = best option, try this first
      second_line = try if first option doesn't work
      adjunct = use alongside another treatment
```

**Plain English:** "Sertraline is a first-line treatment for GAD — meaning it's one of the best options."

---

### CAUSES (side effects)
**Medication → Symptom**

```
(Sertraline) ──[CAUSES]──→ (nausea)
  likelihood: "common"             ← common / uncommon / rare
  onset: "2 weeks after dose increase to 100mg"
```

**Plain English:** "Sertraline is causing Rahul nausea. It started 2 weeks after his dose was increased."

**Why this matters:** The graph can distinguish between symptoms from the DISEASE vs symptoms from the MEDICINE. "Is the nausea because of anxiety, or because of the pills?" — the graph knows.

---

### INTERACTS_WITH
**Medication → Medication**

```
(Sertraline) ──[INTERACTS_WITH]──→ (Tramadol)
  severity: "major"
  effect: "risk of serotonin syndrome — can be life-threatening"
```

**Plain English:** "If someone takes both Sertraline and Tramadol, there's a dangerous interaction."

**Why this matters:** Safety. If a psychiatrist tries to prescribe a second drug, the system checks for dangerous combinations.

---

### INDICATED_FOR
**TherapyType → Diagnosis**

```
(CBT) ──[INDICATED_FOR]──→ (Generalized Anxiety Disorder)
  evidence_level: "strong"         ← strong / moderate / emerging
```

**Plain English:** "CBT has strong scientific evidence for treating GAD."

---

## Group 3: What Happened in Sessions?

### ATTENDED
**Member → Session**

```
(Rahul) ──[ATTENDED]──→ (Session 5)
  mood_before: 4
  mood_after: 6
  engagement: "high"              ← high / moderate / low
```

**Plain English:** "Rahul attended session 5. His mood went from 4/10 to 6/10. He was highly engaged."

---

### CONDUCTED
**Therapist → Session** (or Psychiatrist → Session)

```
(Dr. Sharma) ──[CONDUCTED]──→ (Session 5)
```

**Plain English:** "Dr. Sharma ran session 5."

---

### HAS_TRANSCRIPT
**Session → Transcription**

```
(Session 5) ──[HAS_TRANSCRIPT]──→ (Transcript 5)
```

**Plain English:** "Session 5 has a transcript."

---

### DISCUSSED
**Session → Topic**

```
(Session 5) ──[DISCUSSED]──→ (work deadline pressure)
  depth: "deep"                   ← brief / moderate / deep
  sentiment: "negative"
  time_spent_minutes: 20
```

**Plain English:** "In session 5, they spent 20 minutes deeply discussing work deadline pressure. It was a negative/stressful topic."

**Why this matters:** If "work stress" keeps appearing as a deep topic across many sessions, it's a major issue. The graph counts this automatically.

---

### PRODUCED
**Session → Insight**

```
(Session 5) ──[PRODUCED]──→ (Insight: "deadlines trigger anxiety spirals")
  confidence: 0.85
```

**Plain English:** "From session 5, the AI discovered that work deadlines trigger Rahul's anxiety spirals (85% confident)."

---

### USED_TECHNIQUE
**Session → TherapeuticTechnique**

```
(Session 5) ──[USED_TECHNIQUE]──→ (Thought Record)
  member_response: "receptive"    ← receptive / resistant / neutral
  homework_assigned: true
```

**Plain English:** "In session 5, Dr. Sharma used the Thought Record technique. Rahul was open to it and got homework to practice."

---

### FOLLOWED_BY
**Session → Session**

```
(Session 4) ──[FOLLOWED_BY]──→ (Session 5)
  days_between: 7
  continuity_score: 0.8           ← How connected are the sessions? (0-1)
```

**Plain English:** "Session 5 happened 7 days after session 4."

**Why this matters:** Creates a chain: Session 1 → 2 → 3 → 4 → 5 → ... This lets the system show the full journey over time.

---

### UPDATED
**Session → CarePlan**

```
(Session 8) ──[UPDATED]──→ (Care Plan v2)
  changes_made: ["increased Sertraline to 100mg", "added side effect monitoring"]
```

**Plain English:** "In session 8, the care plan was updated — Sertraline dose went up and they added monitoring for side effects."

---

### TRIGGERED_ASSESSMENT
**Session → Assessment**

```
(Session 8) ──[TRIGGERED_ASSESSMENT]──→ (PHQ-9, score=12)
  reason: "risk_detected"         ← routine / risk_detected / progress_check
```

**Plain English:** "Because session 8 flagged a risk (hopelessness), a PHQ-9 test was triggered."

---

## Group 4: Member's Own Activities (Journals, Mood)

### WROTE
**Member → JournalEntry**

```
(Rahul) ──[WROTE]──→ (Journal entry Feb 11)
```

**Plain English:** "Rahul wrote a journal entry on Feb 11."

---


### MENTIONS
**JournalEntry → Topic**

```
(Journal Feb 11) ──[MENTIONS]──→ (work deadline pressure)
  sentiment: -0.4
  context: "boss gave impossible deadline again"
```

**Plain English:** "In his Feb 11 journal, Rahul mentioned work deadlines negatively."

---

### REFLECTS_ON
**JournalEntry → Session**

```
(Journal Feb 11) ──[REFLECTS_ON]──→ (Session 5)
  days_after: 2
```

**Plain English:** "Rahul's Feb 11 journal was written 2 days after session 5 — he's reflecting on what they discussed."

**Why this matters:** Shows that sessions stick with the member and they continue thinking about it.

---

### TRIGGERED_BY
**MoodLog → Topic**

```
(Mood log 11:30 PM) ──[TRIGGERED_BY]──→ (work deadline pressure)
  intensity: 8                    ← How strongly did it affect mood? (1-10)
```

**Plain English:** "Rahul's low mood at 11:30 PM was triggered by work deadline stress (intensity 8/10)."

---

### ASSIGNED
**Member → TherapeuticTechnique**

```
(Rahul) ──[ASSIGNED]──→ (Thought Record)
  assigned_date: 2026-02-09
  due_date: 2026-02-16
  assigned_by: "THER-007"
```

**Plain English:** "Dr. Sharma assigned Rahul to practice Thought Records. Due by Feb 16."

---

### COMPLETED
**Member → TherapeuticTechnique**

```
(Rahul) ──[COMPLETED]──→ (Thought Record)
  date: 2026-02-12
  difficulty_rating: 5            ← How hard was it? (1-10)
  helpfulness_rating: 7           ← How helpful was it? (1-10)
```

**Plain English:** "Rahul completed the Thought Record on Feb 12. Found it moderately difficult (5/10) but quite helpful (7/10)."

---

## Group 5: Tracking Change Over Time

### COMPARED_TO
**Assessment → Assessment**

```
(PHQ-9 January, score=18) ──[COMPARED_TO]──→ (PHQ-9 February, score=14)
  delta_score: -4                 ← Score went DOWN by 4 (improvement!)
  direction: "improved"           ← improved / worsened / stable
  days_between: 31
```

**Plain English:** "Rahul's depression score dropped from 18 to 14 over one month. That's improvement."

**Why this matters:** This is how Anchor proves treatment is working. A chain of assessments shows the trend.

---

### REVISED_TO
**CarePlan → CarePlan**

```
(Plan v1) ──[REVISED_TO]──→ (Plan v2)
  reason: "medication dose change, side effects emerged"
  revised_by: "THER-007"
  date: 2026-02-12
```

**Plain English:** "Care Plan v1 was updated to v2 because the medication dose changed and side effects appeared."

---

### EVOLVED_TO
**Diagnosis → Diagnosis**

```
(Generalized Anxiety Disorder) ──[EVOLVED_TO]──→ (Major Depressive Disorder)
  date: 2026-04-01
  reason: "comorbid depression developed"
```

**Plain English:** "Rahul originally had anxiety, but over time depression also developed. The diagnosis evolved."

**Why this matters:** Mental health conditions change. A person might start with anxiety, develop depression, then improve. The graph tracks this journey.

---

### PRECEDED_BY
**Symptom → Symptom**

```
(insomnia) ──[PRECEDED_BY]──→ (rumination)
  pattern: "always"              ← always / often / sometimes
```

**Plain English:** "Whenever Rahul has insomnia, it's ALWAYS preceded by rumination (overthinking). Fix the overthinking → fix the sleep."

**Why this matters:** This is GOLD for therapists. If the AI detects that symptom A always happens before symptom B, the therapist can target the root cause.

---

## Summary: All 27 Relationships at a Glance

| # | Relationship | From → To | Plain English |
|---|---|---|---|
| 1 | TREATED_BY | Member → Therapist | "sees this therapist" |
| 2 | PRESCRIBED_BY | Member → Psychiatrist | "gets meds from this doctor" |
| 3 | COORDINATED_BY | Member → CareCoordinator | "care managed by" |
| 4 | SUPPORTED_BY | Member → FamilyMember | "supported by this person" |
| 5 | CONSULTS_WITH | Therapist → Psychiatrist | "talked to psychiatrist about a case" |
| 6 | SPECIALIZES_IN | Therapist → TherapyType | "trained in this therapy" |
| 7 | DIAGNOSED_WITH | Member → Diagnosis | "has this condition" |
| 8 | EXHIBITS | Member → Symptom | "experiences this symptom" |
| 9 | TAKES | Member → Medication | "takes this medicine" |
| 10 | UNDERGOING | Member → TherapyType | "doing this type of therapy" |
| 11 | ASSESSED_WITH | Member → Assessment | "took this test, got this score" |
| 12 | FOLLOWS | Member → CarePlan | "following this treatment plan" |
| 13 | MANIFESTS_AS | Diagnosis → Symptom | "this condition shows up as..." |
| 14 | TREATS | Medication → Diagnosis | "this drug treats this condition" |
| 15 | CAUSES | Medication → Symptom | "this drug causes this side effect" |
| 16 | INTERACTS_WITH | Medication → Medication | "dangerous to combine these" |
| 17 | INDICATED_FOR | TherapyType → Diagnosis | "this therapy works for this condition" |
| 18 | ATTENDED | Member → Session | "went to this session" |
| 19 | CONDUCTED | Therapist → Session | "ran this session" |
| 20 | HAS_TRANSCRIPT | Session → Transcription | "this session has a transcript" |
| 21 | DISCUSSED | Session → Topic | "this topic came up in session" |
| 22 | PRODUCED | Session → Insight | "AI found this pattern from session" |
| 23 | USED_TECHNIQUE | Session → Technique | "used this exercise in session" |
| 24 | FOLLOWED_BY | Session → Session | "next session after this one" |
| 25 | UPDATED | Session → CarePlan | "care plan changed after this session" |
| 26 | TRIGGERED_ASSESSMENT | Session → Assessment | "this session triggered a test" |
| 27 | WROTE | Member → JournalEntry | "wrote this journal entry" |
| 28 | LOGGED | Member → MoodLog | "logged this mood" |
| 29 | MENTIONS | JournalEntry → Topic | "journal talked about this topic" |
| 30 | REFLECTS_ON | JournalEntry → Session | "journal reflects on a past session" |
| 31 | TRIGGERED_BY | MoodLog → Topic | "mood was triggered by this topic" |
| 32 | ASSIGNED | Member → Technique | "was given this homework" |
| 33 | COMPLETED | Member → Technique | "finished this homework" |
| 34 | COMPARED_TO | Assessment → Assessment | "score compared to previous score" |
| 35 | REVISED_TO | CarePlan → CarePlan | "plan was updated to new version" |
| 36 | EVOLVED_TO | Diagnosis → Diagnosis | "condition changed over time" |
| 37 | PRECEDED_BY | Symptom → Symptom | "this symptom always comes before that one" |
