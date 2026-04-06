# Full Example: Rahul's Journey Through the Graph

This shows **every node and relationship** created as Rahul uses Anchor.

---

## Week 1: Rahul Signs Up

**What happens:** Rahul downloads Anchor. He says he's anxious and can't sleep.

**Nodes created:**
```
(Rahul:Member)  ←  id: MEM-042, age: 28, severity_stage: mild,
                   primary_concerns: [anxiety, insomnia], status: active

(Priya:FamilyMember)  ←  relationship: spouse, access_level: view_progress
```

**Relationships created:**
```
Rahul ──[SUPPORTED_BY]──→ Priya
```

**Graph so far:**
```
[Rahul] ────supports────→ [Priya (wife)]
```

---

## Week 1: Care Team Assigned

**What happens:** Anchor matches Rahul with a therapist, psychiatrist, and coordinator.

**Relationships created:**
```
Rahul ──[TREATED_BY]──→ Dr. Sharma (therapist)
Rahul ──[PRESCRIBED_BY]──→ Dr. Mehta (psychiatrist)
Rahul ──[COORDINATED_BY]──→ Anita (coordinator)
```

**Graph so far:**
```
                [Dr. Sharma]
                     ↑
                 treated_by
                     |
[Anita] ←──coord──[Rahul] ──prescribed_by──→ [Dr. Mehta]
                     |
                supports
                     ↓
                  [Priya]
```

---

## Week 1: First Session (Intake)

**What happens:** Dr. Sharma talks to Rahul for an hour. She figures out he has anxiety disorder. She gives him two tests (PHQ-9 and GAD-7).

**Nodes created:**
```
(Session 1:Session)  ←  type: intake, duration: 60 min, mood_before: 3, mood_after: 5

(GAD:Diagnosis)  ←  name: Generalized Anxiety Disorder, icd10: F41.1, severity: moderate

(PHQ-9 Jan:Assessment)  ←  score: 18/27, interpretation: moderately severe depression
(GAD-7 Jan:Assessment)  ←  score: 15/21, interpretation: severe anxiety

(Worry:Symptom)  ←  name: excessive worry, category: emotional
(Insomnia:Symptom)  ←  name: insomnia, category: physical
(Rumination:Symptom)  ←  name: rumination, category: cognitive
```

**Relationships created:**
```
Rahul ──[ATTENDED]──→ Session 1         (mood: 3→5, engagement: high)
Dr. Sharma ──[CONDUCTED]──→ Session 1

Rahul ──[DIAGNOSED_WITH]──→ GAD         (by Dr. Sharma)
Rahul ──[ASSESSED_WITH]──→ PHQ-9 Jan    (context: intake)
Rahul ──[ASSESSED_WITH]──→ GAD-7 Jan    (context: intake)

Rahul ──[EXHIBITS]──→ Worry             (first reported: session 1)
Rahul ──[EXHIBITS]──→ Insomnia          (first reported: session 1)
Rahul ──[EXHIBITS]──→ Rumination        (first reported: session 1)

GAD ──[MANIFESTS_AS]──→ Worry           (typical: yes)
GAD ──[MANIFESTS_AS]──→ Insomnia        (typical: yes)

Session 1 ──[TRIGGERED_ASSESSMENT]──→ PHQ-9 Jan  (reason: routine)
```

**Graph so far:**
```
                    [Dr. Sharma]
                     ↑        \
                 treated_by    conducted
                     |           \
[Worry] ←──exhibits──[Rahul]──attended──→ [Session 1] ──triggered──→ [PHQ-9: 18]
[Insomnia] ←──exhibits──↑        ↑
[Rumination] ←──exhibits─┘        |
                     |         assessed_with
                diagnosed_with    |
                     ↓        [GAD-7: 15]
              [GAD (F41.1)]
                     |
                manifests_as
                     ↓
            [Worry] [Insomnia]
```

---

## Week 1: Medication Prescribed

**What happens:** Dr. Mehta prescribes Sertraline 50mg for anxiety.

**Nodes created:**
```
(Sertraline:Medication)  ←  generic: Sertraline, brand: Zoloft, class: SSRI,
                            dosage: 50mg, frequency: once daily
```

**Relationships created:**
```
Rahul ──[TAKES]──→ Sertraline          (adherence: 90%, prescribed by Dr. Mehta)
Sertraline ──[TREATS]──→ GAD           (efficacy: first_line)
```

---

## Week 1: Treatment Plan Created

**What happens:** Dr. Sharma creates a care plan with goals.

**Nodes created:**
```
(CBT:TherapyType)  ←  name: Cognitive Behavioral Therapy

(Plan v1:CarePlan)  ←  goals: [reduce GAD-7 below 10, sleep 7+ hrs, reduce PHQ-9 below 10]
                       interventions: [weekly CBT, Sertraline 50mg, sleep hygiene]
```

**Relationships created:**
```
Rahul ──[UNDERGOING]──→ CBT            (progress: early, sessions: 1)
Rahul ──[FOLLOWS]──→ Plan v1           (adherence: 85%)
CBT ──[INDICATED_FOR]──→ GAD           (evidence: strong)
Dr. Sharma ──[SPECIALIZES_IN]──→ CBT
```

---

## Week 5: Session 5 — Things Start Changing

**What happens:** 4th regular session. Rahul talks about work stress. Dr. Sharma teaches him the "Thought Record" technique.

**Nodes created:**
```
(Session 5:Session)  ←  type: therapy, duration: 45 min, mood: 4→6

(WorkStress:Topic)  ←  name: work deadline pressure, category: trigger
(SleepGoal:Topic)  ←  name: sleep improvement, category: goal

(ThoughtRecord:TherapeuticTechnique)  ←  name: Thought Record, therapy_type: CBT

(Insight1:Insight)  ←  "Work deadlines consistently trigger anxiety spirals"
                       type: behavioral_pattern, confidence: 0.85
```

**Relationships created:**
```
Rahul ──[ATTENDED]──→ Session 5         (mood: 4→6, engagement: high)
Dr. Sharma ──[CONDUCTED]──→ Session 5
Session 4 ──[FOLLOWED_BY]──→ Session 5  (7 days between)

Session 5 ──[DISCUSSED]──→ WorkStress   (depth: deep, 20 minutes)
Session 5 ──[DISCUSSED]──→ SleepGoal    (depth: moderate, 10 minutes)
Session 5 ──[USED_TECHNIQUE]──→ ThoughtRecord  (response: receptive, homework: yes)
Session 5 ──[PRODUCED]──→ Insight1

Rahul ──[ASSIGNED]──→ ThoughtRecord     (due: Feb 16)
```

---

## Between Sessions: Rahul Journals & Logs Mood

**What happens:** 2 days after session 5, Rahul can't sleep. He writes in his journal and logs his mood.

**Nodes created:**
```
(Journal1:JournalEntry)  ←  mood_score: 4, themes: [work stress, insomnia]
                            sentiment: -0.3

(MoodLog1:MoodLog)  ←  mood: low, energy: 3, sleep_hours: 3.5,
                       notes: "can't stop thinking about tomorrow's meeting"
```

**Relationships created:**
```
Rahul ──[WROTE]──→ Journal1
Journal1 ──[MENTIONS]──→ WorkStress     (sentiment: -0.4)
Journal1 ──[REFLECTS_ON]──→ Session 5   (2 days after)

Rahul ──[LOGGED]──→ MoodLog1
MoodLog1 ──[TRIGGERED_BY]──→ WorkStress (intensity: 8/10)
```

**What this tells us:** Rahul is still stressed about work even after the session. The same topic (WorkStress) appears in the session, the journal, AND the mood log — the graph connects all three.

---

## Week 5: Rahul Does His Homework

**What happens:** Rahul practices the Thought Record technique his therapist assigned.

**Relationship created:**
```
Rahul ──[COMPLETED]──→ ThoughtRecord    (difficulty: 5/10, helpfulness: 7/10)
```

---

## Week 6: Monthly Assessment

**What happens:** Rahul takes the PHQ-9 test again. Score went from 18 to 14.

**Nodes created:**
```
(PHQ-9 Feb:Assessment)  ←  score: 14/27, interpretation: moderate depression
```

**Relationships created:**
```
Rahul ──[ASSESSED_WITH]──→ PHQ-9 Feb    (context: routine)

PHQ-9 Jan (score 18) ──[COMPARED_TO]──→ PHQ-9 Feb (score 14)
  delta_score: -4
  direction: "improved"
  days_between: 31
```

**What this tells us:** Score dropped from 18 → 14. That's a 4-point improvement in one month. Treatment is working.

---

## Week 8: Dose Increase + Side Effects

**What happens:** Dr. Mehta increases Sertraline from 50mg to 100mg. Two weeks later, Rahul feels nauseous every morning and sleep got worse.

**Nodes created:**
```
(Nausea:Symptom)  ←  name: nausea, category: physical, severity: mild, frequency: daily
(Hopelessness:Symptom)  ←  name: hopelessness, category: emotional, severity: moderate

(Insight2:Insight)  ←  "Sleep regression correlates with Sertraline dose increase"
                       type: treatment_response

(Insight3:Insight)  ←  "Passive hopelessness — denies suicidal intent but questions point of treatment"
                       type: risk_indicator, confidence: 0.80
```

**Relationships created:**
```
Rahul ──[EXHIBITS]──→ Nausea                (first reported: session 8)
Rahul ──[EXHIBITS]──→ Hopelessness          (first reported: session 8)

Sertraline ──[CAUSES]──→ Nausea             (likelihood: common, onset: 2 weeks after increase)

Dr. Sharma ──[CONSULTS_WITH]──→ Dr. Mehta   (reason: medication side effects)

Session 8 ──[PRODUCED]──→ Insight2
Session 8 ──[PRODUCED]──→ Insight3
```

**What this tells us:** The graph now shows a CAUSAL CHAIN:
```
Sertraline dose increased → Nausea appeared → Sleep got worse → Hopelessness developed
```
A text search would never connect these dots.

---

## Week 8: Care Plan Updated

**What happens:** Because of the side effects, the care plan is revised.

**Nodes created:**
```
(Plan v2:CarePlan)  ←  goals: [reduce GAD-7 below 10, sleep 7+ hrs, manage side effects]
                       interventions: [weekly CBT, Sertraline 100mg, sleep hygiene,
                                       discuss side effects with psychiatrist]
```

**Relationships created:**
```
Plan v1 ──[REVISED_TO]──→ Plan v2       (reason: medication change + side effects)

Session 8 ──[UPDATED]──→ Plan v2        (changes: [increased dose, added side effect monitoring])
```

---

## Later: Patterns the AI Discovers

Over many sessions, the AI notices:

```
Insomnia ──[PRECEDED_BY]──→ Rumination   (pattern: always)
```
"Every time Rahul can't sleep, it's because he was overthinking first."

```
GAD ──[EVOLVED_TO]──→ Major Depressive Disorder  (reason: comorbid depression developed)
```
"Rahul's anxiety eventually led to depression too."

---

## The Complete Graph for Rahul

```
                     [Anita]
                        ↑
                   coordinated_by
                        |
[Priya] ←─supported─[RAHUL]──treated_by──→ [Dr. Sharma] ──specializes_in──→ [CBT]
                     / | | \                    |     \
          diagnosed   | | takes              conducted  consults_with
             with     | |    \                  |           \
              ↓       | |     ↓                 ↓            ↓
          [GAD]       | | [Sertraline]    [Sessions 1-8]  [Dr. Mehta]
            |         | |     |                 |
       manifests_as   | |   causes          discussed
            ↓         | |     ↓                 ↓
     [Worry]          | | [Nausea]        [Topics: work stress,
     [Insomnia] ←─────┘ |                  sleep, hopelessness]
     [Rumination]        |                      |
                         |                   produced
                    exhibits                    ↓
                         ↓              [Insights: "deadlines
                   [Hopelessness]        trigger anxiety",
                                        "sleep regression from
                                         dose increase"]

                [PHQ-9: 18] ──compared_to──→ [PHQ-9: 14] ──→ [PHQ-9: 12]
                                              direction: improved!

                [Plan v1] ──revised_to──→ [Plan v2]

                [Journal] ──mentions──→ [work stress]
                          ──reflects_on──→ [Session 5]

                [Mood Log] ──triggered_by──→ [work stress]
```

---

## What Can We Ask This Graph?

Now that everything is connected, we can answer questions like:

| Question | How the graph answers it |
|----------|------------------------|
| "Is Rahul getting better?" | Follow PHQ-9 chain: 18 → 14 → 12. Yes, improving. |
| "Is the medication helping?" | Sertraline → TREATS → GAD. PHQ-9 improving. But CAUSES → nausea. Mixed. |
| "What triggers Rahul's anxiety?" | Find Topics connected to Sessions via DISCUSSED where category = trigger. Answer: work deadlines. |
| "What should we focus on next session?" | Insomnia PRECEDED_BY Rumination (always). Target rumination. Hopelessness flagged — follow up. |
| "Is Rahul doing his homework?" | ASSIGNED → Thought Record. COMPLETED → yes, found it helpful (7/10). |
| "How's the care plan going?" | FOLLOWS Plan v2, adherence: 85%. Goals partially met. |
| "Who else has similar issues?" | Find Members DIAGNOSED_WITH GAD + EXHIBITS insomnia + UNDERGOING CBT. Match for group therapy. |
| "Are there dangerous drug interactions?" | Check INTERACTS_WITH for any of Rahul's medications. |
