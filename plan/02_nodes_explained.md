# All Node Types — Explained Simply

A **node** = a thing we want to remember. Every node has an **id** (unique name) and **properties** (details about it).

---

## 1. MEMBER (The person getting help)

**What is it?** The person who signed up for Anchor to get mental health support.

**Example:**
```
Rahul:
  id: "MEM-042"
  name: "Rahul Verma"
  age: 28
  gender: "male"
  severity_stage: "mild"           ← How serious is his condition right now?
                                      wellness = just maintaining good health
                                      mild = some issues but manageable
                                      moderate = affecting daily life
                                      acute = needs urgent/intensive help
                                      recovery = getting better, maintaining progress
  onboarding_date: 2026-01-10     ← When did he join Anchor?
  primary_concerns: ["anxiety", "insomnia"]  ← Why did he come?
  risk_level: "none"               ← Is he at risk of harming himself?
                                      none / low / moderate / high
  status: "active"                 ← Is he currently using Anchor?
                                      active / paused / discharged
```

**Think of it as:** A patient record card.

---

## 2. THERAPIST (The talking doctor)

**What is it?** A professional who helps members through conversations — teaching them techniques to manage their feelings, understand their thoughts, and change behaviors.

**Example:**
```
Dr. Sharma:
  id: "THER-007"
  name: "Dr. Priya Sharma"
  specializations: ["CBT", "anxiety", "trauma"]
      ↑ What types of problems she's expert in
      CBT = Cognitive Behavioral Therapy (a technique to fix negative thinking patterns)
```

**Think of it as:** A coach who helps you train your mind.

---

## 3. PSYCHIATRIST (The medicine doctor)

**What is it?** A medical doctor who can prescribe pills/medications. They handle the chemical side of mental health.

**Example:**
```
Dr. Mehta:
  id: "PSY-003"
  name: "Dr. Rohan Mehta"
  specializations: ["pharmacotherapy", "mood disorders"]
      ↑ pharmacotherapy = treating with medication
        mood disorders = depression, bipolar, etc.
```

**Think of it as:** A doctor who prescribes medicine for the brain.

---

## 4. CARE_COORDINATOR (The project manager)

**What is it?** Someone who makes sure everything is running smoothly — schedules, follow-ups, connecting the right people.

**Example:**
```
Anita:
  id: "CC-012"
  name: "Anita Desai"
```

**Think of it as:** Like a hospital receptionist + project manager combined.

---

## 5. FAMILY_MEMBER (Support person)

**What is it?** A family member or friend who the member has allowed to be part of their care journey.

**Example:**
```
Priya (Rahul's wife):
  id: "FAM-091"
  name: "Priya Verma"
  relationship: "spouse"
  access_level: "view_progress"    ← What can she see?
      view_progress = can see mood trends, milestone updates
      full = can see everything including session notes
      emergency = only contacted in emergencies
```

**Think of it as:** A family member who gets updates on how the person is doing.

---

## 6. DIAGNOSIS (What's the problem?)

**What is it?** The official name for what's wrong. Doctors use standard codes (like ICD-10) so everyone speaks the same language.

**Example:**
```
GAD:
  id: "DX-042-001"
  name: "Generalized Anxiety Disorder"    ← Fancy name for "worries too much about everything"
  icd10_code: "F41.1"                     ← International standard code (like a product barcode)
  severity: "moderate"                     ← mild / moderate / severe
  status: "active"                         ← active = still has it
                                              in_remission = getting better
                                              resolved = gone
  date_diagnosed: 2026-01-12
  diagnosed_by: "THER-007"
```

**Common diagnoses in mental health:**
| Name | ICD-10 | Simple explanation |
|------|--------|-------------------|
| Generalized Anxiety Disorder (GAD) | F41.1 | Constant worry about everything |
| Major Depressive Disorder (MDD) | F32.x | Deep sadness that won't go away |
| Panic Disorder | F41.0 | Sudden intense fear attacks |
| PTSD | F43.1 | Trauma that keeps coming back |
| OCD | F42 | Unwanted repeated thoughts/behaviors |
| Bipolar Disorder | F31.x | Extreme mood swings (very high to very low) |
| Social Anxiety | F40.1 | Fear of social situations |
| Insomnia Disorder | F51.0 | Can't sleep |

**Think of it as:** A label for the problem, with a universal code.

---

## 7. SYMPTOM (What the person feels)

**What is it?** The specific things the person experiences — feelings, physical sensations, behaviors.

**Example:**
```
Insomnia:
  id: "SYM-002"
  name: "insomnia"                        ← Can't sleep
  category: "physical"                     ← What type of symptom?
      emotional = feelings (sadness, fear, anger)
      cognitive = thinking problems (can't concentrate, overthinking)
      physical = body stuff (can't sleep, headaches, nausea)
      behavioral = actions (avoiding people, not eating)
      social = relationship issues (withdrawing, fighting)
  severity: "moderate"
  frequency: "daily"                       ← How often? daily / weekly / episodic (sometimes)
```

**Common symptoms in mental health:**
| Symptom | Category | What it means |
|---------|----------|---------------|
| Excessive worry | emotional | Can't stop worrying |
| Insomnia | physical | Can't sleep |
| Fatigue | physical | Always tired |
| Rumination | cognitive | Replaying thoughts over and over |
| Hopelessness | emotional | Feeling nothing will get better |
| Social withdrawal | social | Avoiding people |
| Loss of appetite | physical | Not feeling hungry |
| Irritability | emotional | Getting angry easily |
| Panic attacks | physical | Sudden racing heart, sweating, fear |
| Concentration problems | cognitive | Can't focus |

**Think of it as:** The specific complaints the person has.

---

## 8. MEDICATION (The pills)

**What is it?** Medicine prescribed by the psychiatrist.

**Example:**
```
Sertraline:
  id: "MED-042-001"
  brand_name: "Zoloft"                    ← The commercial name (like "iPhone")
  generic_name: "Sertraline"              ← The actual drug name (like "smartphone")
  drug_class: "SSRI"                      ← The type/family of drug
      SSRI = Selective Serotonin Reuptake Inhibitor
             (helps the brain keep more "feel good" chemicals)
  dosage: "50mg"                          ← How much
  frequency: "once daily"                 ← How often
  start_date: 2026-01-15
  end_date: null                          ← null = still taking it
  purpose: "anxiety, depression"          ← Why it was prescribed
  side_effects_noted: ["nausea"]          ← Problems caused by the medicine
```

**Common drug classes in mental health:**
| Class | What it does | Example drugs |
|-------|-------------|---------------|
| SSRI | Increases serotonin (mood chemical) | Sertraline, Fluoxetine, Escitalopram |
| SNRI | Increases serotonin + norepinephrine | Venlafaxine, Duloxetine |
| Benzodiazepine | Calms anxiety quickly (short-term) | Alprazolam, Clonazepam |
| Antipsychotic | Stabilizes thinking | Quetiapine, Olanzapine |
| Mood stabilizer | Prevents mood swings | Lithium, Valproate |
| Sleep aid | Helps sleep | Zolpidem, Melatonin |

**Think of it as:** Which medicine, how much, how often, and any problems it causes.

---

## 9. THERAPY_TYPE (The treatment approach)

**What is it?** The METHOD used by the therapist. Different problems need different approaches.

**Example:**
```
CBT:
  id: "TT-001"
  name: "Cognitive Behavioral Therapy"
  abbreviation: "CBT"
  modality: "individual"                   ← individual / group / family / online
  typical_duration: "12-20 sessions"       ← How long does treatment usually take?
```

**Common therapy types:**
| Abbreviation | Full name | What it does | Best for |
|---|---|---|---|
| CBT | Cognitive Behavioral Therapy | Change negative thinking patterns | Anxiety, depression |
| DBT | Dialectical Behavior Therapy | Manage intense emotions | Borderline personality, self-harm |
| ACT | Acceptance and Commitment Therapy | Accept feelings, take positive action | Anxiety, chronic pain |
| EMDR | Eye Movement Desensitization | Process traumatic memories | PTSD, trauma |
| MI | Motivational Interviewing | Build motivation to change | Addiction, resistance to treatment |
| IPT | Interpersonal Therapy | Fix relationship patterns | Depression, grief |
| Mindfulness | Mindfulness-Based Therapy | Stay present, reduce overthinking | Stress, anxiety, relapse prevention |

**Think of it as:** The playbook the therapist uses.

---

## 10. ASSESSMENT (Measuring progress)

**What is it?** A standardized questionnaire/test to measure how bad (or how improved) something is. Like a "score" for your mental health.

**Example:**
```
PHQ9_January:
  id: "ASM-042-001"
  tool_name: "PHQ-9"                      ← The test name
  full_name: "Patient Health Questionnaire-9"
  score: 18                                ← The result
  max_score: 27                            ← The worst possible score
  interpretation: "moderately severe depression"
  date_administered: 2026-01-12
  administered_by: "THER-007"              ← Who gave the test
  risk_flags: ["item 9 endorsed"]          ← Any danger signs
      ↑ "item 9" on PHQ-9 asks about thoughts of self-harm
```

**Common assessment tools:**
| Tool | Full name | What it measures | Score range | Interpretation |
|------|-----------|-----------------|-------------|----------------|
| PHQ-9 | Patient Health Questionnaire | Depression | 0-27 | 0-4 minimal, 5-9 mild, 10-14 moderate, 15-19 moderately severe, 20-27 severe |
| GAD-7 | Generalized Anxiety Disorder scale | Anxiety | 0-21 | 0-4 minimal, 5-9 mild, 10-14 moderate, 15-21 severe |
| PCL-5 | PTSD Checklist | Trauma/PTSD | 0-80 | 31+ suggests PTSD |
| AUDIT | Alcohol Use Disorder Test | Alcohol problems | 0-40 | 8+ hazardous drinking |
| ISI | Insomnia Severity Index | Sleep problems | 0-28 | 0-7 none, 8-14 mild, 15-21 moderate, 22-28 severe |

**Think of it as:** A report card for mental health. Lower scores = better (usually).

**Why it matters:** If Rahul scores 18 in January and 12 in March, we KNOW he's improving. Without assessments, it's just guessing.

---

## 11. CARE_PLAN (The game plan)

**What is it?** A written plan with goals and steps to achieve them. Like a project plan but for getting better.

**Example:**
```
Plan_v1:
  id: "CP-042-001"
  version: 1                               ← Plans get updated, so we track versions
  goals: [
    "reduce anxiety score (GAD-7) below 10",
    "sleep at least 7 hours per night",
    "reduce depression score (PHQ-9) below 10"
  ]
  interventions: [                          ← What actions are being taken
    "weekly CBT sessions",
    "Sertraline 50mg daily",
    "sleep hygiene education"
  ]
  review_date: 2026-02-12                  ← When to check if it's working
  status: "active"                          ← active / completed / revised
  created_by: "THER-007"
```

**Think of it as:** A to-do list for recovery with deadlines.

---

## 12. THERAPEUTIC_TECHNIQUE (Exercises/homework)

**What is it?** A specific exercise or tool the therapist teaches the member. Like homework but for your mental health.

**Example:**
```
ThoughtRecord:
  id: "TEC-001"
  name: "Thought Record"
  therapy_type: "CBT"                      ← Which therapy approach uses this
  description: "Write down a negative thought, examine the evidence for/against it, and create a balanced thought"
  difficulty: "beginner"                    ← beginner / intermediate / advanced
```

**Common techniques:**
| Technique | Therapy | What you do |
|-----------|---------|-------------|
| Thought Record | CBT | Write down negative thoughts and challenge them |
| Behavioral Activation | CBT | Schedule enjoyable activities to fight depression |
| Distress Tolerance | DBT | Techniques to survive a crisis without making it worse |
| Grounding (5-4-3-2-1) | Various | Name 5 things you see, 4 you hear, 3 you touch... to calm down |
| Progressive Muscle Relaxation | Various | Tense and release muscles to reduce anxiety |
| Exposure Hierarchy | CBT | Gradually face fears from easiest to hardest |
| Mindful Breathing | Mindfulness | Focus on breath to stop overthinking |
| Safety Planning | Crisis | Write a step-by-step plan for when you feel at risk |

**Think of it as:** Homework assignments from the therapist.

---

## 13. SESSION (A meeting/appointment)

**What is it?** A single meeting between the member and a clinician.

**Example:**
```
Session_5:
  id: "SES-042-005"
  session_number: 5                        ← 5th session for this member
  date: 2026-02-09
  duration_minutes: 45
  type: "therapy"                          ← What kind of session?
      therapy = regular therapy session with therapist
      psychiatry = medication review with psychiatrist
      intake = first ever session (assessment + history)
      group = group therapy with multiple members
      crisis = emergency session (member in danger)
      follow_up = quick check-in
  modality: "voice"                        ← How was it conducted?
      voice = audio call
      video = video call
      in_person = face to face
      chat = text chat
  mood_before: 4                           ← Member's mood before session (1-10)
  mood_after: 6                            ← Member's mood after session (1-10)
  severity_at_session: "moderate"
  risk_flags: []                           ← Any danger signs detected?
      Examples: ["passive suicidal ideation", "self-harm mentioned"]
  session_notes: "Discussed work stress..."
```

**Think of it as:** A record of each appointment.

---

## 14. TRANSCRIPTION (What was said)

**What is it?** The text version of what was spoken in a session. The audio gets converted to text.

**Example:**
```
Transcript_5:
  id: "TRN-042-005"
  session_id: "SES-042-005"               ← Links to which session
  word_count: 4500
  speaker_count: 2                         ← 2 people talked (member + therapist)
  language: "en"
```

**IMPORTANT:** The actual text is stored in **Weaviate** (for search), NOT in Neo4j. Neo4j only stores the metadata above.

**Think of it as:** A pointer to the actual conversation text stored elsewhere.

---

## 15. JOURNAL_ENTRY (Member's diary)

**What is it?** When a member writes about how they're feeling — like a digital diary within Anchor.

**Example:**
```
Journal_15:
  id: "JRN-042-015"
  date: 2026-02-11
  mood_score: 4                            ← How they felt (1-10)
  themes: ["work stress", "insomnia"]      ← What topics came up
  word_count: 180
  sentiment: -0.3                          ← Positive or negative? (-1.0 to +1.0)
                                              -1.0 = very negative
                                               0.0 = neutral
                                              +1.0 = very positive
```

**Actual text stored in Weaviate, not Neo4j.**

**Think of it as:** A diary entry with mood metadata.

---

## 16. TOPIC (What was discussed)

**What is it?** A subject that comes up in sessions, journals. We track topics to find patterns.

**Example:**
```
WorkStress:
  id: "TOP-001"
  name: "work deadline pressure"
  category: "trigger"                      ← What kind of topic?
      trigger = something that makes symptoms worse
      coping_strategy = something that helps
      life_event = something that happened (divorce, job loss)
      relationship = about a specific person/relationship
      symptom = about a symptom itself
      goal = something they want to achieve
      barrier = something blocking progress
      strength = something positive about them
      trauma = a past traumatic event
  sentiment: "negative"                    ← How they feel about this topic
```

**Think of it as:** Tags/categories for what people talk about.

---

## 17. INSIGHT (AI-discovered pattern)

**What is it?** Something the AI (Claude/gpt) noticed by analyzing sessions. Patterns that might take a human weeks to spot.

**Example:**
```
Insight_1:
  id: "INS-042-005-001"
  text: "Work deadlines consistently trigger anxiety spirals — member catastrophizes about losing job"
  type: "behavioral_pattern"               ← What kind of insight?
      behavioral_pattern = a repeating behavior (e.g., "always avoids conflict")
      therapeutic_breakthrough = a positive shift (e.g., "first time challenged a negative thought")
      risk_indicator = something concerning (e.g., "mentioned hopelessness 3 sessions in a row")
      progress_marker = evidence of improvement (e.g., "sleep improved from 3 to 6 hours")
      treatment_response = how they respond to treatment (e.g., "Sertraline reducing anxiety but causing nausea")
  confidence: 0.85                         ← How sure is the AI? (0.0 to 1.0)
  source_session: "SES-042-005"
  extracted_by: "claude-sonnet-4"
```

**Think of it as:** The AI's "aha!" moments — patterns it discovers from reading many sessions.

---

## Summary: All 18 Node Types at a Glance

| # | Node | One-line description | Real example |
|---|------|---------------------|--------------|
| 1 | Member | Person getting help | Rahul, 28, anxious, can't sleep |
| 2 | Therapist | Talking doctor | Dr. Sharma, expert in CBT |
| 3 | Psychiatrist | Medicine doctor | Dr. Mehta, prescribes pills |
| 4 | CareCoordinator | Care manager | Anita, manages schedules |
| 5 | FamilyMember | Support person | Priya, Rahul's wife |
| 6 | Diagnosis | What's wrong (official label) | "Generalized Anxiety Disorder" (F41.1) |
| 7 | Symptom | What they feel/experience | Insomnia, excessive worry, nausea |
| 8 | Medication | Pills they take | Sertraline (Zoloft) 50mg daily |
| 9 | TherapyType | Treatment method | CBT (learn to fix negative thinking) |
| 10 | Assessment | Score/test result | PHQ-9 score = 18 (depression level) |
| 11 | CarePlan | Goals + actions | "Reduce anxiety, sleep 7 hrs, weekly CBT" |
| 12 | TherapeuticTechnique | Homework exercises | Thought Record (write & challenge worries) |
| 13 | Session | An appointment | Session 5, 45 min, voice call |
| 14 | Transcription | Text of what was said | (stored in Weaviate for search) |
| 15 | JournalEntry | Member's diary entry | "Can't stop worrying about work..." |
| 16 | Topic | What was discussed | "work stress" (trigger), "sleep" (goal) |
| 17 | Insight | AI-discovered pattern | "Deadlines always trigger anxiety spirals" |
